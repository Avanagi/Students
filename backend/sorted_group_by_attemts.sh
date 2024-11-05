#!/bin/bash

# вывод списка группы, упорядоченного по количеству попыток сдачи теста

#группа должна быть указана в формате A-06-21
group=$1
#просто номер теста от 1 до 4
test=$2
# имя предмета
subjectName=$3
# директория в которой хранятся данные по предметам
folderDir=$4

#путь до файла с тестом
testFile="$folderDir"/"$subjectName"/tests/"$test"
# проверяю наличие файла теста
if [ ! -e "$testFile" ]; then
    echo "Can't find test file"
    exit 1
fi

count=$(grep -c "$group" "$testFile")
if [[ $count -eq 0 ]]; then
    echo "Ошибка: Ученики указанной группы не сдавали тест."
    exit 1
fi

# список людей данной группы
filtered=$(grep "$group" "$testFile" | sed -E 's/^[^,]{4},([^,]*),[^,]*,([0-9]{1,2}),[2-5]$/\1/')

#отсортированный по убыванию список учеников с их количеством сдачи тестов
uniqList=$(echo "$filtered" | uniq -c | sort -r -n)

# пронумировал строки и поставил количество попыток сдачи теста в конец
final=$(echo "$uniqList" | sed -E 's/^.*([0-9]{1,2}) (.*)$/\2 \1/' | nl)

echo "$final"
