#!/bin/bash

#for FILE in *.webm; do
#   echo -e "Processing video '\e[32m$FILE\e[0m'";
#   ffmpeg -i "${FILE}" -vn -ab 320k -ar 44100 -y "${FILE%.webm}.mp3";
#done;



order=$(mktemp);

#FILE="AlexisFfrench-AMomentInTime-woETd5QW52E.mp3"
#Details.txt 파일에 형식 정의 ^I로 구분됨.
#SONGEXP: 곡 형식

FILEEXP=$(cat ./details.txt | grep -w FILETYPE | cut -d'	' -f2-)


#참조할 파일.
EXTRAINFO=$(cat ./details.txt | grep -w PODCASTFILE | cut -d'	' -f2-)
#기록된 파일에서 reverse order로 정렬.
#앞에 파일이 최근..

#echo $EXTRAINFO
tac $EXTRAINFO > $order;
#cp $order ./test.txt
#tac $EXTRAINFO > test;
#cat $order


#head -10 $order;

#detail을 " "로 감쌈
#echo $FILEEXP
eval mfile="$FILEEXP"
#echo $mfile
total=$(ls *."$mfile" | wc -l)
#echo "check"
#echo $total

CONTINUE=$(cat ./details.txt | grep -w CONTINUE | cut -d'	' -f2-)

#if [ -z $CONTINUE ]
#then
#	echo "continue is null"
#fi

#if [ [ ! $CONTINUE == "yes" ] && [ ! -z $CONTINUE ] ]	#처음부터 할 경우
if ! [ "$CONTINUE" == "yes" ] #처음부터 할 경우

then

	#처음 시작시.
	#echo "conTracNo is 0"
	conTrackNo=0
else
	#이어서 할 경우
	#trackNo=$(expr $total + 1)

	#다음 번호는 +1
	#번호는 현재 번호
	conTrackNo=$(cat ./details.txt | grep -w conTrackNo | cut -d'	' -f2-)
	conTrackNo=$(expr $conTrackNo + 1)
	echo "hit"
	echo $conTrackNo

fi

trackNo=0
#echo "continued"
#echo $CONTINUE

#for FILE in *."$mfile"
for FILE in $(ls *."$mfile" | sort -V)
#for FILE in $(ls *."$mfile" -t | head -100)
#for FILE in $(ls -- $mfile | sort -V)

do
	#echo "파일이름은" $FILE
	#echo $mfile
	#기록된 파일에서 reverse order로 정렬.
	#앞에 파일이 최근..

	#/가 없으면 같은 이름 파일이름을 정확하게 뽑을 수 없음.
	#/3.mp3로 구분.
	#trackNo=$(cat -n $order | grep "/"$FILE | cut -d'	' -f1)
	trackNo=$(cat -n $order | grep -e "\(/\|	\)${FILE}" | cut -d'	' -f1| sed 's/ //g')

	echo trackNo
	echo $trackNo
	echo conti is
	echo $conTrackNo

	#trackNo=$(cat -n $order | grep $FILE | cut -d'	' -f1)
	#echo $trackNo
	#number check
	#https://unix.stackexchange.com/questions/151654/checking-if-an-input-number-is-an-integer
	if [ $trackNo -eq $trackNo ] 
	then
		#이어서 할 경우 삽입.
		#trackNo=$(expr $trackNo + 116)
		#이어서하나, 새로하나 contiTrack을 더해줌.
		trackNo=$(expr $trackNo + $conTrackNo)
		diskNo=$(expr $trackNo / 100 + 1)

		echo "더해진 trackNO"
		echo $trackNo
		echo "diskNo"
		echo $diskNo
	fi
	#echo $diskNo
	#trackNo=$(expr $trackNo + 1)

	#EXTRAFILE에서 file을 찾아 두번째 정보
	SONGEXP=$(cat ./details.txt | grep -w SONGEXP | cut -d'	' -f2)
	#echo $FILE
	#echo "$SONGEXP"
	#변수에서 읽은 expression을 실행하여 다시 변수에 할당.
	eval song="$SONGEXP"
	#echo $song

	ARTISTEXP=$(cat ./details.txt | grep -w ARTISTEXP| cut -d'	' -f2)
	#echo $ARTISTEXP
	eval artist="$ARTISTEXP"
	ALBUMEXP=$(cat ./details.txt | grep ALBUMEXP| cut -d'	' -f2)
	eval album="$ALBUMEXP"

	mYearDateEXPtmp=$(cat ./details.txt | grep -w mYearDateEXP| cut -d'	' -f2)

	#echo "mYearDateEXPtmp"
	#echo $mYearDateEXPtmp
	eval myeardatetmp="$mYearDateEXPtmp"
	yeartmp=$(echo $myeardatetmp|cut -d' ' -f3);
	monthtmp=$(echo $myeardatetmp|cut -d' ' -f2);
	daytmp=$(echo $myeardatetmp|cut -d' ' -f1);

	#from 
	#https://www.unix.com/shell-programming-and-scripting/191527-converting-month-into-integer.html
	M=1
	for X in Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
	do
		[ "$monthtmp" = "$X" ] && break
		M=`expr $M + 1`
	done


	#echo $yeartmp
	#echo $M
	#echo $daytmp

	if [ $M == 13 ]
	then
		#M이 13이면 1~12까지 문자가 없는 경우
		M=$monthtmp
	fi
	myeardate=$(date --date="$(printf "%s" $yeartmp-$M-$daytmp)" +"%Y-%m-%d")
	#$yeartmp-$monthtmp-$daytmp "+%Y-%m-%d")


	#echo "여기체크"
	GENREEXP=$(cat ./details.txt | grep -w GENREEXP| cut -d'	' -f2)
	eval genre="$GENREEXP"
	ARTISTEXP2=$(cat ./details.txt | grep -w ARTISTEXP2| cut -d'	' -f2)
	#echo $ARTISTEXP

	eval artist2="$ARTISTEXP2"

	#echo "SONG" $song
	#echo "Artist" $artist
	#echo "Artist2" $artist2
	#echo "Album" $album
	#echo "Date" $myeardate
	#echo "Genre" $genre
	#echo "TrackNo" $trackNo
	#echo "Diskno" $diskNo
	#echo "체크"


	#파일을 찾지 못하면 brak
	#echo song
	#echo $song

	if [ ! -z "$song" ]
	then
		#echo "mid3v2 동작"

		#기존 태그 삭제.
		mid3v2 -D "$FILE"
		mid3v2 -t "$song" -A "$album" -a "$artist" -y "$myeardate" -T "$trackNo/$total" --TCON $genre --TPE2 "$artist2" --TPOS "$diskNo" "$FILE"
		#track no를 입력하지 않음.
		#mid3v2 -t "$song" -A "$album" -a "$artist" -y "$myeardate" --TCON $genre --TPE2 "$artist2"  "$FILE"
		#song 초기화
	else
		echo "break"
	fi
	song=""

done

