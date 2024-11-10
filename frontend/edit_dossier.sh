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

while true; do

    studentName=$(dialog --title "Фамилия студента" \
        --inputbox "Введите фамилию студента на английском языке:" \
        "$HEIGHT" "$WIDTH" \
        3>&1 1>&2 2>&3)

    check_cancel

    # Проверка на пустое поле
    if [ -z "$studentName" ]; then
        dialog --title "Ошибка" \
            --msgbox "Поле не может быть пустым!" \
            "$HEIGHT" "$WIDTH"
        continue
    fi

    # Проверка на пробелы
    if [ ! "$studentName" = "$(echo -e "$studentName" | tr -d '[:space:]')" ]; then
        dialog --title "Ошибка" \
            --msgbox "Введите фамилию без пробелов" \
            "$HEIGHT" "$WIDTH"
        continue
    fi

    result=$("$appPath"/backend/find_dossier.sh "$studentName" "$filePath")
    

    case $? in
    1)
        dialog --title "Ошибка" \
            --msgbox "$result" \
            "$HEIGHT" "$WIDTH"
        ;;
    0)
        studentFullName=$(echo "$result" | grep "^studentName:" | sed -E 's/^studentName: (.*)$/\1/')
        oldDossier=$(echo "$result" | grep "^dossier:" | sed -E 's/^dossier: (.*)$/\1/')

        dialog --title "Досье студента $studentFullName" \
            --ok-label "Далее" \
            --msgbox "$oldDossier" \
            "$HEIGHT" "$WIDTH"

        newDossier=$(dialog --title "Дополните досье" \
            --inputbox "Введите текст, который хотите добавить:" \
            "$HEIGHT" "$WIDTH" \
            3>&1 1>&2 2>&3)
        check_cancel

        # удаление специальных симоволов
        cleanedNewDossier=$(echo "$newDossier" | sed -E 's/[^[:alnum:][:space:].,:;!?[]()-//g')   

        "$appPath"/backend/edit_dossier.sh "$studentName" "$cleanedNewDossier" "$filePath" "$appPath"

        # вывод обновленного досье
        result=$("$appPath"/backend/find_dossier.sh "$studentName" "$filePath")
        updatedDossier=$(echo "$result" | grep "^dossier:" | sed -E 's/^dossier: (.*)$/\1/')

        dialog --title "Обновленное досье студента $studentFullName" \
            --msgbox "$updatedDossier" \
            "$HEIGHT" "$WIDTH"
        exit
        ;;
    esac

done
