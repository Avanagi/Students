#!/bin/bash

# Проверяем, установлен ли dialog
if ! command -v dialog &> /dev/null; then
    echo "Утилита dialog не установлена. Установите её командой:"
    echo "sudo apt-get install dialog (для Debian/Ubuntu)"
    echo "sudo yum install dialog (для CentOS/RHEL)"
    exit 1
fi



HEIGHT=15
WIDTH=80
EXIT_CONST=4

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")


choice=0
while [ ! "$choice" = $EXIT_CONST ]; do
    choice=$(dialog --title "Меню" \
        --no-cancel \
        --menu "Выберите действие:" $HEIGHT $WIDTH 4 \
        1 "Показать группу отсортированную по попыткам сдачи теста" \
        2 "Показать учеников с лучшей посещаемостью в группе" \
        3 "Показать календарь" \
        4 "Выход" 3>&1 1>&2 2>&3)
    

    case "$choice" in
        1)
            "$SCRIPTPATH"/frontend/first.sh "$SCRIPTPATH" $HEIGHT $WIDTH /home/ivan/os/os-labs/labs-2024/lab3/labfiles
            ;;
        2)  
            "$SCRIPTPATH"/frontend/best_attidance.sh "$SCRIPTPATH" $HEIGHT $WIDTH /home/ivan/os/os-labs/labs-2024/lab3/labfiles
            ;;
        3)
            
            ;;
        4)
            
            ;;
    esac

done
clear