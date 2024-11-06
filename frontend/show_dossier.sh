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

    studentDossier=$(dialog --title "Фамилия студента" \
        --inputbox "Введите фамилию студента на английском языке:" \
        "$HEIGHT" "$WIDTH" \
        3>&1 1>&2 2>&3)

    check_cancel

    # Проверка на пустое поле
    if [ -z "$studentDossier" ]; then
        dialog --title "Ошибка" \
            --msgbox "Поле не может быть пустым!" \
            "$HEIGHT" "$WIDTH"
        continue
    fi

    # Проверка на пробелы
    if [ ! "$studentDossier" = "$(echo -e "$studentDossier" | tr -d '[:space:]')" ]; then
        dialog --title "Ошибка" \
            --msgbox "Введите фамилию без пробелов" \
            "$HEIGHT" "$WIDTH"
            continue
    fi

    result=$("$appPath"/backend/display_dossier.sh "$studentDossier" "$filePath")

    case $? in
    1)
        dialog --title "Ошибка" \
            --msgbox "$result" \
            "$HEIGHT" "$WIDTH"
        ;;
    0)
        dialog --title "Досье ученика $studentDossier" \
            --msgbox "$result" "$HEIGHT" "$WIDTH"
            exit
        ;;
    esac

done
