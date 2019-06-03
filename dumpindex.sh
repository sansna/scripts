#!/bin/bash
# 1 src
# 2 dst
DB1=$1
db1=$2
tb1=$3

DB2=$4
db2=$5
tb2=$6
echo "DB1" $DB1
echo "DB2" $DB2
echo "db1" $db1
echo "db2" $db2
echo "tb1" $tb1
echo "tb2" $tb2

strselfdelete="db."$tb1".getIndexes()"
echo "use $db1" > $db1-$tb1-1.js
echo "$strselfdelete" >> $db1-$tb1-1.js
echo "use $db2" > $db2-$tb2-2.js
selfdelete=$(mongo --quiet "$DB1"  < $db1-$tb1-1.js| sed 's/\n//g')
#echo $selfdelete
while read -r i;do 
    echo "db."$tb2".createIndex({"$i"},{background:1})" >> $db2-$tb2-2.js;
done < <(echo $selfdelete | sed 's/ //g'|sed 's/\]//g'|sed 's/\[//g' | gawk -vFS='key' -vRS='"v":' '{print $2}'| cut -d\} -f 1|cut -d\{ -f 2|grep -v ^$)
selfdelete=$(mongo --quiet "$DB2" < $db2-$tb2-2.js)
