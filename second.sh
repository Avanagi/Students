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
students=$(cat "$filePath")

for student in $students; do
    echo "$student"
done
