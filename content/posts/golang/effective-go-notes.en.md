---
title: "Effective Go Notes"
date: 2021-01-25T16:37:14+08:00
draft: true
categories:
  - notes
tags:
  - golang
  - effective-go
--- 

## 1. Formatting

`gofmt` or `go fmt`, operates at package level. For example, given the declaration:

```go
type T struct {
    name string // name of the object
    value int // its value
}
```

`gofmt` will line up the columns:


```go
type T struct {
    name    string // name of the object
    value   int    // its value
}
```

## 2. Commentary

C-style `/* */` block comments and C++-style `//` line comments.

## 3. Names

The visibility of a name outside a package is determined by whether its first character is upper case.

### 3.1 Package names

When a package is imported, the package name becomes an accessor for the contents. After

```go
import "bytes"
```
the importing package can talk about `bytes.Buffer`. So the package name should be good: short, concise,
evocative. By convention, packages are given lower case, single-word names; there should be no need for
underscores or mixedCaps. The package name is only the default name for imports; it need not be unique
across all source code. In any case, confusion is rare because the file name in the import determines just
which package is being used. In the rare case of a collision the importing package can choose a differnt
name to use locally.

Package name is the base name of its source directory, the package in `src/encoding/base64` is imported as
"`encoding/base64`" but has name `base64`, not `encoding_base64` and not `encodingBase64`

The importer of a package will use the name to refer to its contents, so exported names in the package can
use that fact to avoid stutter. For instance, the buffered reader type in the `bufio` package is called `Reader`,
not `BufReader`, because users see it as `bufio.Reader`, which is a clear, concise name. More over, `bufio.Reader`
does not conflict with `io.Reader`. Similarly, the function to make new instances of `ring.Ring` -- which is the
definition of a *constructor* in Go -- would normally be called `NewRing`, but since `Ring` is the only type
exported by the package, and since the package is called `ring`, it's called just `New`, which clients of the
package see as `ring.New`.

Another short example is `once.Do; once.Do(setup)` reads well and would not be improved by writing `once.DoOrWaitUtilDone(setup)`.
Long names don't automatically make things mor readable. **A helpful doc comment can often be more valueable than
extra long name**

### 3.2 Getters name

```go
owner := obj.Owner() // Getter
if owner != user {
    obj.SetOwner(user) // Setter
}
```

### 3.3 Interface names

By convention, one-method interfaces are named by the method name pus an `-er` suffix or similar modification 
to construct an agent noun: `Reader`, `Writer`,`Formatter`, `CloseNotifier` etc. Conversely, if your type
implements a method with the same meaning as a method on a well-known type, give it the same name and signature;
call your string-converter method `String` not `ToString`.

### 3.4 MixedCaps

The convention in Go is to use `MixedCaps` or `mixedCaps` rather than underscores to write multiworld names.

## 4 Semicolons

**Like C, Go's formal grammar uses semicolons to terminate statements**, but unlike in C, those semicolons do not
appear in the source. Instead the lexer uses a simple rule to insert semicolons automatically as it scans,
so the input text is mostly free of them.

The rule is: if the last token before a newline is an identifier(which includes words like `int` and `float64`),
a basic literal such as a number or string constant, or one of the tokens
```go
break continue fallthrough return ++ -- ) }
```
the lexer always inserts a semicolon after the token. This could be summarized as, "if the newline comes after
a token that could end a statement, insert a semicolon"

A semicolon can also be omitted immediately before a closing brace, so a statement such as
```go
go func() {for { dst <- <-src } }()
```
needs noe semicolons.

One consequence of the semicolon insertion rules is that you cannot put the opening brace of a control structure
(`if`,`for`,`switch`, or `select`) on the next line. If you do, a semicolon will be inserted before the brace.
```go
// Write like this
if i < f(){
    g()
}

// Not like this
if i < f() // wrong!
{          // wrong!
    g()
}
```
