#!/bin/sh

echo "손에 잡히는 경제 다운로드"
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

podcast_address=http://minicast.imbc.com/PodCast/pod.aspx?code=1000671100000100000
DIRNAME=이진우_손에잡히는경제

${GET_CMD} ${FEED} ${podcast_address}
#${GET_CMD} ${FEED} http://minicast.imbc.com/PodCast/pod.aspx?code=1000674100000100000 

#${GET_CMD} ${FEED} http://feeds.feedburner.com/tedtalks_video
#손에 잡히는 경제 다운로드 주소.. 
#날자 선정.2일 전까지 타겟으로.
targetDate1=$(date -d "-1 day" +"%Y%m%d")
targetDate2=$(date -d "-2 day" +"%Y%m%d")

#rss 변경으로 파일수정
grep 'type="audio/mpeg"' ${FEED} | \
head -5 | \
#grep -E "$targetDate1|$targetDate2" | \
sed -e 's/^ *<enclosure url="\([^"]*\)" type="audio\/mpeg" length=.*$/\1/g' | \
cut -d'?' -f1 > ${URLS};

for line in `cat ${URLS}`; do
	#SIZE=`echo ${line} | cut -d: -f1`
	URL=`echo ${line} |tr -d '\r'`

	#URL=`echo ${line} | cut -d: -f2-`
	FILENAME=`basename ${URL}|tr -d '\r'`
	
	echo $URL
	echo $FILENAME

	if [ ! -f "${FILENAME}" ]; then
#	 || [ ${SIZE} -ne `ls -l "${FILENAME}" | awk '{print $5}'` ]; then
		${GET_CMD} "${FILENAME}" "${URL}"
	fi
done

#echo "temp directory"
#echo $temp_directory

#tag 업데이트 후 파일 이동
mv -n *.mp3 /mnt/ExtSSD/Podcast/$DIRNAME/
#mv -f $INFOFILE /mnt/ExtSSD/Podcast/$DIRNAME/
rm -rf $temp_directory
