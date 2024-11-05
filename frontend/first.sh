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

selectedSubjectFolder=$(dialog --title "Выберите предмет" --menu "Выберите предмет:" $HEIGHT $WIDTH 0 "${subjectOptions[@]}" 2>&1 >/dev/tty)
check_cancel
subject="${foldersSubject[$selectedSubjectFolder - 1]}"

#выбрать тест для которого надо сдать

testPath="$filePath"'/'"$subject"'/'"tests"
testFolders=($(find "$testPath" -maxdepth 1 -type f -not -path "$testPath" -exec basename {} \; | sort))
testsOptions=()
for i in "${!testFolders[@]}"; do
    testsOptions+=($(($i + 1)) "${testFolders[$i]}")
done

selectedTest=$(dialog --title "Выберите тест" --menu "Выберите тест:" $HEIGHT $WIDTH 0 "${testsOptions[@]}" 2>&1 >/dev/tty)

check_cancel

test="${testFolders[$selectedTest - 1]}"
echo $testNumber >test.log

# указать группу

while true; do

    group=$(dialog --title "Ввод группы" \
        --inputbox "Введите номер группы (Формата: A-06-21):" \
        $HEIGHT $WIDTH \
        3>&1 1>&2 2>&3)

    check_cancel

    # Проверка на пустое поле
    if [ -z "$group" ]; then
        dialog --title "Ошибка" \
            --msgbox "Поле не может быть пустым!" \
            $HEIGHT $WIDTH
        continue
    fi

    # Проверка на пробелы
    if [ "$group" = "$(echo -e "$group" | tr -d '[:space:]')" ]; then
        break
    else
        dialog --title "Ошибка" \
            --msgbox "Введите название группы без пробелов!" \
            $HEIGHT $WIDTH
    fi

done

result=$("$appPath"/backend/sorted_group_by_attemts.sh "$group" "$test" "$subject" "$filePath")

dialog --title "Результат" \
    --msgbox "$result" $HEIGHT $WIDTH
