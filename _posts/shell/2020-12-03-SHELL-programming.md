---
layout: single
title:  "Shell programming"
categories: "shell"
author: "Yang Xuan"
excerpt: "Basic shell programming"
---
```shell
#!/bin/bash
echo "Hello Shell!"
a=`pwd`
echo $a

```

**特殊变量**
[example code](hello.sh)
- `$0` - `$n` 参数列表 
- `$#` 当前脚本的参数个数
- `$*` 当前shell的所有参数，将所有命令行参数视为单个字符串，相当于"$1$2$3"
- `$@` 获得这个程序所有参数并保留参数的空白, 相当于"$1", "$2" "$3"。
- `$?` 上一条命令的返回结果。

**输入输出**
- `read`
- `echo`
- `printf`

```shell
function __func1__() {
    echo "$1"
    return
}

__func1__ "Hellofunction"

a=11
if [[ $a -gt 10 ]];then
    echo "${a} > 10"
elif [[ $a -eq 10 ]];then
    echo "${a} = 10"
else
    echo "${a} < 10"
fi

```
