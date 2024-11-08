#!/bin/bash

# Проверяем, установлен ли dialog
if ! command -v dialog &>/dev/null; then
    echo "Утилита dialog не установлена. Установите её для работы приложения."
    exit 1
fi

HEIGHT=15
WIDTH=85
EXIT_CONST=6

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

DIRECTORY_FILE="frontend/directory.txt"

# Проверяем наличие файла с сохраненной директорией
if [ ! -e "$DIRECTORY_FILE" ] || [ "$1" == "-r" ]; then
    # Если файла нет или передан флаг "-r", показываем диалог
    selectedDir=$(dialog --title "Выберите директорию, в которой распологаются файлы " --dselect "$HOME" "$HEIGHT" "$WIDTH" 3>&1 1>&2 2>&3)

    # Проверяем, была ли выбрана директория
    if [ -n "$selectedDir" ]; then
        # Сохраняем выбранную директорию в файл
        echo "$selectedDir" >"$DIRECTORY_FILE"
    fi
else
    # Если файл есть, читаем из него директорию
    selectedDir=$(cat "$DIRECTORY_FILE")
fi

choice=0
while [ ! "$choice" = $EXIT_CONST ]; do
    choice=$(dialog --title "Меню" \
        --no-cancel \
        --menu "Выберите действие:" $HEIGHT $WIDTH 4 \
        1 "Показать группу отсортированную по попыткам сдачи теста" \
        2 "Показать учеников с лучшей посещаемостью в группе" \
        3 "Показать досье студента" \
        4 "Редактировать досье студента" \
        5 "Показать студентов, давших наибольшее общее количество правильных ответов" \
        6 "Выход" 3>&1 1>&2 2>&3)

    case "$choice" in
    1)
        "$SCRIPTPATH"/frontend/first.sh "$SCRIPTPATH" $HEIGHT $WIDTH "$selectedDir"
        ;;
    2)
        "$SCRIPTPATH"/frontend/best_attidance.sh "$SCRIPTPATH" $HEIGHT $WIDTH "$selectedDir"
        ;;
    3)
        "$SCRIPTPATH"/frontend/show_dossier.sh "$SCRIPTPATH" $HEIGHT $WIDTH "$selectedDir"
        ;;
    4)
        "$SCRIPTPATH"/frontend/edit_dossier.sh "$SCRIPTPATH" $HEIGHT $WIDTH "$selectedDir"
        ;;
    5)
        "$SCRIPTPATH"/frontend/max_tries.sh "$SCRIPTPATH" $HEIGHT $WIDTH "$selectedDir"
        ;;
    esac
done
clear
