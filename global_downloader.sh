#!/bin/sh

echo "지구본연구소 유투브 다운로더"
echo "2021-5-30 작성"

temp_directory=$(mktemp -d)
cd $temp_directory

temp_details=$(mktemp --tmpdir=./)
temp_file=$(mktemp --tmpdir=./)
temp_file_vedio=$(mktemp --tmpdir=./)



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
echo
FEED=$(mktemp)
URLS=$(mktemp)

echo "지구본연구소"
TITLE=title.txt
INFOFILE=youtubeFileAndTitle.txt

DIRNAME=지구본연구소
#과거주소
#podcast_address=http://pod.ssenhosting.com/rss/geesik02
#lynx로 변경..
#wget은 파일을 받을 수 없음.
#lynx -source ${podcast_address} > ${FEED}


#youtube 주소
podcast_address=https://www.youtube.com/feeds/videos.xml?channel_id=UCstI8HwGQsHdqLDgyH0PImw
${GET_CMD} ${FEED} ${podcast_address}

globalCouter=20;
#과학과사람들fileInfo.txt 만듦.
#filename, path, title, 업데이트일 순으로 정리
for i in $(seq 1 $globalCouter);
do
	#echo $i
	title=$(xpath -q -e "//feed/entry[position()=$i]/title" ${FEED})
	#title3=$(echo $title | sed 's/<title>//g' | sed 's/<\/title>//' | sed 's/,//g' | sed 's/ /_/g' | sed 's/[^a-z,A-Z,0-9,가-흫]//g')
	title3=$(echo $title | sed 's/<title>//g' | sed 's/<\/title>//' | sed 's/,//g')

	#echo $title3
	#file 이름에 -가 들어가면 문제.
	file=$(xpath -q -e "//feed/entry[position()=$i]/id/" ${FEED}| sed 's/,//g' |sed 's/<id>//g' | sed 's/<\/id>//g' |sed 's/-/_/g' |  cut -d: -f3 )".mp3"
	#echo $file
	pub=$(xpath -q -e "//feed/entry[position()=$i]/published/" ${FEED}  | sed 's/<published>//g' | sed 's/<\/published>//g' | cut -d'T' -f1 | sed 's/-/ /g')

	pubYear=$(echo $pub | cut -d' ' -f1)
	pubMonth=$(echo $pub | cut -d' ' -f2)
	pubDay=$(echo $pub | cut -d' ' -f3)


	uri=$(xpath -q -e "//feed/entry[position()=$i]/link/" ${FEED}| sed 's/,//g' | cut -d'"' -f4 )
	#monthtmp=$(echo $pub | cut -d'-' -f2)
	#daytmp=$(echo $pub | cut -d'-' -f1)
	#yeartmp=$(echo $pub | cut -d'-' -f3)
	#echo $pubTmp
	#echo $pub

	#20개를 기본으로 몇 개 있는지 모르기 때문에,
	#title이 없으면 break;
	if [ -z "$title" ]
	then
		break;
	fi

	printf "$file" >> ${URLS}
	printf "," >> ${URLS}
	printf "$title3" >> ${URLS}
	printf "," >> ${URLS}
	#printf "$pub" >> ${URLS}
	printf "$pubDay" >> ${URLS}
	printf " ">> ${URLS}
	printf "$pubMonth" >> ${URLS}
	printf " ">> ${URLS}
	printf "$pubYear" >> ${URLS}
	printf "," >> ${URLS}
	printf "$uri" >> ${URLS}
	printf "," >> ${URLS}
	printf "\n" >> ${URLS}

	#sleep 1

done

#cp ${URLS} ${DIRNAME}/${INFOFILE2}

for line in $(cat ${URLS}| cut -d',' -f1,4); do
	#SIZE=`echo ${line} | cut -d: -f1`
	#echo "출력분"
	#URL=`echo ${line} | cut -d'"' -f2-`
	URL=$(echo ${line}| cut -d"," -f2)

	#동영상에 맞는 FILE name로 변경.
	FILENAME=$(echo ${line}| cut -d"," -f1)
	#echo URL:
	#echo ${URL}
	#echo FILENAME:
	#echo ${FILENAME}

	#if [ ! -f "${FILENAME}" ]; then
	if [ ! -f "/mnt/ExtSSD/Podcast/$DIRNAME/${FILENAME}" ]; then

#	 || [ ${SIZE} -ne `ls -l "${FILENAME}" | awk '{print $5}'` ]; then
		#rm -f "${FILENAME}"
		#${GET_CMD} "${FILENAME}" "${URL}"
		#https://askubuntu.com/questions/423508/can-i-directly-download-audio-using-youtube-dl
		#youtube-dl ${URL} -f 133 -o ${FILENAME}
		#youtube-dl ${URL} ${FILENAME}
		#https://kutar37.tistory.com/entry/youtube-dl-%EC%82%AC%EC%9A%A9%EB%B2%95
		#다음 명령은 잘 안됨
		#youtube-dl ${URL} --audio-format mp3 -x -o ${FILENAME}
		#https://askubuntu.com/questions/178481/how-to-download-an-mp3-track-from-a-youtube-video
		#그냥 받으면 mp3를 제대로 읽을 수 없음.
		#youtube-dl --extract-audio --audio-format m4a ${URL} -o ${FILENAME}
		#youtube-dl ${URL} -o $temp_file_vedio


		#cron으로 적용시 fullpath 명시
		#/usr/local/bin/youtube-dl ${URL} -o $temp_file_vedio
		#youtube-dl 속도가 너무 느림
		#yt-dlp로 변경
		/usr/bin/yt-dlp ${URL} -o $temp_file_vedio


		#출력이 어떻게 될지 모름..
		#다음과 같이 정리
		#sleep 1
		tmp_file=$(ls -S $temp_file_vedio* | head -1)
		#echo "tmp file is" $tmp_file
		#sleep 1
		ffmpeg -i $tmp_file ${FILENAME} 
		#파일 사용후 삭제.
		rm $tmp_file

	fi
	#sleep 1
done
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
#한번에 하면 왜 안되는지 할 수 없음.
#total_count=$(ls /mnt/ExtSSD/Podcast/${DIRNAME}/*.{mp3,m4a} | wc -l)

#두번에 계산

#count_mp3=$(ls /mnt/ExtSSD/Podcast/${DIRNAME}/*.mp3 | wc -l)
#count_m4a=$(ls /mnt/ExtSSD/Podcast/${DIRNAME}/*.m4a | wc -l)
total_count=$(ls /mnt/ExtSSD/Podcast/${DIRNAME}/*.mp3 | wc -l)
#total_count=$(expr $count_mp3 + $count_m4a)

#echo DIRNAME is $DIRNAME
echo "conTrackNo	$total_count" >> $temp_details
#echo "total count " $total_count
cp $temp_details ./details.txt

/mnt/ExtSSD/Podcast/makePod.sh
#tag 업데이트 후 파일 이동

#echo $temp_directory

mv -n *.mp3 /mnt/ExtSSD/Podcast/$DIRNAME/
mv -f $INFOFILE /mnt/ExtSSD/Podcast/$DIRNAME/
mv -f $temp_details /mnt/ExtSSD/Podcast/$DIRNAME/details.txt

cd /tmp
rm -rf $temp_directory
