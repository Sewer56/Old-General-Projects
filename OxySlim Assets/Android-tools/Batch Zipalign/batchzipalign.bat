@ECHO OFF
ECHO **REMINDER!!! Do not leave spaces when you name your apk files...**

FOR %%A in (.\Input\*.apk) do (
ECHO Zipaligning - %%~nA.apk
.\Tools\zipalign -cv 4 %%A 
.\Tools\zipalign -fv 4 %%A .\Output\%%~nA.apk
)

ECHO.

pause