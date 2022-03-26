---
title: "Clean Code 1: Names"
date: 2022-03-26T12:35:00+08:00
draft: false
categories:
  - clean code
tags:
  - clean code
---

>
> If we all checked-in our code a little cleaner than when we checked it out, the code simply could not rot.

# Clean Code 1: Names

## 1. Choose your name thoughtfully.
## 2. Communicate your intent.

```
Intervals!
(a, b) open
[a, b] closed
(a, b] open left
[a, b) open right
```

## 3. Avoid Disinformation.
## 4. Pronounceable Names.

- Methods: verb
- Classes: noun
- Boolean: *isEnough*
- Enum: adjective

## 5. Avoid Encodings.

```c++
// Avoid psz
int *pszBasket
```

## 6. Choose Parts of Speech Well

> Clean code always reads like well-written prose. —— Grady Booch

## 7. The Scope Rule.

- Variable names: the shorter scope, the shorter name; the longer scope, the longer meaningful names.
- Method/Class names: the longer scope, the shorter name, like `Open`.