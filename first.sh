#!/bin/bash

# вывод списка группы, упорядоченного по количеству попыток сдачи теста

#группа должна быть указана в формате A-06-21
group=$1
#просто номер теста от 1 до 4
testNum=$2
# имя предмета
subjectName=$3
# директория в которой хранятся данные по предметам
folderDir=$4

#путь до файла с тестом
testFile="$folderDir"/"$subjectName"/tests/TEST-"$testNum"
# проверяю наличие файла теста
if [ -f "$testFile" ]; then
    echo "File exists" >>log.txt

else
    echo "Can't find test file"
    exit
fi

# список людей данной группы
filtered=$(grep "$group" "$testFile" | sed -E 's/^[^,]{4},([^,]*),[^,]*,([0-9]{1,2}),[2-5]$/\1/')

#отсортированный по убыванию список учеников с их количеством сдачи тестов
uniqList=$(echo "$filtered" | uniq -c | sort -r -n)

# пронумировал строки и поставил количество попыток сдачи теста в конец
final=$(echo "$uniqList" | sed -E 's/^.*([0-9]{1,2}) (.*)$/\2 \1/' | nl)
echo "$final"
