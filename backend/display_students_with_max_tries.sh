#!/bin/bash

# вывод студентов, давших наибольшее общее количество правильных ответов
# По заданному году сдачи теста. Нужно вывести студента, его группу и количество правильных ответов.
#  По всем тестам заданного предмета, суммарное количество правильных
# ответов из предпоследней колонки файла с тестом, только для положительных оценок.

# Получаем аргументы: название предмета и директорию
subject=$1
year=$2
dir=$3

# Формируем путь к файлам тестов
testPath="$dir/$subject/tests"

declare -A scores # Ассоциативный массив для хранения суммарных баллов для каждого студента

# Обрабатываем все файлы в папке testPath
for file in "$testPath"/*; do
    # Проверяем, что файл существует и не является пустым
    if [[ -f "$file" && -s "$file" ]]; then
        # Используем awk для фильтрации по году и суммирования баллов
        awk -F',' -v year="$year" '
            $1 == year && $5 > 2 {scores[$2] += $4}  # Суммируем баллы для студентов заданного года, если оценка больше 3
            END {
                for (student in scores) {
                    print student, scores[student]  # Выводим результаты для каждого студента
                }
            }
        ' "$file" >>temp_scores.txt
    fi
done

# Заполняем массив scores из временного файла temp_scores.txt
while read student score; do
    ((scores[$student] += score))
done <temp_scores.txt

# Удаляем временный файл
rm temp_scores.txt

# Находим студента с максимальным суммарным баллом
max_score=0
top_student=""

for student in "${!scores[@]}"; do
    if ((scores[$student] > max_score)); then
        max_score=${scores[$student]}
        top_student=$student
    fi
done

# Выводим результат
echo "$top_student" "$max_score"
