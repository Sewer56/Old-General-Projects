:engine_19092015
@echo off
setlocal enabledelayedexpansion
:user_settings
set "autorun_png=0"
set "autorun_jpg=0"
set "autorun_gif=0"
set "autorun_option_png=0"
set "autorun_option_jpg=0"
set "autorun_option_gif=0"
set "auto_close=0"
:script
set "name=FastIO"
set "version=30.09.2015"
if "%~1" equ "thread" call:thread_work %4 %5 "%~2" "%~3" & exit /b
if "%~1" equ "" call:how_to & exit /b
title %name% - %version%
color 0f
:script_configuration
set "script_name=%~0"
set "path_source=%~dp0"
set "script_config=%path_source%lib\"
set "path_scripts=%path_source%lib\"
set "temporary_path=%temp%\%name%\"
set "time_wait=30"
set "script_lock=%temp%script.lock"
set "separe_bar=______________________________________________________________________________"
set "check_file=%path_source%\%name%"
:script_check_run
set "already_run="
call:already_run "%name% - %version%"
if defined already_run (
exit
)
set "check_file=%check_file%%already_run%"
if not defined already_run if exist "%temporary_path%" 1>nul 2>&1 rd /s /q "%temporary_path%"
:script_lib_path
set "lib=%~dp0lib\"
path %lib%;%path%
:script_check_files
set "no_file="
if not exist %lib% set "no_file=1"
if not exist %lib%gifsicle.exe set "no_file=1"
if not exist %lib%jpegoptim.exe set "no_file=1"
if not exist %lib%jpegtran.exe set "no_file=1"
if not exist %lib%pngquant.exe set "no_file=1"
if not exist %lib%truepng.exe set "no_file=1"
if not exist %lib%filter.js set "no_file=1"
:file_list_error
if defined no_file (
cls
title %name% - %version%
if exist "%temporary_path%" 1>nul 2>&1 rd /s /q "%temporary_path%"
1>&2 echo.
1>&2 echo.
1>&2 echo. %name% can not find lib folder or files.
1>&2 echo.
1>&2 echo.
1>nul 2>&1 pause
exit /b
)
:temporary_settings
set "random_number=%random%"
1>nul 2>&1 md "%temporary_path%%random_number%"
:script_counters
for %%a in (PNG) do (
set "image_number%%a=0"
set "total_number%%a=0"
set "total_number_error%%a=0"
set "total_size%%a=0"
set "image_size%%a=0"
set "change_size%%a=0"
set "change_purcent%%a=0"
)
:script_parameters
set "png="
set "start_time="
set "finish_time="
set "log_file=%temporary_path%\files"
set "png_counters=%temporary_path%\png_number"
set "jpg_counters=%temporary_path%\countjpg"
set "gif_counters=%temporary_path%\countgif"
set "file_list=%temporary_path%\file_list"
set "file_list_error=%temporary_path%\file_error"
set "thread="
:set_thread
call:set_number_thread %thread%
call:scan_files %*
:first_echo
cls
title %name% - %version%
cscript //nologo //e:jscript "%path_scripts%filter.js" /jpg:1 /png:1 /gif:1 %* 1>"%file_list%" 2>"%file_list_error%"
:set_counters
if exist "%file_list%" (
if "%png%" neq "0" for /f "tokens=*" %%a in ('findstr /i /e ".png"  "%file_list%" ^| find /i /c ".png" 2^>nul') do set /a "total_numberPNG+=%%a"
if "%jpg%" neq "0" for /f "tokens=*" %%a in ('findstr /i /e ".jpg"  "%file_list%" ^| find /i /c ".jpg" 2^>nul') do set /a "total_numberJPG+=%%a"
if "%gif%" neq "0" for /f "tokens=*" %%a in ('findstr /i /e ".gif"  "%file_list%" ^| find /i /c ".gif" 2^>nul') do set /a "total_numberGIF+=%%a"
)
if %total_numberPNG% gtr 0 (if not defined png call:png) else set "png=0"
if %total_numberJPG% gtr 0 (if not defined jpg call:jpg) else set "jpg=0"
if %total_numberGIF% gtr 0 (if not defined gif call:gif) else set "gif=0"
if exist "%file_list_error%" (
if defined png  for /f "tokens=3 delims=:" %%a in ('findstr /i /e ".png"  "%file_list_error%" ^| find /i /c ".png" 2^>nul') do set /a "total_number_errorPNG+=%%a"
if defined jpg for /f "tokens=3 delims=:" %%a in ('findstr /i /e ".jpg"  "%file_list_error%" ^| find /i /c ".jpg" 2^>nul') do set /a "total_number_errorJPG+=%%a"
if defined gif  for /f "tokens=3 delims=:" %%a in ('findstr /i /e ".gif"  "%file_list_error%" ^| find /i /c ".gif" 2^>nul') do set /a "total_number_errorGIF+=%%a"
)
:no_images_found
if %total_numberPNG% equ 0 if %total_numberJPG% equ 0 if %total_numberGIF% equ 0 (
cls
1>&2 echo.
1>&2 echo.
1>&2 echo. %name% can not find images.
1>&2 echo.
1>&2 echo.
call:script_pause
exit /b
)
for /l %%a in (1,1,%thread%) do (
>"%log_file%png.%%a" echo.
>"%log_file%jpg.%%a" echo.
>"%log_file%gif.%%a" echo.
)
:first_echo
cls
1>&2 echo.
1>&2 echo.
1>&2 echo. %name% - %version%
1>&2 echo.
1>&2 echo.
:set_title-time
call:set_title
call:set_time start_time
for /f "usebackq tokens=1,2 delims=	" %%a in ("%file_list%") do (
call:initialise_source "%%~a"
if defined ispng if "%png%" neq "0" call:file_work "%%~fa" "%%~fb" png %thread% image_numberPNG
if defined isjpg if "%jpg%" neq "0" call:file_work "%%~fa" "%%~fb" jpg %thread% image_numberJPG
if defined isgif if "%gif%" neq "0" call:file_work "%%~fa" "%%~fb" gif %thread% image_numberGIF
)
:wait_thread
call:wait_flag "%temporary_path%\thread*.lck"
for /l %%z in (1,1,%thread%) do (
call:type_log png %%z
call:type_log jpg %%z
call:type_log gif %%z
)
call:set_title
call:set_operation
call:script_pause & exit /b
:scan_files
if "%~1" equ "" exit /b
set "tt=%~1"
if "!tt:~,1!" equ "/" (
if /i "!tt:~1,4!" equ "JPG:" (
set "jpg=!tt:~5!"
if "!jpg!" neq "0" if "!jpg!" neq "1" if "!jpg!" neq "2" if "!jpg!" neq "3" (
set "jpg=0"
)
if not defined png set "png=0"
if not defined gif set "gif=0"
) else if /i "!tt:~1,4!" equ "PNG:" (
set "png=!tt:~5!"
if "!png!" neq "0" if "!png!" neq "1" if "!png!" neq "2" (
set "png=0"
)
if not defined jpg set "jpg=0"
if not defined gif set "gif=0"
) else if /i "!tt:~1,4!" equ "GIF:" (
set "gif=!tt:~5!"
if "!gif!" neq "0" if "!gif!" neq "1" (
set "gif=0"
)
if not defined png set "png=0"
if not defined jpg set "jpg=0"
) else if /i "!tt:~1,7!" equ "Outdir:" (
set "outdir=!tt:~8!"
)
)
shift
goto:scan_files
:check_if_running
call:already_run "%~1"
if defined already_run (
exit
)
exit /b
:already_run
set "already_run="
for /f "tokens=* delims=" %%a in ('tasklist /fo csv /v /nh ^| find /i /c "%~1" ') do (
if %%a gtr 1 set "already_run=%%a"
)
exit /b
:set_time
set "%1=%time:~0,2%:%time:~3,2%:%time:~6,2%"
exit /b
:create_thread
if %2 equ 1 call:thread_work %1 1 %3 %4 & call:type_log %1 1 & exit /b
for /l %%z in (1,1,%2) do (
if not exist "%temporary_path%\thread%%z.lck" (
call:type_log %1 %%z
>"%temporary_path%\thread%%z.lck" echo. Processing: %3
start /b /low /min cmd.exe /s /c ""%script_name%" thread "%~3" "%~4" %1 %%z"
exit /b
)
)
call:wait_random 500
goto:create_thread
:type_log
if %thread% equ 1 exit /b
if not defined type_number%1%2 set "type_number%1%2=1"
call:type_log_file "%log_file%%1.%2" "type_number%1%2" %%type_number%1%2%% %1
exit /b
:type_log_file
if not exist "%~1" exit /b
for /f "usebackq skip=%3 tokens=1-5 delims=;" %%b in ("%~1") do (
if /i "%%d" equ "error" (
call:echo_file_error "%%~b" "%%~c"
) else (
call:echo_file_info "%%~b" %%c %%d %%e %%f
)
set /a "%~2+=1"
)
exit /b
:echo_file_info
call:echo_script " %~nx1"
if "%~4" neq "0" (
set "float=%2"
call:division float 1024 100
call:echo_script " In  : !float! KB"
set "change_size=%4"
call:division change_size 1024 100
set "float=%3"
call:division float 1024 100
call:echo_script " Out : !float! KB (%5%%%%%%)"
) else (
set "float=%2"
call:division float 1024 100
call:echo_script " In  : !float! KB"
set "change_size=%4"
call:division change_size 1024 100
set "float=%3"
call:division float 1024 100
call:echo_script " Out : !float! KB (%5%%%%%%) - Skipped"
)
call:echo_script %separe_bar%
call:echo_script
exit /b

