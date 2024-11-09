#!/bin/bash

# вывод по фамилии студента его досье;
# возможность добавления новых фраз в досье;

# фио студента(возможен поиск по частичной фамилии)
studentName=$1
# директория до файловой системы
dir=$2

# формирование пути

fistLatter=$(echo "${studentName:0:1}" | tr '[:lower:]' '[:upper:]')
filePath="$dir"/"students"/"general"/"notes"/"${fistLatter}Names.log"

# проверка существования файла
if [ ! -f "$filePath" ]; then
    echo "Неверно указаны параметры, не удается найти файл с досье"
    exit 1
fi

# подсчет количества совпадений в файле
countNames=$(grep -i -c "$studentName" "$filePath")

# проверяем совпадение в имени в файле
if [ "$countNames" = 0 ]; then
    echo "Не найдено совпадений в документе"
    exit 1
fi

# проверяем, что совпадение только одно
if [ ! "$countNames" = 1 ]; then
    echo "Найдено больше одного совпадения, учтоните свой запрос"
    exit 1
fi

# поиск строки над совпадением
strBeforeName=$(grep -i -i -B 1 "$studentName" "$filePath" | head -n 1)
studentFullName=$(grep -i -i "$studentName" "$filePath")
# проверка того, что совпадение нашлось в имени, а не в досье
if [[ "$strBeforeName" != *"==="* ]]; then
    echo "Совпадение найдено не в имени, уточните свой запрос"
    exit 1
fi

# поиск строки с досье
dossier=$(grep -i -i -A 1 "$studentName" "$filePath" | tail -n 1)

# вывод досье и имени студента
echo "dossier: $dossier"
echo "studentName: $studentFullName"
