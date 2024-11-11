#!/bin/bash

# вывод имени студента с наилучшей посещаемостью и количество посещенных им занятий;
# + По заданной группе. По всем занятиям. Нужно вывести всех студентов с одинаковой максимальной посещаемостью.

# имя группы в полном формате A-06-21
group=$1
# имя предмета
subjectName=$2
# директория до файловой системы 3 лабы
directory=$3

# имя файла с посещаемостью
filePath="$directory"/"$subjectName"/"$group"-attendance

# проверка праильности введенных данных
if [ ! -e "$filePath" ]; then
    echo "Can't find test file"
    exit 1
fi

# студент и количество посещенных им занятий
source=$(cat "$filePath")
# список студентов
listStudents=""
maxCount=-1
while IFS= read -r line; do
    # поиск количества посещенных занятий
    count=$(echo "$line" | grep -o + | wc -l)
    # удаляем из строки подстроку с посещаемостью
    name=$(echo "$line" | sed -E 's/^(.*) [_+]*$/\1 /')
    # создаем новую строку с именем и количеством посещений
    listStudents+="$name"
    listStudents+="$count"
    listStudents+=$'\n'
    # провеяем, является ли количество посещений максимальным
    if ((count > maxCount)); then
        maxCount=$count
    fi
done <<<"$source"

# оставляем строки в которых содержится максимальное количество посещений
result=$(echo "$listStudents" | grep "$maxCount")
# выводим результат

if [[ $count -eq -0 ]]; then
    result="Студенты отсутствуют"
fi

echo "$result"
