@echo off

rem Variable à changer selon l'environnement et le projet
set distdir=c:\temp\dist
set exedir=c:\temp\exe
set lovedir=c:\program files\love
set deploydir=d:\dev
set gamename=GridCrawler

set /p version=<version.txt
rd %distdir% /s /q
rd %exedir% /s /q
mkdir %distdir%
mkdir %exedir%
xcopy *.lua %distdir% /s
xcopy *.ttf %distdir% /s
xcopy *.png %distdir% /s
xcopy *.wav %distdir% /s
xcopy *.mp3 %distdir% /s
xcopy changelog.txt %distdir% /s

cd %distdir%\
powershell -Command "(gc main.lua) -replace 'xx.xx.xx', '%version%' | Out-File -encoding ASCII main.lua"

jar -cMf %exedir%\game.love . 
cd %exedir%\
copy "%lovedir%\love.exe" . 
copy "%lovedir%\*.dll" . 
copy "%lovedir%\*.ico" . 
copy /b love.exe+game.love %gamename%.exe
del game.love
del love.exe
xcopy %distdir%\changelog.txt .
jar -cMf %deploydir%\%gamename%.v%version%.zip .
echo --------------------------
echo Build dispo dans %deploydir%\%gamename%.v%version%.zip
echo --------------------------
