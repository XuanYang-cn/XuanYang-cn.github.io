# GO Module

## Creating a new module

```go
// hello.go
package hello

func Hello() string {
    return "Hello, world."
}
```



```go
// hello_test.go
package hello

import "testing"

func TestHello(t *testing.T){
    want := "Hello, world."
    if got := Hello(); got != want {
        t.Errorf("Hello() = %q, want %q, got, want")
    }
}
```

```shell
$ go test
```



```shell
$ go mod init example.com/hello
```

`go mod init` write a `go.mod` file. 

## Adding a dependence

```go
package hello

import "rsc.io/quote"

func Hello() string {
    return quote.Hello()
}
```

```shell
$ go test
```

`go list -m` lists the current module and all its dependencies

## Upgrading dependencies



