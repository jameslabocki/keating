#!/bin/bash

# Creates a payload file with certain number of hosts for migration analytics consumption
# ./keating.sh 5 will create keating.json with 5 hosts in it

die () {
    echo >&2 "$@"
    exit 1
}

#exit if no arguemts are given
[ "$#" -eq 1 ] || die "./keating.sh [Number of Hosts]"

i=0

echo "copying mastertemplate.json to keating.json"
cp mastertemplate.json keating.json

while [ $i -lt $1 ]; 
do 
	echo "creating host${i}"
	sed -e "s/IDENTIFIER/$i/" -e "s/SHORTNAME/host-$i/" -e "s/FQDN/host-$i.example.com/g" hosttemplate.json >> keating.json
	i=$[$i+1]
done

echo "completing file format"
echo " ]" >> keating.json
echo " }" >> keating.json
echo "}"  >> keating.json


echo "removing last comma hack"
#remove comma from the last host instance (cheap and fast method - and unexplainable :)
sed -i '$x;$G;/\(.*\),/!H;//!{$!d};  $!x;$s//\1/;s/^\n//' keating.json



