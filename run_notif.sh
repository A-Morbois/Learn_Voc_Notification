#!/bin/bash

#Attention à l'encodage des fichiers de config et vocabulaire
current_location=$(pwd);

. "$current_location/config";

vocabulary_files="$current_location/$VocPath"
vocabulary_img="$current_location/$ImgPath"


Sleep_time=60*$Rest
while [ $Duration > 0 ]; do

  word=$(shuf -n 1 "$vocabulary_files/voc.txt")


  notify-send  -u normal -t 1000 $(echo $word | tr ";" "  ,  ") #-i $ImgPath
  Duration=$(($Duration-$Rest))
  echo "$Duration Time left"
  sleep  $Duration
done


## for the image integration
: '
IFS=';'
Vocs=$(read -ra $word)

for i in "${Vocs[@]}"; do # access each element of array
  echo "$i"
done
'
