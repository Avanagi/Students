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
    read -r count
    read -r studentFullName
    read -r dossier
} < <(awk -v search="$studentName" '
    BEGIN { count = 0 }
    /===/ { p=NR+1 }
    (NR==p && tolower($0) ~ tolower(search)) { 
        count++
        last_name=$0
        getline
        last_dossier=$0
    }
    END { 
        print count
        if (count == 1) {
            print last_name
            print last_dossier
        }
    }
' "$filePath")
# проверяем совпадение в имени в файле
if [ $count -eq 0 ]; then
    echo "Не найдено совпадений в документе"
    exit 1
fi

# проверяем, что совпадение только одно
if [ $count -gt 1 ]; then
    echo "Больше одного совпадения, уточните свой запрос"
    exit 1
fi

# вывод досье и имени студента
echo "dossier: $dossier"
echo "studentName: $studentFullName"
