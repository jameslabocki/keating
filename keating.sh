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
	a="${i}1"
	b="${i}2"
	c="${i}3"
	d="${i}4"
	e="${i}5"
	f="${i}6"
	g="${i}7"
	h="${i}8"
	j="${i}9"
	echo "creating host${i}"
	sed -e "s/IDENTIFIER/$i/" \
	    -e "s/SHORTNAME/host-$i/"  \
	    -e "s/VMID1/$a/" \
	    -e "s/VMNAME1/virtual-$a/" \
	    -e "s/VMEMS1/vm-$a/" \
	    -e "s/VMID2/$b/" \
	    -e "s/VMNAME2/virtual-$b/" \
	    -e "s/VMEMS2/vm-$b/" \
	    -e "s/VMID3/$c/" \
	    -e "s/VMNAME3/virtual-$c/" \
	    -e "s/VMEMS3/vm-$c/" \
	    -e "s/VMID4/$d/" \
	    -e "s/VMNAME4/virtual-$d/" \
	    -e "s/VMEMS4/vm-$d/" \
	    -e "s/VMID5/$e/" \
	    -e "s/VMNAME5/virtual-$e/" \
	    -e "s/VMEMS5/vm-$e/" \
	    -e "s/VMID6/$f/" \
	    -e "s/VMNAME6/virtual-$f/" \
	    -e "s/VMEMS6/vm-$f/" \
	    -e "s/VMID7/$g/" \
	    -e "s/VMNAME7/virtual-$g/" \
	    -e "s/VMEMS7/vm-$g/" \
	    -e "s/VMID8/$h/" \
	    -e "s/VMNAME8/virtual-$h/" \
	    -e "s/VMEMS8/vm-$h/" \
	    -e "s/VMID9/$j/" \
	    -e "s/VMNAME9/virtual-$j/" \
	    -e "s/VMEMS9/vm-$j/" \
            -e "s/FQDN/host-$i.example.com/g" hosttemplate.json >> keating.json
	i=$[$i+1]
done

echo "completing file format"
echo " ]" >> keating.json
echo " }" >> keating.json
echo "}"  >> keating.json


echo "removing last comma hack"
#remove comma from the last host instance (cheap and fast method - and unexplainable :)
sed -i '$x;$G;/\(.*\),/!H;//!{$!d};  $!x;$s//\1/;s/^\n//' keating.json


echo "compressing"
tar -cvf keating.tar keating.json
gzip keating.tar
