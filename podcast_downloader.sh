#!/bin/sh
#
# TEDTalks Downloader
#
# Copyright (C) 2009  Denver Gingerich
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.


#cron을 위한 cd
cd /mnt/ExtSSD/Podcast
FEED=feed_podcast.xml
URLS=urls_podcast


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

#BBC 6minute English
DIRNAME=Bbc6Min
podcast_address=http://www.bbc.co.uk/programmes/p02pc9tn/episodes/downloads

${GET_CMD} ${FEED} ${podcast_address}

sed -e 's/</\r\n/g' ${FEED}| grep mp3 |\
#2019.3.5 추가.
#feed 주소가 변경되어서 필터 추가
grep class |\

#주소의 // 삭제
cut -d "\"" -f4 | cut -d "/" -f3- > ${URLS};

#sed -e 's/^ *<enclosure url="\([^"]*\)" type="audio\/mpeg3" length="" \/>/\1/g' > ${URLS};


mkdir -p ${DIRNAME}
cd ${DIRNAME}
for line in `cat ../${URLS} | head -10`; do
	#SIZE=`echo ${line} | cut -d: -f1`
	#echo "출력분"
	#URL=`echo ${line} | cut -d'"' -f2-`
	URL=`echo ${line}| tr  -d '\r'`
	FILENAME=`basename ${URL}|tr -d '\r'`

	#echo ${URL}
	#echo ${FILENAME}
	if [ ! -f "${FILENAME}" ]; then
#	 || [ ${SIZE} -ne `ls -l "${FILENAME}" | awk '{print $5}'` ]; then
		rm -f "${FILENAME}"
		${GET_CMD} "${FILENAME}" "${URL}"
	fi
done

cd ..


#BBC 6minute English
DIRNAME=Newsreview

rm -f ${FEED}
rm -f ${URLS}
podcast_address=http://www.bbc.co.uk/programmes/p05hw4bq/episodes/downloads

${GET_CMD} ${FEED} ${podcast_address}

sed -e 's/</\r\n/g' ${FEED}| grep mp3 |\
#2019.3.5 추가.
#feed 주소가 변경되어서 필터 추가
grep class |\

#주소의 // 삭제
cut -d "\"" -f4 | cut -d "/" -f3- > ${URLS};

#sed -e 's/^ *<enclosure url="\([^"]*\)" type="audio\/mpeg3" length="" \/>/\1/g' > ${URLS};


mkdir -p ${DIRNAME}
cd ${DIRNAME}
for line in `cat ../${URLS}| head -10`; do
	#SIZE=`echo ${line} | cut -d: -f1`
	#echo "출력분"
	#URL=`echo ${line} | cut -d'"' -f2-`
	URL=`echo ${line}|tr -d '\r'`
	FILENAME=`basename ${URL}|tr -d '\r'`

	#echo ${URL}
	#echo ${FILENAME}
	if [ ! -f "${FILENAME}" ]; then
#	 || [ ${SIZE} -ne `ls -l "${FILENAME}" | awk '{print $5}'` ]; then
		rm -f "${FILENAME}"
		${GET_CMD} "${FILENAME}" "${URL}"
	fi
done


cd ..



##지대넓얕
#DIRNAME=지대넓얕
#
#
#rm -f ${FEED}
#rm -f ${URLS}
#podcast_address=http://pod.ssenhosting.com/rss/rrojia2/rrojia2.xml
#
#${GET_CMD} ${FEED} ${podcast_address}
#
#xpath -e '//enclosure/@url' ${FEED} |\
#cut -d "\"" -f2 > ${URLS}
#
##sed -e 's/</\r\n/g' ${FEED}| grep mp3 |\
##cut -d "\"" -f4 > ${URLS};
#
#mkdir -p ${DIRNAME}
#cd ${DIRNAME}
#for line in `cat ../${URLS}`; do
#	#SIZE=`echo ${line} | cut -d: -f1`
#	#echo "출력분"
#	#URL=`echo ${line} | cut -d'"' -f2-`
#	URL=`echo ${line}`
#	FILENAME=`basename ${URL}|tr -d '\r'`
#
#	#echo ${URL}
#	#echo ${FILENAME}
#	if [ ! -f "${FILENAME}" ]; then
##	 || [ ${SIZE} -ne `ls -l "${FILENAME}" | awk '{print $5}'` ]; then
#		rm -f "${FILENAME}"
#		${GET_CMD} "${FILENAME}" "${URL}"
#	fi
#done
#
#
#cd ..
#
##권한 변경..
#find ./ -type f -exec chmod 755 {} \;


#BBC Leaning English
DIRNAME=LearningEnglish

rm -f ${FEED}
rm -f ${URLS}
podcast_address=http://www.bbc.co.uk/learningenglish/english/course/upper-intermediate/unit-1

${GET_CMD} ${FEED} ${podcast_address}

sed -e 's/</\r\n/g' ${FEED}| grep mp3 |\
cut -d "\"" -f4 > ${URLS};

#sed -e 's/^ *<enclosure url="\([^"]*\)" type="audio\/mpeg3" length="" \/>/\1/g' > ${URLS};


mkdir -p ${DIRNAME}
cd ${DIRNAME}
for line in `cat ../${URLS} | head -10`; do
	#SIZE=`echo ${line} | cut -d: -f1`
	#echo "출력분"
	#URL=`echo ${line} | cut -d'"' -f2-`
	URL=`echo ${line}|tr -d '\r'`
	FILENAME=`basename ${URL}|tr -d '\r'`

	#echo ${URL}
	#echo ${FILENAME}
	if [ ! -f "${FILENAME}" ]; then
#	 || [ ${SIZE} -ne `ls -l "${FILENAME}" | awk '{print $5}'` ]; then
		rm -f "${FILENAME}"
		${GET_CMD} "${FILENAME}" "${URL}"
	fi
done


cd ..

#DIRNAME=비디오가게
#
#rm -f ${FEED}
#podcast_address=http://www.podbbang.com/ch/17111
#${GET_CMD} ${FEED} ${podcast_address}
#
#cat ${FEED} | grep -e "link_file.*\.mp3" | sed -e 's/	//g' | sed -e 's/ //    g' |sed -e "s/'//g"| sed -e 's/,//g'| cut -d: -f2-  > ${URLS};
#
#mkdir -p ${DIRNAME}
#cd ${DIRNAME}
#for line in `cat ../${URLS}`; do
#	#SIZE=`echo ${line} | cut -d: -f1`
#	#echo "출력분"
#	#URL=`echo ${line} | cut -d'"' -f2-`
#	URL=`echo ${line}|tr -d '\r'`
#	FILENAME=`basename ${URL}|tr -d '\r'`
#
#	#echo ${URL}
#	#echo ${FILENAME}
#	if [ ! -f "${FILENAME}" ]; then
##	 || [ ${SIZE} -ne `ls -l "${FILENAME}" | awk '{print $5}'` ]; then
#		rm -f "${FILENAME}"
#		${GET_CMD} "${FILENAME}" "${URL}"
#	fi
#done
#
#cd ..
#

