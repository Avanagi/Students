#!/bin/bash

# вывод по фамилии студента его досье;
# возможность добавления новых фраз в досье;

# фио студента(возможен поиск по частичной фамилии)
studentName=$1

# текст, который неоюбходимо добавить в досье
textToAdd=$2

# директория до файловой системы
dir=$3

appPath=$4

fistLatter=$(echo "${studentName:0:1}" | tr '[:lower:]' '[:upper:]')
filePath="$dir"/"students"/"general"/"notes"/"${fistLatter}Names.log"

result=$("$appPath"/backend/find_dossier.sh "$studentName" "$dir")

dossier=$(echo "$result" | grep "^dossier:" | sed -E 's/^dossier: (.*)$/\1/')

newDossier="$dossier"' '"$textToAdd"

sed -i "s/$dossier/$newDossier/" "$filePath"
