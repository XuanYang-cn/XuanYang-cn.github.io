---
layout: single
title:  "Static and Shared Libraries"
categories: "compilation"
author: "Yang Xuan"
excerpt: "The difference between static libraries and shared libraries."
---

# 静态库和动态库

静态库和动态库的区别，本质上是静态链接和动态链接的区别。那么什么是链接？什么又是静态链接和动态链接呢？本文将由浅入深，逐步解析静态库和动态库的区别。

## `gcc hello.c` 隐藏的过程

```c
// hello.c
#include <stdio.h>

int main() {
  printf("Hello World!\n");
  return 0;
}
```

相信大家对上面的 C 语言程序 `hello.c` 都非常熟悉了，想要在命令行获得可执行文件我们还需要对这个文件进行编译。在 Linux 中，使用 GCC 来编译 `hello.c` 非常简单：

```shell
$ gcc hello.c
$ ./a.out
Hello World!
```

`gcc` 可以将 C 语言源文件编译成可执行文件，这个看上去很简单的过程其实隐藏了很多步骤。事实上，上述过程可以分解成 4 个步骤， 分别是**预处理（Prepressing）**、**编译（Compilation）**、 **汇编（Assembly）**、 和**链接（Linking）**。 

本文着重点在链接，所以链接之前的三个步骤在本文里被统称为编译。于是上述过程可以粗略分为两步：编译和链接。

<img src="/assets/images/compile.png" style="zoom:75%;" />{: .align-center}

这个过程粗略来讲分为两步：编译（Compilation）和链接（Linking）。首先编译器将 hello.c 编译成目标文件 hello.o， 然后链接器将 hello.o 与其他目标文件和库链接形成可执行文件 a.out

## 静态链接和动态链接

链接过程

静态链接文件可以是**目标文件** （Object File, 一般扩展名为 .o 或 .obj）或者静态**库**（Library）。

静态链接的缺点：空间浪费和更新困难

Linux 系统中， 动态链接文件被称为**动态共享对象（DSO, Dynamic Shared Objects）**, 一般是以 .so 为扩展名的文件。在 Windows 系统中，动态链接文件被称为 **动态链接库（Dynamic Linking Library）**, 一般是以 .dll 为扩展名的文件

动态链接的优点也就是静态链接的缺点。

将程序的模块相互分割开来，形成独立的文件，而不对这些目标文件进行链接， 等到程序要运行时才进行链接，这就是动态链接的基本思想。

动态链接的缺点：DLL Hell，当程序依赖的某个模块更新之后，由于新的模块与旧的模块之间接口不兼容，导致原有程序无法运行，

