#!/bin/sh
echo "파토가 과학하고 앉아있네 다운로드"
temp_directory=$(mktemp -d)
cd $temp_directory
temp_file=$(mktemp --tmpdir=./)
temp_details=$(mktemp --tmpdir=./)
temp_details2=$(mktemp --tmpdir=./)


which wget
if [ $? -eq 0 ]; then
	echo "Using wget..."
	GET_CMD="wget --quiet -O"
else
	which curl
	if [ $? -eq 0 ]; then
		echo "Using curl..."
		GET_CMD="curl -L -o"
	else
		echo "Could not find wget or curl"
		exit 2
	fi
fi

FEED=feed_podcast.xml
#URLS: 이번 파일
URLS=urls_podcast
#INFOFILE: 누적 파일.
INFOFILE=파토가과학하고앉아있네FileAndTitle.txt
#URLS을 INFOFILE에 추가.
#sort -u로 중복 삭제, 날자로 정렬
#INFOFILE은 id3v2 업데이트 할 때 필요.
#이번 파일만 업데이트.
#기존 파일은 나둠.

DIRNAME=파토의과학
#podcast_address=http://www.podbbang.com/ch/6205
podcast_address=https://feeds.feedburner.com/sciencewithpeople
${GET_CMD} ${FEED} ${podcast_address}

<<"TEST"
#xpath 
#get nth item
#xpath -e "//rss/channel/item[position()=2]/title" temp2.txt
patoCouter=10
#과학과사람들fileInfo.txt 만듦.
#filename, path, title, 업데이트일 순으로 정리
for i in {1..10}
do
	title=$(xpath -q -e "//rss/channel/item[position()=$i]/title" ${FEED})
	title2=$(echo $title | sed 's/<title>//g' | sed 's/<\/title>//')

	fileTmp=$(xpath -q -e "//rss/channel/item[position()=$i]/enclosure" ${FEED})
	file=$(echo $fileTmp | cut -d'"' -f2)
	echo $file


done
TEST

#xpath 
#get nth item
#xpath -e "//rss/channel/item[position()=2]/title" temp2.txt
patoCouter=2;
#과학과사람들fileInfo.txt 만듦.
#filename, path, title, 업데이트일 순으로 정리
for i in $(seq 1 $patoCouter);
do
	#echo $i
	title=$(xpath -q -e "//rss/channel/item[position()=$i]/title" ${FEED})
	title2=$(echo $title | sed 's/<title>//g' | sed 's/<\/title>//')
	title3=$(echo $title2 | sed 's/  / /g' | sed 's/,/_/g')
	#echo $title3

	fileTmp=$(xpath -q -e "//rss/channel/item[position()=$i]/enclosure" ${FEED})
	file=$(echo $fileTmp | cut -d'"' -f2)
	#echo $file

	pubTmp=$(xpath -q -e "//rss/channel/item[position()=$i]/pubDate" ${FEED})
	pub=$(echo $pubTmp| sed 's/<pubDate>//g' | sed 's/<\/pubDate>//'| cut -d',' -f2 | cut -d' ' -f1-4 | sed 's/^ //g')
	#monthtmp=$(echo $pub | cut -d'-' -f2)
	#daytmp=$(echo $pub | cut -d'-' -f1)
	#yeartmp=$(echo $pub | cut -d'-' -f3)
	#echo $pubTmp
	#echo $pub
	#echo $monthtmp
	#from
    #https://www.unix.com/shell-programming-and-scripting/191527-converting-month-into-integer.html
    #M=1
    #for X in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
    #do
	#	[ "$monthtmp" = "$X" ] && break
	#	M=`expr $M + 1`
	#done
	#myeardate=$(date --date="$(printf "%s" $yeartmp-$M-$daytmp)" +"%Y-%m-%d")
	#echo $myeardate

	printf "$title3" >> ${URLS}
	printf "," >> ${URLS}
	printf "$file" >> ${URLS}
	printf "," >> ${URLS}
	printf "$pub" >> ${URLS}
	printf "\n" >> ${URLS}
done


for line in $(cat ${URLS} | cut -d',' -f2);
do
	#SIZE=`echo ${line} | cut -d: -f1`
	#echo "출력분"
	#URL=`echo ${line} | cut -d'"' -f2-`
	#URL=`echo ${line} | tr -d '\r' | cut -d',' -f2`
	URL=$(echo ${line} | cut -d',' -f2)
	#echo ${line}
	#echo URL is $URL
	FILENAME=`basename ${URL}|tr -d '\r'`

	#echo ${URL}
	#echo ${FILENAME}
	if [ ! -f "/mnt/ExtSSD/Podcast/$DIRNAME/${FILENAME}" ]; then

		${GET_CMD} "${FILENAME}" "${URL}"
	fi
done

#mid3v2로 id3 tag도 업데이트
#detail을 복사
cp /mnt/ExtSSD/Podcast/$DIRNAME/details.txt ./$temp_details
cp /mnt/ExtSSD/Podcast/$DIRNAME/$INFOFILE ./$temp_file
cat $URLS >> $temp_file
sort $temp_file -u -k 4 -r > $INFOFILE

#이어지도록 details 내용 수정
#continue, trackno 삭제
sed -i '/conTrackNo/d' $temp_details 
#mv $temp_details2 $temp_details
sed -i '/CONTINUE/d' $temp_details 
#mv $temp_details2 $temp_details

echo "CONTINUE	yes" >> $temp_details
total_count=$(ls /mnt/ExtSSD/Podcast/파토의과학/*.mp3 | wc -l)
echo "conTrackNo	$total_count" >> $temp_details
cp $temp_details ./details.txt

/mnt/ExtSSD/Podcast/makePod.sh

#tag 업데이트 후 파일 이동
mv -n *.mp3 /mnt/ExtSSD/Podcast/$DIRNAME/
mv -f $INFOFILE /mnt/ExtSSD/Podcast/$DIRNAME/
mv -f $temp_details /mnt/ExtSSD/Podcast/$DIRNAME/details.txt

cd /tmp
rm -rf $temp_directory
