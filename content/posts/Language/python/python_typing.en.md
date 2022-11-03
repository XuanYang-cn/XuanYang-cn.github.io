---
title: "Python Type Hints"
date: 2022-11-03T13:30:01+08:00
draft: false
toc: false
images:
categories:
  - language
  - python
tags:
  - python
---

> Note The Python runtime does not enforce function and variable type annotations.
 They can be used by third party tools such as type checkers, IDEs, linters, etc.

1. Type hints help document the code
2. Type hints improve IDEs and linters
3. Type hints help you build and maintain a cleaner architecture.

## Generics
denote expected types for container elements.
```python
from collections.abc import Sequence
from typing import TypeVar

T = TypeVar('T')      # Declare type variable

def first(l: Sequence[T]) -> T:   # Generic function
    return l[0]
```
## Useful types in `typing` module

**typing.Any**

A static type checker will treat every type as being compatible with Any and Any as being compatible with every type.

**typing.NoReturn**

**typing.TypeAlias (3.10)**

**typing.Tuple**

```python
from typing imporg Tuple

Tuple[int, str, float]
# A type of tuple with three items with
# the first item type int
# the second item type str
# the third item type float

Tuple[int, ...]
Tuple[()] # empty tuple
```
**typing.Union**

`Union[X, Y]` is equivalent to `X | Y` and means either X or Y

**typing.Optional**
`Optional[X]` is equal to `X | None` or `Union[X, None]`

**typing.Callable**
Callable type; `Callable[[int], str]` is a function of `(int) -> str`.

## Some examples to use type hints
```python
name: str = "Guido"
pi: float = 3.142
centered: bool = False

names: list = ["Guido", "Jukka", "Ivan"]
version: tuple = (3, 7, 1)
options: dict = {"centered": False, "capitalize": True}

from typing import Dict, List, Tuple
names: List[str] = ["Guido", "Jukka", "Ivan"]
version: Tuple[int, int, int] = (3, 7, 1)
options: Dict[str, bool] = {"centered": False, "capitalize": True}
```

```python
def create_deck(shuffle: bool = False) -> List[Tuple[str, str]]:
    """Create a new deck of 52 cards"""
    deck = [(s, r) for r in RANKS for s in SUITS]
    if shuffle:
        random.shuffle(deck)
    return deck
```

**References:**

[1] [typing documentation](https://docs.python.org/3/library/typing.html)
[2] [typing instruction](https://realpython.com/python-type-checking/#pros-and-cons)
[3] [PEP 483 The Theory of Type Hints](https://www.python.org/dev/peps/pep-0483/)
[4] [PEP 484 Type Hints](https://www.python.org/dev/peps/pep-0484/)
[5] [PEP 526 Syntax for Variable Annotations](https://www.python.org/dev/peps/pep-0526/)
