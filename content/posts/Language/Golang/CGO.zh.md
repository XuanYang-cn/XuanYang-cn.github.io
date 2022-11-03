---
title: "Cgo: All You Need to Know"
date: 2021-02-23T16:05:20+08:00
draft: false
categories:
  - language
tags:
  - cgo
  - golang
---

## Cgo Intro
Cgo 让 GO 可以调用 C 的代码。 

接下来就用一个简单的例子来介绍 Cgo 的用法。

下面 GO 的 `rand` 包提供了两个方法 `Random` 和 `Seed`， 它们分别调用了 C 的 `random` 和 `srandom` 方法。

```go
package rand

/*
#include <stdlib.h>
*/
import "C"

func Random() int {
    return int(C.random())
}

func Seed(i int) {
    C.srandom(C.uint(i))
}
// ref@https://blog.golang.org/cgo
```
从 `import` 语句来看，`rand` 包引入了 `"C"`， 但是你会发现标准 Go library 里并没有 `C` 这个库。这是因为 `C` 是一个伪包 (pesudo-package)，是一个可以被 cgo 解析的特殊名字，用来确定代码里 C 的命名空间。

`rand` 包用到 `C` 的地方有 4 个：`C.random`， `C.srandom`， `C.uint(i)` 以及 `import "C"`。

其中，`Random()` 方法调用了 C 语言标准库的 `random()` 方法并返回了其返回值。在 C 语言中， `random()` 方法的返回值是 C 语言的 `long` （cgo 使用 `C.long` 来表示）类型，必须将它转换为 Go 语言的类型才能让包外的 Go 代码使用， 普通的 Go 类型转换即可：

```go
func Random() int {
  return int(C.random())
}
```

一个功能相同但是能更清晰展示类型转换过程的代码如下：

```go
func Random() int {
  var r C.long = C.random()
  return int(r)
}
```

`Seed()` 方法则展示了相反的类型转换过程。它的输入是 Go 的 `int` 类型，需要转换成 C 的`unsigned int` （Cgo 通过 `C.uint` 来表示）类型，作为 C 的 `srandom()` 方法的参数传入。

// TODO complete list of these numeric type names.

```go
func Seed(i int) {
  C.srandom(C.uint(i))
}
```

这段代码里还有一部分代码我们还没解释，那就是 `import` 语句上面的注释。

``` go
/*
#include <stdlib.h>
*/
import "C"
```

Cgo 会读取这段注释：

- 以 `#cgo` + 空格开头的一行注释，Cgo 会删掉 `#cgo` 和空格，剩下的作为 Cgo 的配置保留。
- 剩下的注释行会被当作编译 C 代码时的 header 来使用。

在这个例子中，只有 `#include` 这一行会被识别。`#Cgo` 后面的代码一般用来给 C 代码的编译器和链接器提供 flags。

### Strings

和 Go 不同的是，C 的 String 是通过 `\0` 结尾的 char 数组来构成的。Go 和 C 的 String 类型互相转换是由 `C.CString()`，`C.GoString()` 和 `C.GoStringN()` 这几个方法来实现的，转换过程会拷贝 String 数据。

下面这个例子的 `Print()` 方法调用了 C 的`stdio.h` 库里的 `fputs()` 来向标准输出写一个 String。

```go
package print

// #include <stdio.h>
// #include <stdlib.h>
import "C"
import unsafe

func Print(s string) {
  cs := C.CString(s)
  C.fputs(cs, (*C.FILE)(C.stdout))
  C.free(unsafe.Pointer(cs))
}
```

Go 的内存管理器无法管理 C 分配的内存，因此当你用 `C.CString()` 来创建一个 C 的 String （或任何其他 C 的内存分配）时，你必须手动调用 `C.free()` 来释放这部分的内存。

调用 `C.CString()` 会返回一个指向 char 数组首地址的指针，所以在函数退出之前我们需要将它转换为 `unsafe.Pointer` 并且使用 `C.free()` 释放掉这部分内存。Cgo 的最佳实现中一般会在分配内存的地方立刻使用 `defer()` 来释放内存，如下面更新的代码：

```go
func Print(s string) {
  cs := C.CString(s)
  defer(C.free(unsafe.Pointer(cs)))
  C.fputs(cs, (*C.FILE)(C.stdout))
}
```

### Build Cgo packages

使用 `go build` 或 `go install` 就可以编译 Cgo 代码。当 Go 识别出引用了特殊的 `"C"` 时， 会自动使用 Cgo 来处理这些文件。

### 总结

现在我们已经知道了一个正确的 Cgo 代码应该如何组织，Go 如何表示 C 的各种类型、方法，C 和 Go 的 String 类型如何互换，如何编译 Cgo 代码。

这自然而然的引出了下面的几个问题：

1. C 能调用 GO 的方法吗？
2. C 和 Go 如何传递指针？
3. 我有一个纯 C 的大型项目，可以编译成为静态/动态库，那么我的 Go 如何使用 Cgo 调用这些库？
4. 我没有 C 的项目，但是我有一个 C++ 的项目，那么我的 GO 项目能否/如何使用 Cgo 来调用这个 C++ 的库？ 
5. Cgo 编译和链接的原理是什么？它是实现了一套 c 的编译器链接器还是直接使用的 gcc ？

我在这里挖个坑，请期待接下来的本文的更新吧！

## Cgo Advanced
### Go references to C
### C references to Go
### Passing pointers
### Others

## CPP? Yes!

## Cgo Implementation details

## References

[1] https://blog.golang.org/cgo. *C? Go? Cgo!* Andrew Gerrand. 17 March 2017. 

[2] https://golang.org/cmd/cgo/. Cgo official doc. Go 1.16.
