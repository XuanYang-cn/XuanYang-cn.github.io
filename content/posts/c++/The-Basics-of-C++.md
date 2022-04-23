---
title: "The Basics of C++"
date: 2022-04-23T11:19:04+08:00
draft: false
categories:
  - c++
tags:
  - c++
---

## The Basics of C++

**C-Style Arrays**

> In c++, it's best to avoid C-style arrays and use Standard Library functionality, such as `std::array` and `std::vector`

```c++
int myArray[3];
int myArray[3] = {0}; // 0 can be dropped as {}
int myArrya[] = {1, 2, 3, 4}; // The compiler creates an array of 4 elements

// c++17 can use `std::size()` to calculate C-style array
// #include <array>
unsigned int arraySize = std::size(myArray);

// before c++17
unsigned int arraySize = sizeof(myArray) / sizeof(myArray[0]);
```

**`std::array`**

A special type of fixed-size container, defined in the `<array>` header file.

```c++
#include <array>
// fixed-size
std::array<int, 3> arr = {9, 8, 7};
std::cout << "Array size = " << arr.size() << std::endl;
std::cout << "2nd element = " << arr[1] << std::endl;
```

**`std::vector`**

Non-fixed-size containers, declared in `<vector>` header file.

```c++
#include <vector>

std::vector<int> myVector = {11, 12};
myVector.push_back(33);
myVector.push_back(44);
std::cout << "1st element: " << myVecotor[0] << std::endl;
```

**Structured Bindings -- C++17**

```c++
std::array<int ,3> values = {11, 22, 33};
auto [x, y, z] = values;

// also work with structures
struct Point {double mX, mY, mZ;};
Point point;
point.mX = 1.0; point.mY = 2.0; point.mZ = 3.0;
auto [x, y, z] = point;
```

**The Range-Based for Loop**
```c++
std::array<int, 4> arr = {1, 2, 3, 4};
for (int i : arr) {
    std::cout << i << std::endl;
}
```

**Initializer Lists**
Defined in `<initializer_list>` header file and make it easy to write functions that can accept a variable number fo arguments.

```c++
#include <initializer_list>

int makeSum(initializer_list<int> lst){
    int total = 0;
    for (int v : lst) {
        total += v;
    }
    return total;
}

int a = makeSum({1,2,3});
int b = makeSum({10, 20, 30, 40, 60});
```

## Diving Deeper Into C++

**Strings in C++**

```c++
#include <string>

std::string myString = "Hello World"

std::cout << "The value of myString is " << myString << std::endl;
std::cout << "The second letter is " << myString[1] << std::endl;
```

**Pointers and Dynamic memory**

Memory in your C++ application is divided into two parts—the *stack* and the *heap*. 

You can put anything on the heap by explicitly allocating memory for it. But first, you need to declare a pointer.

**Always avoiding using uninitialized pointer, you should always declare and initialize the pointer at the same time**. You can initialize the pointer as nullptr.

```c++
int* myIntegerPointer = nullptr;
```

```c++
myIntegerPointer = new int; // use new to allocate memory.
*myIntegerPointer = 8;      // change the int in heap to 8, not the ponter

delete myIntegerPointer;  	// deallocate the memory at which the pointer pointed.
myIntegerPointer = nullptr; // set the pointer to nullptr to prevent the pointer from 
														//  being used after having deallocated the memory it points to.
```

Pointers can point to stack memory

```c++
int a = 8;
int* aptr = &a;
```

> Note: Make sure the pointer is valid (not uninitialized or nullptr) before its dereferenced.

If you have a pointer to a structure, you can get its fields by dereferencing it by `*` and use the normal `.`

```c++
Employee* anEmployee = getEmployee();
std::cout << (*anEmployee).salary << std::endl;
```

Or use `->` to do both dereference and field access

```c++
std::cout << anEmployee->salary << std::endl;

bool isValidEmployee = (anEmployee && anEmployee->salary > 0);
// or verbosely
bool isValidEmployee = (anEmployee != nullptr && anEmployee->salary > 0);
```

**Dynamic Allocated Arrays**

```c++
int arraySize = 8;
int* myArray = new int[arraySize];

delete[] myArray;
myArray = nullptr;
```

> Note: Avoid using `malloc()` and `free()` in C, instead, using `new`,`new[]`,`delete`, and `delete[]`.

