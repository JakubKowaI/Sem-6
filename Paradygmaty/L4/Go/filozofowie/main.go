package main

import (
	"fmt"
	"os"
	"strconv"
	"sync"
	"time"
)

type Philosopher struct {
	id    int
	grant chan struct{}
}

type Result struct {
	id    int
	eaten int
}

func waiter(N int, requestCh <-chan *Philosopher, releaseCh <-chan struct{}, thankYouCh <-chan struct{}, done chan<- struct{}) {
	forks := N
	queue := make([]*Philosopher, 0)
	finished := 0
	for {
		if forks >= 2 && len(queue) > 0 {
			p := queue[0]
			queue = queue[1:]
			forks -= 2
			p.grant <- struct{}{}
			continue
		}

		select {
		case p := <-requestCh:
			queue = append(queue, p)
		case <-releaseCh:
			forks += 2
		case <-thankYouCh:
			finished++
			if finished == N {
				done <- struct{}{}
				return
			}
		}
	}
}

func philosopher(id, hunger int, requestCh chan<- *Philosopher, releaseCh chan<- struct{}, thankYouCh chan<- struct{}, resultCh chan<- Result, wg *sync.WaitGroup) {
	defer wg.Done()
	p := &Philosopher{id: id, grant: make(chan struct{})}
	eaten := 0
	for i := 0; i < hunger; i++ {
		requestCh <- p
		<-p.grant
		time.Sleep(100 * time.Millisecond)
		releaseCh <- struct{}{}
		eaten++
	}
	resultCh <- Result{id: id, eaten: eaten}
	thankYouCh <- struct{}{}
}

func main() {
	N := 5
	hunger := 3
	if len(os.Args) >= 2 {
		n, err := strconv.Atoi(os.Args[1])
		if err == nil {
			N = n
		}
	}
	if len(os.Args) >= 3 {
		h, err := strconv.Atoi(os.Args[2])
		if err == nil {
			hunger = h
		}
	}

	requestCh := make(chan *Philosopher)
	releaseCh := make(chan struct{})
	thankYouCh := make(chan struct{})
	done := make(chan struct{})
	resultCh := make(chan Result, N)

	var wg sync.WaitGroup
	wg.Add(N)

	go waiter(N, requestCh, releaseCh, thankYouCh, done)

	for i := 1; i <= N; i++ {
		go philosopher(i, hunger, requestCh, releaseCh, thankYouCh, resultCh, &wg)
	}

	<-done
	wg.Wait()

	results := make([]int, N)
	for i := 0; i < N; i++ {
		r := <-resultCh
		results[r.id-1] = r.eaten
	}

	for i := 1; i <= N; i++ {
		fmt.Printf("Filozof %d\n", i)
		fmt.Printf("%d\n", results[i-1])
	}
}
