#! /bin/bash

[[ -d ./new ]] && rmdir ./new
mkdir ./new

[[ -d ./old ]] && rmdir ./old
mkdir ./old

replace_from="toyotaredo"
  replace_to="toyota_int"

for filename in ./*
do
	if [[ -f $filename ]]
	then
		echo "$filename" | grep -Fqs ".sh"
		if [[ ! $? = 0 ]]
		then
			cat "$filename" | grep -Fqs "$replace_from"
			[[ $? = 0 ]] && cat $filename | sed "s/$replace_from/$replace_to/g" >./new/$filename
			[[ $? = 0 ]] && mv $filename ./old/$filename && mv ./new/$filename ./$filename

		fi
	fi
done