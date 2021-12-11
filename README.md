# podcastDownloader

Pod cast를 다운로드 하는 프로그램.
팟빵에서 관련 앱을 제공하지만,
회원 가입해야 함.

개인 서버가 있다면, 스크립트로 자동화 가능.

Plex 미디어 서버로 사용 가능.

plex에 업데이트 할 때, id3 태그를 어떻게 입력했는지를 보고
자신 데이터 베이스를 업데이트 함.

/tmp에 다운로드 한 뒤,
복사하여 mp3 파일 tag를 plex 데이터 베이스로 전달


TEDTalks Downloader v0.1
by Denver Gingerich (http://ossguy.com/)

여기에서 원래 소소 사용.


1. BBC 6 Minute English
2. BBC Learning English
3. 손에 잡히는 경제(이진우)
4. 3프로 신과 함께
5. 파토의 과학하고 앉아있네
6. 최준영 박사의 지구본 연구소(유트브로 옮겨 유트브 파일에서 mp3 추출)
7. 지대넓얇(종료)


detail.txt 파일을 각 폴더에 넣어 줌.


cron으로 아래와 같이 실행.


'''
$crontab -l
#Edit this file to introduce tasks to be run by cron.

#Each task to run has to be defined through a single line
#indicating with different fields when the task will be run
#and what command to run for the task

#To define the time you can provide concrete values for
#minute (m), hour (h), day of month (dom), month (mon),
#and day of week (dow) or use '*' in these fields (for 'any').#
#Notice that tasks will be started based on the cron's system
#daemon's notion of time and timezones.

#Output of the crontab jobs (including errors) is sent through
#email to the user the crontab file belongs to (unless redirected).

#For example, you can run a backup of all your user accounts
#at 5 a.m every week with:
#0 5 * * 1 tar -zcf /var/backups/home.tgz /home/

#For more information see the manual pages of crontab(5) and cron(8)

#m h  dom mon dow   command
#경제의 신과 함께
10 0 * * * /economy_god.sh
#손에잡히는 경제
20 0 * * * /economy_hand.sh
#파토가 과학하고 앉아있네
10 0 * * * /pato.sh
#지구본연구소
0 1 * * * /global_downloaderv2.sh
'''
