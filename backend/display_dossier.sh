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
{
    read -r line1
    read -r studentFullName
    read -r dossier
} < <(awk -v search="$studentName" '
    /===/ { p=NR+1 }
    (NR==p && tolower($0) ~ tolower(search)) { 
        print prev    # строка с ===
        print         # строка с именем
        getline
        print         # следующая строка
    }
    { prev=$0 }
' "$filePath")


echo $studentFullName > test.log    
# проверяем совпадение в имени в файле
if [ -z "$studentFullName" ]; then
    echo "Не найдено совпадений в документе"
    exit 1
fi

# проверяем, что совпадение только одно
if [ "$(echo "$studentFullName" | wc -l)" -gt 1 ]; then
    echo "Не найдено совпадений в документе"
    exit 1
fi

# вывод досье и имени студента
echo "dossier: $dossier"
echo "studentName: $studentName"
