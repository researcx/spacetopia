@echo off
SET thisDir=%~dp0
where /q dm.exe
IF ERRORLEVEL 0 GOTO BUILD
echo dm.exe not found in PATH.
GOTO :END
:BUILD
cd "%thisDir%..\goonstation"
dm.exe -o goonstation.dme > "%thisDir%objectTree.txt"
cd "%thisDir%"
php reparseObjectTree.php objectTree.txt objectTree.xml
:END
echo done.
