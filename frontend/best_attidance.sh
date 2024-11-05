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

attidancePath="$filePath"'/'"$subject"
groupsFiles=($(find "$attidancePath" -maxdepth 1 -type f -not -path "$attidancePath" -not -name "tests" -exec basename {} \; | sort | sed -E "s/(.*)-attendance/\1/"))
groupOptions=()
for i in "${!groupsFiles[@]}"; do
    groupOptions+=($(($i + 1)) "${groupsFiles[$i]}")
done

selectedGroup=$(dialog --title "Выберите группу" --menu "Выберите группу:" $HEIGHT $WIDTH 0 "${groupOptions[@]}" 2>&1 >/dev/tty)
check_cancel
group="${groupsFiles[$selectedGroup - 1]}"
    
echo "$group" "$subject" > test.log

result=$("$appPath"/backend/show_best_attendance.sh "$group" "$subject" "$filePath")

dialog --title "Результат" \
    --msgbox "$result" $HEIGHT $WIDTH
