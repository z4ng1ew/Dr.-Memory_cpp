#!/bin/bash

# Переход в директорию Dr. Memory
cd ~/DrMemory-Linux-2.6.0

echo "=== Запуск анализа памяти с Dr. Memory ==="

# Запуск Dr. Memory с подробным выводом
bin64/drmemory -brief -- ./main

echo -e "\n=== Поиск и копирование результатов ==="

# Находим последний созданный лог-файл
LATEST_LOG=$(ls -t drmemory/logs/DrMemory-main.*/results.txt 2>/dev/null | head -1)

if [ -n "$LATEST_LOG" ]; then
    echo "Найден файл результатов: $LATEST_LOG"
    
    # Копируем результаты
    cp "$LATEST_LOG" report.txt
    
    # Создаем Markdown отчет
    {
        echo "# Отчет Dr. Memory"
        echo ""
        echo "## Результаты анализа памяти"
        echo ""
        echo '```'
        cat report.txt
        echo '```'
        echo ""
        echo "## Краткая сводка"
        echo ""
        echo "- **Дата анализа:** $(date)"
        echo "- **Анализируемый файл:** ./main"
        echo "- **Версия Dr. Memory:** 2.6.0"
    } > report.md
    
    echo "Отчеты созданы:"
    echo "- report.txt (текстовый файл)"
    echo "- report.md (Markdown файл)"
    
    echo -e "\n=== Содержимое текстового отчета ==="
    cat report.txt
    
    echo -e "\n=== Размеры файлов ==="
    ls -lh report.txt report.md
else
    echo "ОШИБКА: Файл результатов не найден!"
    echo "Проверьте наличие файлов в drmemory/logs/"
    ls -la drmemory/logs/DrMemory-main.*/
fi
