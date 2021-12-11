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
	#아래 루프에서 증가
	#conTrackNo=$(expr $conTrackNo + 1)
	echo "hit"
	echo $conTrackNo

fi

trackNo=0
trackNo=$(expr $trackNo + $conTrackNo)

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
	#cat -n $order
	#
#	 1	과학하고 앉아있네 S7E9 2021 노벨물리학상 특집,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1634887885321.mp3,22 Oct 2021
#     2	과학하고 앉아있네 S7E04 K박사 완전 복귀 특집! 암흑의 물질과 K박사의 어두운 미래,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1621561758166.mp3,21 May 2021
#     3	격동 500년! S7E09 X선 결정학을 불가능의 레벨까지 끌어올리다. 도로시 호지킨,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1633678920442.mp3,08 Oct 2021
#     4	뉴스룸! S7E07 현실에 가까워진 워프 드라이브_ 양궁 활과 탄소섬유_ 인간이 견딜 수 있는 온도는? feat. K박사_ 곽재식 작가,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1628235649694.mp3,06 Aug 2021
#     5	뉴스룸! S7E09 진짜 같은 합성우유_ 전고체 배터리_ 새로운 중력파 감지,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1633076684830.mp3,01 Oct 2021
#     6	격동 500년! S7E06 과학계의 아이돌_ 리처드 파인만,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1625818493064.mp3,09 Jul 2021
#     7	뉴스룸! S7E08 백신 관련 가짜뉴스_ 아프가니스탄 과학계의 위기_ 암흑에너지의 존재를 밝힌 3D 우주지도,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1630654336515.mp3,03 Sep 2021
#     8	과학하고 앉아있네 S7E07 기후 위기의 해법은 있을까 feat. 부경대학교 김백민 교수,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1629447892495.mp3,20 Aug 2021
#     9	삼테성즈! S7E08 SLBM에 담긴 기술_ 한글 맞춤법과 풀어쓰기,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1632468019235.mp3,24 Sep 2021
#    10	삼테성즈 S7E04 반도체 대란_ KF21 핵심기술 그리고 게임의 역사2!,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1622166509979.mp3,28 May 2021
#    11	뉴스룸! S7E010 요소수 대란_ 돼지 신장 이식_ 노벨 화학상_ 오무아무아,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1636763258800.mp3,12 Nov 2021
#    12	격동 500년! S7E11 대한민국의 산림을 되살리다. 현신규,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1639123192915.mp3,10 Dec 2021
#    13	격동 500년! S7E07 더위를 물리치고 인류를 구하다_ 윌리스 캐리어,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1628844722616.mp3,13 Aug 2021
#    14	(음질보정재업) 삼테성즈! S7E02 딥페이크_ 전기자동차_ NFT_ 비디오게임. Feat. K2박사_ 최팀장,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1616979006251.mp3,28 Mar 2021
#    15	뉴스룸! S7E06 배고픔의 메커니즘_ 2만4천년만에 깨어난 생물_ 그리고 제임스웹 우주망원경 feat. K박사_ 곽재식 작가,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1625469308983.mp3,05 Jul 2021
#    16	삼테성즈 S7E03 화제의 메타버스 특집! Feat. 강원대 김상균 교수,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1619141878558.mp3,23 Apr 2021
#    17	과학하고 앉아있네 S7E03 빛은 뭐고 LCD는 뭐고 OLED는 또 뭐냐? feat. 한림대 고재현 교수,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1618471405918.mp3,16 Apr 2021
#    18	격동 500년! S7E04 세계적인 나비박사 석주명 선생!,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1620965968488.mp3,14 May 2021
#    19	뉴스룸! S7E04 생명연장의 시간표_ 그리고 나의 뇌를 다스리자! feat. 카이스트 김대수 교수,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1620359306326.mp3,07 May 2021
#    20	격동 500년! S7E08 약력의 정체를 밝힌 중국의 마리퀴리_ 우젠슝,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1631258788000.mp3,10 Sep 2021
#    21	삼테성즈! S7E07 물리 엔진과 게임 스토리텔링_ 임어당의 한자 타자기_ 거함·거포 시대의 종말,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1630048724356.mp3,27 Aug 2021
#    22	삼테성즈 S7E06 버진갤럭틱 우주관광_ 한자와 타자기_ 남미의 거함·거포 경쟁,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1627037475553.mp3,23 Jul 2021
#    23	과학하고 앉아있네 S7E08 우주의 지도를 그리다_ 스피어x! feat. 천문연 정웅섭 박사,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1631863050438.mp3,17 Sep 2021
#    24	과학하고 앉아있네 S7E10 유성의 과학! feat. 한국천문연구원 황정아 박사_ 공학박사 곽재식 작가,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1637916599658.mp3,26 Nov 2021
#    25	과학하고 앉아있네 S7E05 의식의 근원을 찾아라 feat. 뇌과학자 장동선 박사,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1624496183412.mp3,23 Jun 2021
#    26	삼테성즈 S7E05 컨트롤러와 인간공학_ DOS/V의 탄생배경 그리고 거함거포 시대 직전 이야기,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1624605371567.mp3,25 Jun 2021
#    27	뉴스룸! S7E11 한국의 인공태양_ 국내 개발 수소 엔진_ 생체로봇_ 제임스 웹 우주망원경,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1638521352619.mp3,03 Dec 2021
#    28	뉴스룸! S7E05 배아 줄기세포_ 뮤온_ 그리고 암흑에너지의 진실! feat. K박사_ 곽재식,https://cdn-cf.podty.me/meta/episode_audio/22286/174371_1622704402037.mp3,04 Jun 2021

	#기존 번호가 따라 옮..
	#trackNo가 날자순대로 되지 않았음.
	#가져온 trackNo가 불필요함.
	#trackNo=$(cat -n $order | grep -e "\(/\|	\)${FILE}" | cut -d'	' -f1| sed 's/ //g')

	echo trackNo
	echo $trackNo
	echo conti is
	echo $conTrackNo

	#trackNo=$(cat -n $order | grep $FILE | cut -d'	' -f1)
	#echo $trackNo
	#number check
<<delete_here
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
delete_here

	#trackNo 1씩 증가
	trackNo=$(expr $trackNo + 1)
	diskNo=$(expr $trackNo / 100 + 1)

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

