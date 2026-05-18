package main

import (
    "fmt"
    "math/rand"
    "os"
    "strconv"
    "sync"
    "time"
)

type Message struct {
    From int
    To   int
}

type Server struct {
    in    chan Message
    done  chan struct{}
    users []chan Message
}

func NewServer(users []chan Message) *Server {
    return &Server{
        in:    make(chan Message),
        done:  make(chan struct{}),
        users: users,
    }
}

func (s *Server) Run(done chan<- struct{}) {
    completed := 0
    total := len(s.users)
    for completed < total {
        select {
        case msg := <-s.in:
            fmt.Printf("Serwer otrzymal message do %d\n", msg.To)
            fmt.Printf("Serwer wysyla do %d\n", msg.To)
            s.users[msg.To] <- msg
        case <-s.done:
            completed++
        }
    }

    for _, ch := range s.users {
        close(ch)
    }

    fmt.Println("Serwer skonczyl prace")
    close(done)
}

func runSender(id int, messages int, s *Server, wg *sync.WaitGroup) {
    defer wg.Done()

    rng := rand.New(rand.NewSource(time.Now().UnixNano() + int64(id)))
    for i := 0; i < messages; i++ {
        target := rng.Intn(len(s.users))
        fmt.Printf("Wysylam wiadomosc do %d\n", target)
        s.in <- Message{From: id, To: target}
    }

    s.done <- struct{}{}
}

func startReceiver(id int, in <-chan Message, wg *sync.WaitGroup) {
    wg.Add(1)
    go func() {
        defer wg.Done()
        for range in {
            fmt.Printf("User %d otzymalem wiadomosc.\n", id)
        }
    }()
}

func parseArgs() (int, int) {
    if len(os.Args) < 3 {
        fmt.Println("usage: main <users> <messages_per_user>")
        os.Exit(1)
    }

    users, err1 := strconv.Atoi(os.Args[1])
    messages, err2 := strconv.Atoi(os.Args[2])
    if err1 != nil || err2 != nil || users <= 0 || messages < 0 {
        fmt.Println("usage: main <users> <messages_per_user>")
        os.Exit(1)
    }

    return users, messages
}

func main() {
    users, messages := parseArgs()

    userChans := make([]chan Message, users)
    for i := 0; i < users; i++ {
        userChans[i] = make(chan Message)
    }

    server := NewServer(userChans)

    var recvWg sync.WaitGroup
    for i := 0; i < users; i++ {
        startReceiver(i, userChans[i], &recvWg)
    }

    serverDone := make(chan struct{})
    go server.Run(serverDone)

    var sendWg sync.WaitGroup
    sendWg.Add(users)
    for i := 0; i < users; i++ {
        go runSender(i, messages, server, &sendWg)
    }

    sendWg.Wait()
    <-serverDone
    recvWg.Wait()
}
