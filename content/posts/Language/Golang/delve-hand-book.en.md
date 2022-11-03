---
title: "Delve Hand Book"
date: 2021-02-18T15:34:42+08:00
draft: false
categories:
  - golang
  - language
tags:
  - golang
  - debug
  - tool
---

## Launch a session

**`dlv debug`** works like `go run`, it will build an run a GO package

**`dlv exec`** will start a seesion with a precompiled binary, in order to properly debug a binary,
          it shoud be compiled with optimizations disablesd, eg. with `-gcflags="all=-N -l"`

**`dlv attach`** will attach to a PID of a runnig Go binary

## Delve commands in a debugging session

**`print, p`**

**`whatis`** will print the datatype of an expression

**`locals`** will print all variables in the current execution step

**`args`** will print the current fucntion's arguments

**`vars`** will print the avaliable package variables

**`funcs`** will print the avaliable functions

**`types`** will print the avaliable types

**`list`** display the code around the current execution step or a specific linespec.

## Breakpoints

**`break, b`**:
- Break at a specific line, sucn as `break main.go:15`
- Break at a relative point int a file `break +5`
- Whenever a function is called or defined, as `break main.myfunc`

**`breakpoints, bp`**: display all breakpoints along with their IDs.

**`condition, cond`**: set smarter stop conditions and not halt execution in a specific line, but whenever a
given condition is met.

**`clear`** and **`clear all`** can be used to clear a specific or all breakpoints.

**`trace`**: a breakpoint that doesn't halt execution, but print message whenever eht execution passes
through that point

## Move one step at a time!

**`continue, c`** runs until the next breakpoint or program termination

**`next, n`** N steps over N source lines, staying int the same function

**`step, s`** performs a single step forward in the application. If the next step is another fucntion,
it will descent to its call.

**`stepout, so`** steps out of the current function

**`restart`** restart the debugging session, but keeps breakpoints and conditions
