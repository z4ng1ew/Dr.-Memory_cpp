# Dr. Memory Memory Analysis Project

## Project Description

**English:**
C++ memory debugging project using Dr. Memory tool to detect memory leaks, buffer overflows, use-after-free, double-delete, uninitialized reads & other memory errors. Contains test cases demonstrating common memory bugs for educational purposes.

**Russian:**
Проект отладки памяти C++ с использованием инструмента Dr. Memory для обнаружения утечек памяти, переполнения буферов, использования после освобождения, двойного удаления, чтения неинициализированных данных и других ошибок памяти. Содержит тестовые случаи.

## Dr. Memory Analysis Results

### Executive Summary
- **Tool Version:** Dr. Memory 2.6.0
- **Analysis Date:** June 29, 2025
- **Target Application:** ./main
- **Total Errors Found:** 1 memory leak (400 bytes)

### Detected Errors

#### Error #1: Memory Leak (400 bytes)
```
LEAK 400 bytes 
# 0 replace_operator_new_array [alloc_replace.c:2932]
# 1 memoryLeakFunction
# 2 main
```

**Location:** `memoryLeakFunction()` in main.cpp  
**Issue:** Memory allocated with `new int[100]` is never freed  
**Impact:** 400 bytes of memory leaked per function call

### Code Analysis & Issues Found

#### 1. Memory Leak in `memoryLeakFunction()`
**Problem:**
```cpp
void memoryLeakFunction() {
    int* leaked_memory = new int[100];  // 400 bytes allocated
    for(int i = 0; i < 100; i++) {
        leaked_memory[i] = i * 2;
    }
    // Missing: delete[] leaked_memory
}
```

**Fix:**
```cpp
void memoryLeakFunction() {
    int* leaked_memory = new int[100];
    for(int i = 0; i < 100; i++) {
        leaked_memory[i] = i * 2;
    }
    delete[] leaked_memory;  // Add this line
}
```

#### 2. Buffer Overflow in `bufferOverflowFunction()`
**Problem:**
```cpp
void bufferOverflowFunction() {
    char buffer[10];  // Only 10 bytes
    strcpy(buffer, "Это очень длинная строка которая не поместится в буфер");  // 50+ bytes
}
```

**Fix:**
```cpp
void bufferOverflowFunction() {
    char buffer[100];  // Increase buffer size
    strncpy(buffer, "Это очень длинная строка которая не поместится в буфер", sizeof(buffer)-1);
    buffer[sizeof(buffer)-1] = '\0';  // Ensure null termination
}
```

#### 3. Incorrect Array Deletion in `TestClass`
**Problem:**
```cpp
~TestClass() {
    delete data;  // Wrong: should be delete[] for arrays
}
```

**Fix:**
```cpp
~TestClass() {
    delete[] data;  // Correct way to delete arrays
}
```

#### 4. Use-After-Free in `useAfterFreeFunction()`
**Problem:**
```cpp
void useAfterFreeFunction() {
    int* ptr = new int(42);
    delete ptr;
    std::cout << "Value after free: " << *ptr << std::endl;  // Accessing freed memory
}
```

**Fix:**
```cpp
void useAfterFreeFunction() {
    int* ptr = new int(42);
    std::cout << "Value before free: " << *ptr << std::endl;
    delete ptr;
    ptr = nullptr;  // Set to nullptr after deletion
    // Don't access ptr after deletion
}
```

#### 5. Double Delete in `doubleDeleteFunction()`
**Problem:**
```cpp
void doubleDeleteFunction() {
    int* ptr = new int(100);
    delete ptr;
    delete ptr;  // Second deletion causes undefined behavior
}
```

**Fix:**
```cpp
void doubleDeleteFunction() {
    int* ptr = new int(100);
    delete ptr;
    ptr = nullptr;  // Prevent double deletion
    // delete ptr;  // Remove this line
}
```

#### 6. Uninitialized Memory Read
**Problem:**
```cpp
void uninitializedReadFunction() {
    int* uninit_array = new int[5];  // Uninitialized memory
    for(int i = 0; i < 5; i++) {
        std::cout << uninit_array[i] << std::endl;  // Reading uninitialized values
    }
}
```

**Fix:**
```cpp
void uninitializedReadFunction() {
    int* uninit_array = new int[5]();  // Initialize to zero
    // Or manually initialize:
    // for(int i = 0; i < 5; i++) { uninit_array[i] = 0; }
    for(int i = 0; i < 5; i++) {
        std::cout << uninit_array[i] << std::endl;
    }
    delete[] uninit_array;
}
```

### Complete Fixed Code
```cpp
#include <iostream>
#include <cstring>
#include <vector>

class TestClass {
private:
    int* data;
    size_t size;
    
public:
    TestClass(size_t n) : size(n) {
        data = new int[n]();  // Initialize to zero
    }
    
    ~TestClass() {
        delete[] data;  // Correct array deletion
    }
    
    void accessData(size_t index) {
        if (index < size) {  // Bounds checking
            std::cout << "Data[" << index << "] = " << data[index] << std::endl;
        } else {
            std::cout << "Error: Index out of bounds" << std::endl;
        }
    }
    
    void setData(size_t index, int value) {
        if (index < size) {  // Bounds checking
            data[index] = value;
        }
    }
};

void memoryLeakFunction() {
    int* leaked_memory = new int[100];
    for(int i = 0; i < 100; i++) {
        leaked_memory[i] = i * 2;
    }
    delete[] leaked_memory;  // Fix: Free allocated memory
}
```

### Best Practices for Memory Management

1. **Always match new/delete and new[]/delete[]**
2. **Initialize pointers to nullptr after deletion**
3. **Use bounds checking for array access**
4. **Initialize allocated memory before use**
5. **Consider using smart pointers (std::unique_ptr, std::shared_ptr)**
6. **Use RAII (Resource Acquisition Is Initialization) principle**

### Recommendations

1. **Use Static Analysis Tools:** Regularly run Dr. Memory during development
2. **Code Reviews:** Focus on memory management patterns
3. **Unit Testing:** Test memory-intensive functions thoroughly
4. **Modern C++:** Consider using containers (std::vector) instead of raw arrays
5. **Valgrind Alternative:** Dr. Memory provides Windows support unlike Valgrind

### Dr. Memory Command Reference
```bash
# Basic usage
bin64/drmemory -- ./your_program

# Brief output
bin64/drmemory -brief -- ./your_program

# Generate detailed report
bin64/drmemory -results_to_stderr -- ./your_program

# Custom log directory
bin64/drmemory -logdir custom_logs -- ./your_program
```

This analysis demonstrates the importance of proper memory management in C++ and how tools like Dr. Memory can help identify and fix critical memory errors before they cause runtime crashes or security vulnerabilities.
