#!/bin/bash

appPath=$1
HEIGHT=$2
WIDTH=$3
filePath=$4

check_cancel() {
    local exit_status=$?
    if [ $exit_status -eq 1 ]; then
        exit 0
    fi
}

# создаем массив из папок(предметов)
foldersSubject=($(find "$filePath" -maxdepth 1 -type d -not -path "$filePath" -not -name "students" -exec basename {} \;))

subjectOptions=()
for i in "${!foldersSubject[@]}"; do
    subjectOptions+=($(($i + 1)) "${foldersSubject[$i]}")
done

selectedSubjectFolder=$(dialog --title "Выберите предмет" --menu "Выберите предмет:" "$HEIGHT" "$WIDTH" 0 "${subjectOptions[@]}" 2>&1 >/dev/tty)
check_cancel
subject="${foldersSubject[$selectedSubjectFolder - 1]}"

testPath="$filePath"'/'"$subject"'/'"tests"
yearsInTest=($(awk -F',' '{print $1}' "$testPath"/* | sort -u))
yearsOptions=()
for i in "${!yearsInTest[@]}"; do
    yearsOptions+=($(($i + 1)) "${yearsInTest[$i]}")
done

selectedYear=$(dialog --title "Выберите год" --menu "Выберите год сдачи теста" "$HEIGHT" "$WIDTH" 0 "${yearsOptions[@]}" 2>&1 >/dev/tty)
check_cancel
year="${yearsInTest[$selectedYear - 1]}"

result=$("$appPath"/backend/display_students_with_max_tries.sh "$subject" "$year" "$filePath")

case $? in
1)
    dialog --title "Ошибка" \
        --msgbox "$result" \
        "$HEIGHT" "$WIDTH"

    ;;
0)
    resultStringCount=$(echo "$result" | wc -l)
    if [[ $resultStringCount -eq 1 ]]; then
        dialog --title "Студент давший наибольшее общее количество правильных ответов" \
            --msgbox "\n$result" "$HEIGHT" "$WIDTH"
    else
        dialog --title "Студенты давшие наибольшее общее количество правильных ответов" \
            --msgbox "\n$result" "$HEIGHT" "$WIDTH"
    fi
    ;;
esac