**Null Pointer Constant**

Constant `NULL` problem: it's 0. The following will call the integer version, even if we're passing a NULL char*

```c++
void func(char* str) {std::cout << "char* version" << std::endl;}
void func(int i) {std::cout << "integer version"}

int main(){
	func(NULL);
	return 0;
}
```

 But `nullptr` solves the problem.

```c++
func(nullptr);  // calls the char* version
```

**Smart Pointers**

To avoid common memory problems, you should use `smart pointers` instead of raw C-style pointers.

Defined in `<memory>` and inside `std` namespace.

- `std::unique_ptr`: analogous to ordinary pointer, except that it automatically frees the memory or resources when it goes out of scope or is deleted. An `unique_ptr` has sole ownership of the object pointed to.

```c++
auto anEmployee = std::make_unique<Employee>(); // since c++14
unique_ptr<Employee> anEmployee(new Employee); // before c++14

if (anEmployee) {
  	std::cout << "Salary: " << anEmployee->salary << std::cout; 
}

auto employees = std::make_unique<Employee[]>(10); // C style Array
std::cout << employees[0].salary << std::endl;
```

- `std::shared_ptr`: allows a distributed ownership of the data. Each time the `shard_ptr` is assigned, a reference count is incremented indicating there's one more owner of the data.

```c++
auto anEmployee = std::make_shared<Employee>();

std::shared_ptr<Employee[]> employees(new Employee[10]); // C style Array since C++17
std::cout << "Salary: " << employees[0].salary << std::endl;
```

**The many uses of const**

1. `const` constants
2. `const` to protect parameters

Cast a non-const variables to a `const` variables to avoid accident changes

```c++
void mysteryFunction(const std::string* someString){
    *someString = "Test";  // Will not compile.
}

int main(){
    std::string myString = "The string";
    mysteryFunction(&myString);
    return 0;
}
```

**References**

```c++
int x = 42;
int& myRef = x;  // actually a pointer to x
```

**Pass by reference**

Usually when you pass a variable to a functions, you're passing by **value**,  you could choose to *pass by reference* to enable to change the variable.

```c++
void addOne(int i) { // pass by value
   i++;
}

void addOne(int &i){ // pass by reference actually can change the variable i
  	i++;
}
```

**Pass by const reference**

No copy and not allowed to change.

```c++
void printString(const std::string& myString){
  	std::cout << myString << std::endl;
}

int main(){
  	std::string myString = "Hello World";
  	printString(myString);
  	printString("Hello World");
  	return 0;
}
```

**Type Inference**

Type inference allows the compilers to automatically deduce the type of an expression

- The `auto` keyword

```c++
auto x = 123;
auto result = getFoo();
```

Using `auto` to deduce the type of an expression **strips away reference and `const` qualifiers**

```c++
#include <string>

const std::string message = "Test";
const std::string& 
foo(){
  	return message;
}

auto f1 = foo(); // Because auto strips away reference and `const` qualifiers, f1 is of type `string`
const auto& f2 = foo();  // f2 is of type const reference of string
```

- The `decltype` keyword

`decltype` takes an expression as argument, and computes the type of that argument.

`decltype` doesn't strip `const` and reference qualifiers.

```c++
int x = 123;

decltype(x) y = 456;
```



## UNIFORM INITIALIZATION

```c++
struct CircleStruct{
    int x, y;
    double radius;
};

class CircleClass{
public:
    CircleClass(int x, int y, double radius)
        : mX(x), mY(y), mRadius(radius) {}
private:
    int mX, mY;
    double mRadius;
};
```

```c++
// Not uniform
CircleStruct c1 = {1, 1, 2.5};
CircleClass c2(2, 2, 2.5); 

// Uniform
CircleStruct c3 = {1, 1, 2.5};
CircleClass c4 = {2, 2, 2.5};

// the use of euqal sign is optional
CircleStruct c5{1, 1, 2.5};
CircleClass c6{2, 2, 2.5};

// Uniform initialization to perform zero initialization
int a{}; // a == 0

// Uniform initialization prevents narrowing
void func(int i);

int x={3.14}; // Error because of narrowing
func({3.14}); // Error because of narrowing
  
int* myArray = new int[4]{0, 1, 2, 3};
```
