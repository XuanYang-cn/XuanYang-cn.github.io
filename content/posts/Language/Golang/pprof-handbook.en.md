---
title: "Go pprof Ref"
date: 2021-03-26T14:52:08+08:00
draft: false
toc: false
images:
categories:
  - language
tags:
  - memleak
  - golang
  - pprof
  - tool
---

## GCTRACE
>gctrace: setting gctrace=1 causes the garbage collector to emit a single line to standard
error at each collection, summarizing the amount of memory collected and the
length of the pause. The format of this line is subject to change.
Currently, it is:
```
    gc # @#s #%: #+#+# ms clock, #+#/#/#+# ms cpu, #->#-># MB, # MB goal, # P
```
where the fields are as follows:
```
    gc #        the GC number, incremented at each GC
    @#s         time in seconds since program start
    #%          percentage of time spent in GC since program start
    #+...+#     wall-clock/CPU times for the phases of the GC
    #->#-># MB  heap size at GC start, at GC end, and live heap
    # MB goal   goal heap size
    # P         number of processors used
```

Change environment variable `GODEBUG='gctrace=1'`, then Go will output gc log to stdout.

```
gc 21 @8.223s 0% 0.032+3.0+0.12ms clock, 1.6+2.8/14/10+4.0 ms cpu, 87->88->45 MB, 89 MB goal, 24 P
```
## pprof listen to a port
Add these lines in program.
```go
import (
    "fmt"
    _ "net/http/pprof"
    "net/http"
)

go func(){
    fmt.Println(http.ListenAndServe("localhost:9876", nil))
}()
```
Open `http://127.0.0.1:9876/debug/pprof` in web browser.
## Exam pprof in web browser
Mostly, we are concerned about `goroutine` and `heap` and cpu `profile`.

```shell
$ curl -s http://127.0.0.1:9876/debug/pprof/heap > first.heap

# sometime later
$ curl -s http://127.0.0.1:9876/debug/pprof/heap > second.heap
```

we can compare them by
```
go tool pprof -base first.heap second.heap
```

We can also look at a 30-second CPU profile
```
go tool pprof http://127.0.0.1:9876/debug/pprof/profile?seconds=30
```
**reference**

    [1] [The Go Blog: Profiling Go Programs](https://blog.golang.org/pprof)
    [2] [Go http pprof doc](https://golang.org/pkg/net/http/pprof/)
