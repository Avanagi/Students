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

    oldDossier=$("$appPath"/backend/display_dossier.sh "$studentName" "$filePath")

    case $? in
    1)
        dialog --title "Ошибка" \
            --msgbox "$oldDossier" \
            "$HEIGHT" "$WIDTH"
        ;;
    0)
        # TODO: добавить вывод первоначального досье
        newDossier=$(
            dialog --title "Дополните досье" \
                --inputbox "Введите данные, которые будут добавлены в конец досье ученика:" \
                "$HEIGHT" "$WIDTH" \
                3>&1 1>&2 2>&3
        )
        # удаление специальных симоволов
        cleanedNewDossier=$(echo "$newDossier" | sed -E 's,\\t|\\r|\\n,,g')

        "$appPath"/backend/edit_dossier.sh "$studentName" "$cleanedNewDossier" "$filePath"

        # вывод обновленного досье
        updatedDossier=$("$appPath"/backend/display_dossier.sh "$studentName" "$filePath")

        dialog --title "Обновленное досье" \
            --msgbox "$updatedDossier" \
            "$HEIGHT" "$WIDTH"
        exit
        ;;
    esac

done
