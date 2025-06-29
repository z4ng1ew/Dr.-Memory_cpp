#include <iostream>
#include <cstring>
#include <vector>

class TestClass {
private:
    int* data;
    size_t size;
    
public:
    TestClass(size_t n) : size(n) {
        data = new int[n];
        // Ошибка: не инициализируем данные
    }
    
    ~TestClass() {
        delete data; // Ошибка: должно быть delete[] для массива
    }
    
    void accessData(size_t index) {
        // Ошибка: нет проверки границ массива
        std::cout << "Data[" << index << "] = " << data[index] << std::endl;
    }
    
    void setData(size_t index, int value) {
        data[index] = value; // Потенциальная ошибка: нет проверки границ
    }
};

void memoryLeakFunction() {
    // Ошибка: утечка памяти - не освобождаем выделенную память
    int* leaked_memory = new int[100];
    for(int i = 0; i < 100; i++) {
        leaked_memory[i] = i * 2;
    }
    // Не вызываем delete[] leaked_memory
}

void bufferOverflowFunction() {
    char buffer[10];
    // Ошибка: переполнение буфера
    strcpy(buffer, "Это очень длинная строка которая не поместится в буфер");
    std::cout << "Buffer: " << buffer << std::endl;
}

void useAfterFreeFunction() {
    int* ptr = new int(42);
    delete ptr;
    // Ошибка: использование освобожденной памяти
    std::cout << "Value after free: " << *ptr << std::endl;
}

void doubleDeleteFunction() {
    int* ptr = new int(100);
    delete ptr;
    // Ошибка: двойное освобождение памяти
    delete ptr;
}

void uninitializedReadFunction() {
    int* uninit_array = new int[5];
    // Ошибка: чтение неинициализированных данных
    for(int i = 0; i < 5; i++) {
        std::cout << "Uninitialized[" << i << "] = " << uninit_array[i] << std::endl;
    }
    delete[] uninit_array;
}

void invalidReadFunction() {
    std::vector<int> vec = {1, 2, 3, 4, 5};
    // Ошибка: выход за границы вектора
    std::cout << "Invalid access: " << vec[10] << std::endl;
}

int main() {
    std::cout << "=== Тестирование ошибок памяти для Dr. Memory ===" << std::endl;
    
    try {
        std::cout << "\n1. Тест утечки памяти:" << std::endl;
        memoryLeakFunction();
        
        std::cout << "\n2. Тест переполнения буфера:" << std::endl;
        bufferOverflowFunction();
        
        std::cout << "\n3. Тест использования после освобождения:" << std::endl;
        useAfterFreeFunction();
        
        std::cout << "\n4. Тест двойного освобождения:" << std::endl;
        doubleDeleteFunction();
        
        std::cout << "\n5. Тест чтения неинициализированных данных:" << std::endl;
        uninitializedReadFunction();
        
        std::cout << "\n6. Тест неправильного освобождения массива:" << std::endl;
        TestClass* obj = new TestClass(10);
        obj->setData(0, 100);
        obj->accessData(0);
        obj->accessData(15); // Выход за границы
        delete obj;
        
        std::cout << "\n7. Тест невалидного чтения:" << std::endl;
        invalidReadFunction();
        
    } catch(const std::exception& e) {
        std::cout << "Исключение: " << e.what() << std::endl;
    }
    
    std::cout << "\nТестирование завершено." << std::endl;
    return 0;
}