:echo_file_error
call:echo_error " In    : %~nx1"
call:echo_error " Error : %~2"
call:echo_error " %separe_bar%"
call:echo_error 
exit /b
:echo_script
echo.%~1
exit /b
:echo_error
1>&2 echo.%~1
exit /b
:thread_work
1>nul 2>&1 md "%~dp4"
if /i "%1" equ "png" call:pngfile_work %2 %3 %4 & if %thread% gtr 1 >>"%png_counters%.%2" echo.1
if /i "%1" equ "jpg" call:jpgfile_work %2 %3 %4 & if %thread% gtr 1 >>"%jpg_counters%.%2" echo.1
if /i "%1" equ "gif" call:giffile_work %2 %3 %4 & if %thread% gtr 1 >>"%gif_counters%.%2" echo.1
if exist "%temporary_path%\thread%2.lck" >nul 2>&1 del /f /q "%temporary_path%\thread%2.lck"
exit /b
:wait_flag
if not exist "%~1" exit /b
call:wait_random 2000
goto:wait_flag
:wait_random
set /a "ww=%random%%%%1"
1>nul 2>&1 ping -n 1 -w %ww% 127.255.255.255
exit /b
:initialise_source
set "isjpg="
set "ispng="
set "isgif="
if /i "%~x1" equ ".png" set "ispng=1"
if /i "%~x1" equ ".jpg" set "isjpg=1"
if /i "%~x1" equ ".gif" set "isgif=1"
exit /b
:set_number_thread
set "thread=4"
exit /b
:png
if %autorun_option_png% neq 1 if %autorun_option_png% neq 2 if %autorun_option_png% neq 8 if %autorun_option_png% neq 9 set "autorun_option_png=1"
if %autorun_png% equ 1 set "png=%autorun_option_png%" & exit /b
cls
set "png="
title %name% - %version%
1>&2 echo.
1>&2 echo.
1>&2 echo.
1>&2 echo. 
1>&2 echo.   PNG Lossless for Web :
1>&2 echo.   --------------------
1>&2 echo.
1>&2 echo.   [1] Fast
1>&2 echo.
1>&2 echo.
1>&2 echo.   PNG Lossy conversion :
1>&2 echo.   --------------------
1>&2 echo.
1>&2 echo.   [8] PNG8+A   [9] PNG24+A
1>&2 echo.
1>&2 echo.
1>&2 echo.
1>&2 echo.
set /p png="--> Choose an option : "
1>&2 echo.
if "%png%" neq "1" if "%png%" neq "2" if "%png%" neq "8"  if "%png%" neq "9" goto:png
exit /b
:jpg
if %autorun_option_jpg% neq 1 if %autorun_option_jpg% neq 2 if %autorun_option_jpg% neq 3 if %autorun_option_jpg% neq 4 if %autorun_option_jpg% neq 5 if %autorun_option_jpg% neq 6 if %autorun_option_jpg% neq 7 if %autorun_option_jpg% neq 8 if %autorun_option_jpg% neq 9 set "autorun_option_jpg=1"
if %autorun_jpg% equ 1 set "jpg=%autorun_option_jpg%" & exit /b
cls
set "jpg="
title %name% - %version%
1>&2 echo.
1>&2 echo.
1>&2 echo.
1>&2 echo. 
1>&2 echo.   JPG Lossless for Web :
1>&2 echo.   --------------------
1>&2 echo.
1>&2 echo.   [1] Lossless
1>&2 echo.
1>&2 echo.
1>&2 echo.   JPG Lossy conversion :
1>&2 echo.   --------------------
1>&2 echo.
1>&2 echo.   [2] 95%%      [3] 90%%      [4] 85%%      [5] 80%%
1>&2 echo.
1>&2 echo.   [6] 75%%      [7] 70%%      [8] 65%%      [9] 60%%
1>&2 echo.
1>&2 echo.
1>&2 echo.
set /p jpg="--> Choose an option : "
1>&2 echo.
if "%jpg%" neq "1" if "%jpg%" neq "2" if "%jpg%" neq "3"  if "%jpg%" neq "4" if "%jpg%" neq "5" if "%jpg%" neq "6" if "%jpg%" neq "7" if "%jpg%" neq "8" if "%jpg%" neq "9" goto:jpg
exit /b
:gif
if %autorun_option_gif% neq 1 if %autorun_option_gif% neq 2 if %autorun_option_gif% neq 3 if %autorun_option_gif% neq 4 if %autorun_option_gif% neq 5 if %autorun_option_gif% neq 6 if %autorun_option_gif% neq 7 if %autorun_option_gif% neq 8 if %autorun_option_gif% neq 9 set "autorun_option_gif=1"
if %autorun_gif% equ 1 set "gif=%autorun_option_gif%" & exit /b
cls
set "gif="
title %name% - %version%
1>&2 echo.
1>&2 echo.
1>&2 echo.
1>&2 echo. 
1>&2 echo.   GIF Lossless for Web :
1>&2 echo.   --------------------
1>&2 echo.
1>&2 echo.   [1] Lossless
1>&2 echo.
1>&2 echo.
1>&2 echo.   GIF Lossy (number of colors) :
1>&2 echo.   ----------------------------
1>&2 echo.
1>&2 echo.   [2] 224      [3] 192      [4] 128      [5] 96
1>&2 echo.
1>&2 echo.   [6] 64       [7] 32       [8] 16       [9] 8
1>&2 echo.
1>&2 echo.
1>&2 echo.
set /p gif="--> Choose an option : "
1>&2 echo.
if "%gif%" neq "1" if "%gif%" neq "2" if "%gif%" neq "3"  if "%gif%" neq "4" if "%gif%" neq "5" if "%gif%" neq "6" if "%gif%" neq "7" if "%gif%" neq "8" if "%gif%" neq "9" goto:gif
exit /b
:set_title
if "%jpg%" equ "0" if "%png%" equ "0" if "%gif%" equ "0" (title %~1%name% - %version% & exit /b)
if %thread% gtr 1 (
set "image_numberPNG=0" & set "image_numberJPG=0" & set "image_numberGIF=0"
for /l %%c in (1,1,%thread%) do  (
for %%b in ("%png_counters%.%%c") do set /a "image_numberPNG+=%%~zb/3" 2>nul
for %%b in ("%jpg_counters%.%%c") do set /a "image_numberJPG+=%%~zb/3" 2>nul
for %%b in ("%gif_counters%.%%c") do set /a "image_numberGIF+=%%~zb/3" 2>nul
)
)
set "title_progression="
set "image_numberALL=0"
set "total_numberALL=0"
set /a "image_numberALL=(%image_numberPNG%+%image_numberJPG%+%image_numberGIF%)" 2>nul
set /a "total_numberALL=(%total_numberPNG%+%total_numberJPG%+%total_numberGIF%)" 2>nul
set /a "change_purcent=%image_numberALL%*100/%total_numberALL%"
set "title_progression=!title_progression! !change_purcent!%%"
title %title_progression% - %name% - %version%
exit /b
:file_work
call:create_thread %3 %4 "%~f1" "%~f2"
set /a "%5+=1"
call:set_title
exit /b
:pngfile_work
set "pngoptimized_size=%~z2"
set "error_backup=0"
set "log_file2=%log_file%png.%1"
set "png_log=%temporary_path%\png%1.log"
set "file_work=%temporary_path%%~n2-script%1%~x2"
set "temp_file=%temporary_path%%random%%~nx2"
if not exist "%~2" (
call:save_error_log "%~f2" "can not read image"
exit /b 1
)
if %png% equ 1 (
1>nul 2>&1 truepng -f0,5 -i0 -g0 -md remove all -zs0,1 -quiet -force -y -out "%file_work%" "%~2"
)
if %png% equ 8 (
1>nul 2>&1 pngquant --speed 1 256 "%~2" -f -o "%temp_file%"
call :check_compare "%~2" "%temp_file%"
truepng -nz -md remove all -force -quiet -y -out "%file_work%" "%~2"
)
if %png% equ 9 (
1>nul 2>nul truepng -f3 -i0 -g0 -nc -md remove all -zc7 -l -quiet -force -y -out "%file_work%" "%~2"
)
if errorlevel 1 (call:save_error_log "%~f2" "can not read image" & goto:png_clean)
call:backup2 "%~f2" "%file_work%" "%~f3" || set "error_backup=1"
if %error_backup% neq 0 (call:save_error_log "%~f2" "can not read image" & goto:png_clean)
call:save_log "%~f3" %pngoptimized_size%
if %thread% equ 1 for %%a in ("%~f3") do (set /a "image_sizePNG+=%%~za" & set /a "total_sizePNG+=%pngoptimized_size%")
:png_clean
1>nul 2>&1 del /f /q "%file_work%" "%png_log%"
exit /b
:jpgfile_work
set "jpg_quality="
set "jpgoptimized_size=%~z2"
set "error_backup=0"
set "log_file2=%log_file%jpg.%1"
set "jpg_log=%temporary_path%\jpg%1.log"
set "file_work=%temporary_path%%~n2-script%1%~x2"
if not exist "%~2" (
call:save_error_log "%~f2" "Image not found"
exit /b 1
)
if %jpg% equ 1 (
1>nul 2>&1 jpegtran -fastcrush -copy none -outfile "%file_work%" "%~2"
)
if %jpg% neq 1 (
if %jpg% equ 2 set "jpg_quality=95"
if %jpg% equ 3 set "jpg_quality=90"
if %jpg% equ 4 set "jpg_quality=85"
if %jpg% equ 5 set "jpg_quality=80"
if %jpg% equ 6 set "jpg_quality=75"
if %jpg% equ 7 set "jpg_quality=70"
if %jpg% equ 8 set "jpg_quality=65"
if %jpg% equ 9 set "jpg_quality=60"
1>nul 2>&1 jpegoptim -f -s --max=!jpg_quality! -q -o "%~2"
1>nul 2>&1 jpegtran -fastcrush -copy none -outfile "%file_work%" "%~2"
)
if errorlevel 1 (call:save_error_log "%~f2" "can not read image" & goto:jpg_clean)
call:backup2 "%~f2" "%file_work%" "%~f3" || set "error_backup=1"
if %error_backup% neq 0 (call:save_error_log "%~f2" "can not read image" & goto:jpg_clean)
call:save_log "%~f3" %jpgoptimized_size%
if %thread% equ 1 for %%a in ("%~f3") do (set /a "image_sizeJPG+=%%~za" & set /a "total_sizeJPG+=%jpgoptimized_size%")
:jpg_clean
1>nul 2>&1 del /f /q "%file_work%" "%jpg_log%"
exit /b
:giffile_work
set "gif_colors="
set "gifoptimized_size=%~z2"
set "error_backup=0"
set "log_file2=%log_file%gif.%1"
set "gif_log=%temporary_path%\gif%1.log"
set "file_work=%temporary_path%%~n2-script%1%~x2"
if not exist "%~2" (
call:save_error_log "%~f2" "Image not found"
exit /b 1
)
if %gif% equ 1 (
gifsicle --batch --crop-transparency --no-comments --no-extensions --no-names --optimize=2 --output "%file_work%" "%~2" 1>nul 2>&1
)
if %gif% neq 1 (
if %gif% equ 2 set "gif_colors=224"
if %gif% equ 3 set "gif_colors=192"
if %gif% equ 4 set "gif_colors=160"
if %gif% equ 5 set "gif_colors=96"
if %gif% equ 6 set "gif_colors=64"
if %gif% equ 7 set "gif_colors=32"
if %gif% equ 8 set "gif_colors=16"
if %gif% equ 9 set "gif_colors=8"
gifsicle --batch --crop-transparency --no-comments --no-extensions --no-names --optimize=2 --colors=!gif_colors! --output "%file_work%" "%~2" 1>nul 2>&1
)
if errorlevel 1 (call:save_error_log "%~f2" "can not read image" & goto:gif_clean)
call:backup2 "%~f2" "%file_work%" "%~f3" || set "error_backup=1"
if %error_backup% neq 0 (call:save_error_log "%~f2" "can not read image" & goto:gif_clean)
call:save_log "%~f3" %gifoptimized_size%
if %thread% equ 1 for %%a in ("%~f3") do (set /a "image_sizeGIF+=%%~za" & set /a "total_sizeGIF+=%gifoptimized_size%")
:gif_clean
1>nul 2>&1 del /f /q "%file_work%" "%gif_log%"
exit /b
:check_compare
if %~z2 leq %~z1 (
1>nul 2>&1 del /f /q %1
1>nul 2>&1 move /y %2 %1
)
exit /b
:backup
if not exist "%~1" exit /b 2
if not exist "%~2" exit /b 3
if %~z2 equ 0 (if "%3" neq "" (1>nul 2>&1 del /f /q "%~2") & exit /b 4)
if %~z1 leq %~z2 (
if "%3" neq "" (1>nul 2>&1 del /f /q "%~2")
) else (
1>nul 2>&1 copy /b /y "%~2" "%~1" || exit /b 1
if "%3" neq "" 1>nul 2>&1 del /f /q "%~2"
)
exit /b
:backup2
if not exist "%~1" exit /b 2
if not exist "%~2" exit /b 3
set "cone="
if %~z2 equ 0 set "cone=yes"
if %~z1 leq %~z2 set "cone=yes"
if defined cone (
if "%~1" neq "%~3" (1>nul 2>&1 copy /b /y "%~1" "%~3" || exit /b 1)
) else (
1>nul 2>&1 copy /b /y "%~2" "%~3" || exit /b 1
)
exit /b 0
:save_log
set /a "change_size=%~z1-%2"
set /a "change_purcent=%change_size%*100/%2" 2>nul
set /a "fraction=%change_size%*100%%%2*100/%2" 2>nul
set /a "change_purcent=%change_purcent%*100+%fraction%"
call:division change_purcent 100 100
>>"%log_file2%" echo.%~1;%2;%~z1;%change_size%;%change_purcent%;ok
if %thread% equ 1 (
call:echo_file_info "%~1" %2 %~z1 %change_size% %change_purcent%
)
exit /b
:division
set "sign="
1>nul 2>&1 set /a "int=!%1!/%2"
1>nul 2>&1 set /a "fractiond=!%1!*%3/%2%%%3"
if "%fractiond:~,1%" equ "-" (set "sign=-" & set "fractiond=%fractiond:~1%")
1>nul 2>&1 set /a "fractiond=%3+%fractiond%"
if "%int:~,1%" equ "-" set "sign="
set "%1=%sign%%int%.%fractiond:~1%"
exit /b
:save_error_log
if exist "%file_work%" 1>nul 2>&1 del /f /q "%file_work%"
>>"%log_file2%" echo.%~1;%~2;error
if %thread% equ 1 (call:echo_file_error "%~f1" "%~2")
exit /b
:set_operation
call:set_time finish_time
set "fraction=0"
set "change_sizePNG=0" & set "change_purcentPNG=0"
set "change_sizeJPG=0" & set "change_purcentJPG=0"
set "change_sizeGIF=0" & set "change_purcentGIF=0"
set "total_numberNOptJPG=0" & set "total_numberNOptPNG=0" & set "total_numberNOptGIF=0"
if %jpg% equ 0 if %png% equ 0 if %gif% equ 0 1>nul 2>&1 ping -n 1 -w 500 127.255.255.255 & goto:end_processing
if %thread% gtr 1 (
for /f "tokens=1-5 delims=;" %%a in ('findstr /e /i /r /c:";ok" "%log_file%png*" ') do (
set /a "total_sizePNG+=%%b" & set /a "image_sizePNG+=%%c"
)
for /f "tokens=1-5 delims=;" %%a in ('findstr /e /i /r /c:";ok" "%log_file%jpg*" ') do (
set /a "total_sizeJPG+=%%b" & set /a "image_sizeJPG+=%%c"
)
for /f "tokens=1-5 delims=;" %%a in ('findstr /e /i /r /c:";ok" "%log_file%gif*" ') do (
set /a "total_sizeGIF+=%%b" & set /a "image_sizeGIF+=%%c"
)
)
if not defined total_sizePNG set "total_sizePNG=0"
if not defined total_sizeJPG set "total_sizeJPG=0"
if not defined total_sizeGIF set "total_sizeGIF=0"
if not defined image_sizePNG set "image_sizePNG=0"
if not defined image_sizeJPG set "image_sizeJPG=0"
if not defined image_sizeGIF set "image_sizeGIF=0"
set "change_sizeTOTAL=0"
set "change_purcentTOTAL=0"
set /a "total_sizeINPUT=(%total_sizePNG%+%total_sizeJPG%+%total_sizeGIF%)" 2>nul
set /a "total_sizeOUTPUT=(%image_sizePNG%+%image_sizeJPG%+%image_sizeGIF%)" 2>nul
set /a "change_sizeTOTAL=(%total_sizeINPUT%-%total_sizeOUTPUT%)" 2>nul
set /a "change_purcentTOTAL=%change_sizeTOTAL%*100/%total_sizeINPUT%" 2>nul
set /a "fraction=%change_sizeTOTAL%*100%%%total_sizeINPUT%*100/%total_sizeINPUT%" 2>nul
set /a "change_purcentTOTAL=%change_purcentTOTAL%*100+%fraction%" 2>nul
call:division change_sizeTOTAL 1024 100
call:division change_purcentTOTAL 100 100
:end_processing
title Finished - %name% - %version%
if %auto_close% equ 1 exit
:show_results
if "%total_all%" neq "0" (
1>&2 echo.
call:echo_script " Total: %change_sizeTOTAL% KB (%%change_purcentTOTAL%%%%%%) saved."
1>&2 echo.
1>&2 echo.
call:echo_script " Started  at : %start_time%"
call:echo_script " Finished at : %finish_time%"
1>&2 echo.
1>&2 echo.
)
exit /b
:cleaning
1>&2 echo.
if exist "%temp%\%name%" 1>nul 2>&1 rd /s /q "%temp%\%name%"
exit /b
:how_to
title %name% - %version%
color 0f
1>&2 (
echo.
echo.
echo.
echo. HOW TO USE:
echo  ----------
echo.
echo  Drag-and-drop files/folders on %name%.cmd file
echo.
echo.
echo  ______________________________________________________________________________
echo.
echo.
echo.
echo. LIMITATIONS:
echo  -----------
echo.
echo  %name% does not support some characters.
echo.
echo  Use simple path/name like "C:\images\image.png"
echo. 
echo. 
echo. 
)
if exist "%temp%\%name%" 1>nul 2>&1 rd /s /q "%temp%\%name%"
call:script_pause
exit /b
:script_pause
set "x=%~f0"
echo.%cmdcmdline% | 1>nul 2>&1 findstr /ilc:"%x%" && 1>nul 2>&1 pause
set "x="
exit /b