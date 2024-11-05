#!/bin/bash

appPath=$1
HEIGHT=$2
WIDTH=$3
filePath=$4

# TODO: добавить проверку пустых полей и варианты выхода в главное меню

group=$(dialog --title "Ввод группы" \
                --no-cancel\
                --inputbox "Введите номер группы (Формата: А-06-21):" \
                $HEIGHT $WIDTH \
                3>&1 1>&2 2>&3)

subject=$(dialog --title "Предмет" \
                    --inputbox "Введите название предмета" \
                    $HEIGHT $WIDTH \
                    3>&1 1>&2 2>&3)

test_number=$(dialog --title "Номер теста" \
                    --inputbox "Введите номер теста:" \
                    $HEIGHT $WIDTH \
                    3>&1 1>&2 2>&3)




result=$("$appPath"/backend/sorted_group_by_attemts.sh "$group" "$test_number" "$subject" "$filePath")

dialog --title "Результат" \
    --msgbox "$result" $HEIGHT $WIDTH
                



