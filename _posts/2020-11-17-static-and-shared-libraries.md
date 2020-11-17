---
layout: single
title:  "Static and Shared Libraries"
categories: "compilation"
author: "Yang Xuan"
excerpt: "The difference between static libraries and shared libraries."
---

# 静态库和动态库

## `gcc hello.c` 隐藏的过程

helloworld 程序 -> gcc -> 可执行的 a.out

【图片：编译的两步】

这个过程粗略来讲分为两步：编译（Compilation）和链接（Linking）。首先编译器将 hello.c 编译成目标文件 hello.o， 然后链接器将 hello.o 与其他目标文件和库链接形成可执行文件 a.out

## 静态链接和动态链接

链接过程

静态链接文件可以是**目标文件** （Object File, 一般扩展名为 .o 或 .obj）或者静态**库**（Library）。

静态链接的缺点：空间浪费和更新困难

Linux 系统中， 动态链接文件被称为**动态共享对象（DSO, Dynamic Shared Objects）**, 一般是以 .so 为扩展名的文件。在 Windows 系统中，动态链接文件被称为 **动态链接库（Dynamic Linking Library）**, 一般是以 .dll 为扩展名的文件

动态链接的优点也就是静态链接的缺点。

将程序的模块相互分割开来，形成独立的文件，而不对这些目标文件进行链接， 等到程序要运行时才进行链接，这就是动态链接的基本思想。

动态链接的缺点：DLL Hell，当程序依赖的某个模块更新之后，由于新的模块与旧的模块之间接口不兼容，导致原有程序无法运行，

