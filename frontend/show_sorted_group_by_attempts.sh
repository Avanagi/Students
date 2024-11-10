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

#выбрать тест для которого надо сдать

testFolderPath="$filePath"'/'"$subject"'/'"tests"
testFolders=($(find "$testFolderPath" -maxdepth 1 -type f -not -path "$testFolderPath" -exec basename {} \; | sort))
testsOptions=()
for i in "${!testFolders[@]}"; do
    testsOptions+=($(($i + 1)) "${testFolders[$i]}")
done

selectedTest=$(dialog --title "Выберите тест" --menu "Выберите тест:" "$HEIGHT" "$WIDTH" 0 "${testsOptions[@]}" 2>&1 >/dev/tty)

check_cancel

test="${testFolders[$selectedTest - 1]}"

# указать группу
testPath="$testFolderPath"'/'"$test"

testGroups=($(awk -F',' '{print $3}' "$testPath" | sort -u))

menuTestGroups=()
for i in "${!testGroups[@]}"; do
    menuTestGroups+=($(($i + 1)) "${testGroups[$i]}")
done

# Открываем диалоговое окно для выбора группы
selectedGroup=$(dialog --title "Выберите группу" --menu "Выберете группу для которой надо  :" "$HEIGHT" "$WIDTH" 10 "${menuTestGroups[@]}" 3>&1 1>&2 2>&3)
check_cancel

group="${testGroups[$selectedGroup - 1]}"

result=$("$appPath"/backend/sorted_group_by_attempts.sh "$group" "$test" "$subject" "$filePath")

dialog --title "Результат" \
    --msgbox "$result" "$HEIGHT" "$WIDTH"
