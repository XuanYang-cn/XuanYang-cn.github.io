---
title: "Go profiling tools"
date: 2021-03-26T14:52:08+08:00
draft: false
toc: true
images:
categories:
  - language
  - golang
tags:
  - golang
  - profiling
  - tool
---
# How to profile in Go?

## How to choose tools for profiling?

**PProf:** CPU, Mem, Goroutinue Blocking, Graphics, Goroutines, Mutexes

**Trace:** Goroutine creation/blocking/unblocking, syscall enter/exit/block, GC-related events, changes of heap size, processor start/stop, etc.

**dlv:** Single step debugging

**gdb:** Single step debugging

## Basic Usages of Tools
### 1. GCTRACE
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
### 2. PProf

#### 1. How to generate profiling files?

**For go unit tests, use gotest's standard `-cpuprofile` and `-memprofile` flags**

See [Testing flags](https://pkg.go.dev/cmd/go#hdr-Testing_flags)

For example, this will run unit tests matchs `BinlogIO` in package `datanode`
and generate `datanode.test`, `cpu.prof` and `mem.prof`
```shell
milvus/internal/datanode$ go test -cpuprofile cpu.prof -memprofile mem.prof -run BinlogIO
```
**For a standalone program, use `runtime/pprof`**

To add equivalent profilling support to a standalone program, add the following codes into your main function[]
```golang
// ...

// ref@[3] https://pkg.go.dev/runtime/pprof#hdr-Profiling_a_Go_program
var cpuprofile = flag.String("cpuprofile", "", "write cpu profile to `file`")
var memprofile = flag.String("memprofile", "", "write memory profile to `file`")

func main() {
    flag.Parse()
    if *cpuprofile != "" {
        f, err := os.Create(*cpuprofile)
        if err != nil {
            log.Fatal("could not create CPU profile: ", err)
        }
        defer f.Close() // error handling omitted for example
        if err := pprof.StartCPUProfile(f); err != nil {
            log.Fatal("could not start CPU profile: ", err)
        }
        defer pprof.StopCPUProfile()
    }

    // ... rest of the program ...

    if *memprofile != "" {
        f, err := os.Create(*memprofile)
        if err != nil {
            log.Fatal("could not create memory profile: ", err)
        }
        defer f.Close() // error handling omitted for example
        runtime.GC() // get up-to-date statistics
        if err := pprof.WriteHeapProfile(f); err != nil {
            log.Fatal("could not write memory profile: ", err)
        }
    }
}
```

**For a long-running server, use `net/http/pprof`**

> ref: https://pkg.go.dev/net/http/pprof

Adding these lines in your  main function:
```golang
import (
    "fmt"
    _ "net/http/pprof"
    "net/http"
)

go func(){
    fmt.Println(http.ListenAndServe("localhost:9876", nil))
}()
```

Then use pprof tool to look at the heap profile:
```
go tool pprof http://localhost:9876/debug/pprof/heap
```

Or to look at a 30-second CPU profile:
```
go tool pprof http://localhost:9876/debug/pprof/profile?seconds=30
```

Or to look at the goroutine blocking profile, after calling `runtime.SetBolckProfileRate` in your program:
```
go tool pprof http://localhost:9876/debug/pprof/block
```

Or to look at the holders of contended mutexes, after calling `runtime.SetMutexProfileFraction` in your program:
```
go tool pprof http://localhost:9876/debug/pprof/mutex
```

The package also exports a handler that serves execution trace data fro the "go tool trace" command. To collect a
5-second execution trace:
```
wget -O trace.out http://localhost:9876/debug/pprof/trace?seconds=5
go tool trace trace.out
```

To view all avaliable profiles, open `http://localhost:9876/debug/pprof` in your browser.

#### 2. How to use the generated profiling files?

**Visulization:**

This command uses `datanode.test` (binary) and `cpu.prof` (profiling file) to exam cpu profilings, and provides web
interface and automaticaly opening a browser at `localhost:9999`

```
milvus/internal/datanode$ go tool pprof -http localhost:9999 datanode.test cpu.prof
```

You are able to check everything on the browser, especially graphics, just click around

**Command line:**

This line will establish an interactive pprof shell
```
milvus/internal/datanode$ go tool pprof datanode.test cpu.prof

File: datanode.test
Build ID: 3f1cb676163b24145d3945e5169154a6ce31813d
Type: cpu
Time: Dec 17, 2021 at 4:07pm (CST)
Duration: 301.42ms, Total samples = 50ms (16.59%)
Entering interactive mode (type "help" for commands, "o" for options)
(pprof)
```

Check top10 cum:
```
(pprof) top10 -cum
Showing nodes accounting for 20ms, 40.00% of 50ms total
Showing top 10 nodes out of 23
      flat  flat%   sum%        cum   cum%
         0     0%     0%       50ms   100%  github.com/milvus-io/milvus/internal/datanode.(*binlogIO).genInsertBlobs
         0     0%     0%       50ms   100%  github.com/milvus-io/milvus/internal/storage.(*InsertCodec).Serialize
         0     0%     0%       50ms   100%  testing.tRunner
         0     0%     0%       30ms 60.00%  encoding/json.(*encodeState).marshal
         0     0%     0%       30ms 60.00%  encoding/json.(*encodeState).reflectValue
         0     0%     0%       30ms 60.00%  encoding/json.Marshal
      20ms 40.00% 40.00%       30ms 60.00%  encoding/json.compact
         0     0% 40.00%       30ms 60.00%  encoding/json.marshalerEncoder
         0     0% 40.00%       30ms 60.00%  encoding/json.ptrEncoder.encode
         0     0% 40.00%       30ms 60.00%  encoding/json.structEncoder.encode
```

**Comparation:**

```shell
$ curl -s http://localhost:9876/debug/pprof/heap > first.heap

# sometime later
$ curl -s http://localhost:9876/debug/pprof/heap > second.heap
```

Then you can compare them by:
```shell
go tool pprof -base first.heap second.heap
```

Please see [pprof README](https://github.com/google/pprof/blob/master/doc/README.md) for more `pprof` details.

### 3. Trace

#### 1. How to generate trace files?

**`go test -trace`**

Genetage a trace file with `go test`:
```
go test -trace trace.out pkg
```

**`runtime/trace.Start`**

**`net/http/pprof package`**: see above.

#### 2. How to use trace file?

View trace in web browser(**NOET: only tested on `Chrome/Chrominum`**):
```
go tool trace trace.out
```

Generate a pprof-like profile from the trace:
```
go tool trace -pprof=TYPE trace.out > TYPE.pprof
```

Supported profile tyes are:
```
- net: network blocking profile
- sync: synchronization blocking profile
- syscall: syscall blocking profile
- sched: scheduler latency profile
```

Then you can ues the pprof tool to analyze the profile:
```
go tool pprof TYPE.pprof
```

### 4. dlv
 > ref: https://github.com/go-delve/delve

Delve is a debugger for the Go programming language. The goal of the project is to provide a simple, full featured debugging tool for Go.

#### 2.1 Installation

ref [delve install](https://github.com/go-delve/delve/tree/master/Documentation/installation)

### 5. gdb

---

**References:**

[1] Doc of go testing flags. *https://pkg.go.dev/cmd/go#hdr-Testing_flags*

[2] Doc of `net/http/pprof`. *https://pkg.go.dev/net/http/pprof* `go doc net/http/pprof`

[3] Doc of `runtime/pprof`. *https://pkg.go.dev/runtime*. `go doc runtime/pprof`

[4] Full useage of tool `pprof`. *https://github.com/google/pprof/blob/master/doc/README.md*

[5] Go blog: Profiling Go Programs. *https://go.dev/blog/pprof*

[6] Doc of `cmd/trace`. *https://pkg.go.dev/cmd/trace*. `go doc cmd/trace`

[7] Doc of `cmd/pprof`. *https://pkg.go.dev/cmd/pprof*. `go doc cmd/pprof`

[8] Doc of `runtime/trace`. *https://pkg.go.dev/runtime/trace* `go doc runtim/trace`

[9] GopherCon 2017: An Introduction to go tool trace. *https://about.sourcegraph.com/go/an-introduction-to-go-tool-trace-rhys-hiltner/*

[10] GopherCon 2019: Two Go programs, three different profiling techniques, in 50 miniutes. [link](https://about.sourcegraph.com/go/gophercon-2019-two-go-programs-three-different-profiling-techniques-in-50-minutes/), [Youtube](https://www.youtube.com/watch?v=nok0aYiGiYA&list=PL2ntRZ1ySWBdDyspRTNBIKES1Y-P__59_&index=9)
