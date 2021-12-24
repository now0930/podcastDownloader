#!/bin/bash

echo "track no를 다시 순서로 맞춤"
echo "입력으로 파일 이름, 순서로 파일이 필요"
#cat $1

no=1
diskno=1
cat $1 | cut -d',' -f1 | while read filename
do
	#echo "no $no, disk no $diskno" 
	find ./ -type f -iname $filename -exec  mid3v2 -T "$no/$diskno" {} \;
	no=$(expr $no + 1 )
	diskno=$(expr $no / 100 + 1 )
done 
