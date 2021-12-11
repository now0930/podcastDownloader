#!/bin/sh

echo "신과함께 다운로드"
#cron을 위한 cd
#cd /mnt/ExtSSD/
temp_directory=$(mktemp -d)
cd $temp_directory
temp_file=$(mktemp --tmpdir=./)


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
URLS=urls_podcast

TITLE=title.txt
INFOFILE=신과함께FileAndTitle.txt

DIRNAME=신과함께
podcast_address=http://pod.ssenhosting.com/rss/geesik02
#lynx로 변경..
#wget은 파일을 받을 수 없음.
#${GET_CMD} ${FEED} ${podcast_address}
lynx -source ${podcast_address} > ${FEED}

#cat ${FEED} | sed -n '/^<title>\[.*page2.*\]/,/type="audio/p' | grep enclosure | cut -d'"' -f2 > ${URLS};
cat ${FEED} | sed -n '/^<title>\[.*라이브.*\]/,/type="audio/p' | grep enclosure | cut -d'"' -f2 > ${URLS};


#target file을 만듦.
cat ${FEED} | tr -d '\n' | sed  's/<item>/\n<item>/g' > ${TITLE}
while read filename;
do
	tmpTitle=$(cat ${TITLE} | grep "$filename" | awk 'BEGIN{FS="<title>"}{print $2}' | awk 'BEGIN{FS="</title>"}{print $1}')
	tmpPubdate=$(cat ${TITLE} | grep "$filename" | awk 'BEGIN{FS="<pubDate>"}{print $2}' | awk 'BEGIN{FS="</pubDate>"}{print $1}')
	printf "$filename\t%s\t%s\n" "$tmpTitle" "$tmpPubdate" >> ${INFOFILE}

done < ${URLS}

for line in `cat ${URLS}| head -5`; do
	URL=`echo ${line}|tr -d '\r'`
	FILENAME=`basename ${URL}|tr -d '\r'`
	echo ${URL}
	echo ${FILENAME}
	if [ ! -f "/mnt/ExtSSD/Podcast/$DIRNAME/${FILENAME}" ]; then
		echo "download files"
		${GET_CMD} "${FILENAME}" "${URL}"
	fi
done


#mid3v2로 id3 tag도 업데이트
#detail을 복사
cp /mnt/ExtSSD/Podcast/$DIRNAME/details.txt ./
#cp /mnt/ExtSSD/Podcast/$DIRNAME/$INFOFILE ./$temp_file
#cat $URLS >> $temp_file
#sort $temp_file -u -k 4 -r >> $INFOFILE


/mnt/ExtSSD/Podcast/makePodv4.sh

echo "temp directory"
echo $temp_directory

#tag 업데이트 후 파일 이동
mv -n *.mp3 /mnt/ExtSSD/Podcast/$DIRNAME/
mv -f $INFOFILE /mnt/ExtSSD/Podcast/$DIRNAME/

rm -rf $temp_directory
