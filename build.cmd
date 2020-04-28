rem - faire une copie des sources dans un dossier "copie"
rem - créer une dossier "Exe" vide pour le moment
rem - aller dans le dossier "copie" et créer une archive MonJeu.Zip au niveau du fichier main.lua
rem - renommer le fichier MonJeu.zip en MonJeu.love
rem - déplacer MonJeu.love dans le dossier "Exe"
rem - récupérer le déploiement de Love dans le dossier "Exe". Concerver *.dll, *.exe et *.ico. (Dans c:\program files\love\)
rem - concaténer love.exe avec monjeu.love : copy /b love.exe+monjeu.love monjeu.exe
rem - Supprimer (si besoin) le fichier monjeu.love

@echo off
rd d:\temp\dist /s /q
rd d:\temp\exe /s /q
mkdir d:\temp\dist
mkdir d:\temp\exe
xcopy *.lua d:\temp\dist /s
xcopy *.fft d:\temp\dist /s
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
jar -cMf d:\temp\GridCrawler.zip .
rd d:\temp\dist /s /q
