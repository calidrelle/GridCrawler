@echo off
rd d:\temp\dist /s /q
rd d:\temp\exe /s /q
mkdir d:\temp\dist
mkdir d:\temp\exe
xcopy *.lua d:\temp\dist /s
xcopy *.ttf d:\temp\dist /s
xcopy *.png d:\temp\dist /s
xcopy *.wav d:\temp\dist /s
xcopy *.mp3 d:\temp\dist /s
d:
cd d:\temp\dist\
jar -cMf d:\temp\exe\game.love . 
cd d:\temp\exe\
copy "c:\program files\love\love.exe" . 
copy "c:\program files\love\*.dll" . 
copy "c:\program files\love\*.ico" . 
copy /b love.exe+game.love GridCrawler.exe
del game.love
del love.exe
jar -cMf d:\dev\GridCrawler.zip .
echo --------------------------
echo Build dispo dans d:\dev\GridCrawler.zip
echo --------------------------

