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

func waiter(N int, requestCh <-chan *Philosopher, releaseCh <-chan struct{}, thankYouCh <-chan struct{}, done chan<- struct{}) {
	forks := N
	queue := make([]*Philosopher, 0)
	finished := 0
	for {
		// if possible, grant to queued philosophers
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
				// all done
				done <- struct{}{}
				return
			}
		}
	}
}

func philosopher(id, hunger int, requestCh chan<- *Philosopher, releaseCh chan<- struct{}, thankYouCh chan<- struct{}, wg *sync.WaitGroup) {
	defer wg.Done()
	p := &Philosopher{id: id, grant: make(chan struct{})}
	for i := 0; i < hunger; i++ {
		requestCh <- p
		<-p.grant
		fmt.Printf("Filozof %d je.\n", id)
		time.Sleep(100 * time.Millisecond)
		releaseCh <- struct{}{}
	}
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

	var wg sync.WaitGroup
	wg.Add(N)

	go waiter(N, requestCh, releaseCh, thankYouCh, done)

	for i := 1; i <= N; i++ {
		go philosopher(i, hunger, requestCh, releaseCh, thankYouCh, &wg)
	}

	<-done
	wg.Wait()
	fmt.Println("Wszyscy filozofowie zakonczone.")
}
