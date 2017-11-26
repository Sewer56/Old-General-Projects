:engine_26092015_simple
@echo off
setlocal enabledelayedexpansion
:user_settings
set "autorun=0"
set "autorun_option=0"
set "auto_close=0"
set "overwrite_files=1"
set "meta_keep=0"
:base_status
set "status=status_ready"
:script
set "name=pngslim"
set "version=23.03.2016"
title %name% - %version%
if /i "%~x1" equ "" call :script_info & exit /b
if /i "%~x1" neq ".png" call :script_info & exit /b
color 0f
:script_configuration
set "script_name=%~0"
set "path_source=%~dp0"
set "script_config=%path_source%lib\"
set "temp_path=%temp%\%name%\"
set "check_file=%path_source%\%name%"
call:set_separation
:script_clean
if exist "%temp_path%" 1>nul 2>&1 rd /s /q "%temp_path%"
:script_lib_path
set "lib=%~dp0lib\"
path %lib%;%path%
:script_check_files
set "no_file="
if not exist "%lib%" set "no_file=1"
if not exist "%lib%advdef.exe" set "no_file=1"
if not exist "%lib%cecho.exe" set "no_file=1"
if not exist "%lib%deflopt.exe" set "no_file=1"
if not exist "%lib%defluff.exe" set "no_file=1"
if not exist "%lib%huffmix.exe" set "no_file=1"
if not exist "%lib%pngout.exe" set "no_file=1"
if not exist "%lib%pngwolf.exe" set "no_file=1"
if not exist "%lib%truepng.exe" set "no_file=1"
:file_list_error
if defined "no_file" (
cls
title %name% - %version%
if exist "%temp_path%" 1>nul 2>&1 rd /s /q "%temp_path%"
echo.
echo.
echo. %name% can not find lib path or files.
echo.
echo.
1>nul 2>&1 pause
exit /b
)
:temporary_settings
set "random_number=%random%"
1>nul 2>&1 md "%temp_path%%random_number%"
:script_run
set "png="
set "start_time="
set "finish_time="
set "log_file=%temp_path%\files"
set "file_name=%~n1.png"
set "size_in=%~z1"
title %file_name% : %size_in% Bytes
:check_autorun
if "%autorun%" neq "0" if "%autorun%" neq "1" set "autorun=0"
if "%autorun%" equ "1" set "png=%autorun_option%" & goto :png_working
if "%autorun_option%" neq "0" if "%autorun_option%" neq "1" if "%autorun_option%" neq "2" if "%autorun_option%" neq "3" if "%autorun_option%" neq "4" if "%autorun_option%" neq "5" if "%autorun_option%" neq "6" if "%autorun_option%" neq "7" if "%autorun_option%" neq "8" if "%autorun_option%" neq "9" if "%autorun_option%" neq "a" set "autorun_option=9"
:check_auto_close
if "%auto_close%" neq "0" if "%auto_close%" neq "1" set "auto_close=0"
:check_overwrite_files
if "%overwrite_files%" neq "0" if "%overwrite_files%" neq "1" if "%overwrite_files%" neq "2" set "overwrite_files=2"
if "%overwrite_files%" equ "0" set "overwrite_files_color=08" & set "meta_keep=1"
if "%overwrite_files%" equ "1" set "overwrite_files_color=0E"
if "%overwrite_files%" leq "1" 1>nul 2>&1 copy /b /y "%~f1" "%temp_path%%~n1.bak"
if "%overwrite_files%" equ "2" set "overwrite_files_color=0A"
:check_meta
if "%meta_keep%" neq "0" if "%meta_keep%" neq "1" set "meta_keep=0"
if "%meta_keep%" equ "0" set "meta_color=0A"
if "%meta_keep%" equ "1" set "meta_color=08"
:png_run
cls
set "png="
:check_status
echo.
if "%status%" equ "status_ready" cecho {0F}{\t}{\t}{\t}{\t}     [o] {%overwrite_files_color%}Overwrite{0F} - [m] {%meta_color%}Delete meta{0F} - {0A}Ready{0F}
if "%status%" equ "status_reset" cecho {0F}{\t}{\t}{\t}        [o] {%overwrite_files_color%}Overwrite{0F} - [m] {%meta_color%}Delete meta{0F} - {0A}Reset done{0F}
if "%status%" equ "status_reductions" cecho {0F}{\t}{\t}{\t}   [o] {%overwrite_files_color%}Overwrite{0F} - [m] {%meta_color%}Delete meta{0F} - {0A}Reductions done{0F}
if "%status%" equ "status_filtering" cecho {0F}{\t}{\t}{\t}    [o] {%overwrite_files_color%}Overwrite{0F} - [m] {%meta_color%}Delete meta{0F} - {0A}Filtering done{0F}
if "%status%" equ "status_palette" cecho {0F}{\t}{\t}{\t}      [o] {%overwrite_files_color%}Overwrite{0F} - [m] {%meta_color%}Delete meta{0F} - {0A}Palette done{0F}
if "%status%" equ "status_nocompression" cecho {0F}{\t}{\t}{\t}   [o] {%overwrite_files_color%}Overwrite{0F} - [m] {%meta_color%}Delete meta{0F} - {0A}Uncompress done{0F}
if "%status%" equ "status_7zdeflate" cecho {0F}{\t}{\t}{\t} [o] {%overwrite_files_color%}Overwrite{0F} - [m] {%meta_color%}Delete meta{0F} - {0A}7z's deflate done{0F}
if "%status%" equ "status_zopfli" cecho {0F}{\t}{\t}{\t}       [o] {%overwrite_files_color%}Overwrite{0F} - [m] {%meta_color%}Delete meta{0F} - {0A}Zopfli done{0F}
if "%status%" equ "status_allcompressors" cecho {0F}{\t}{\t}      [o] {%overwrite_files_color%}Overwrite{0F} - [m] {%meta_color%}Delete meta{0F} - {0A}All compressors done{0F}
if "%status%" equ "status_kstrials" cecho {0F}{\t}{\t}{\t}    [o] {%overwrite_files_color%}Overwrite{0F} - [m] {%meta_color%}Delete meta{0F} - {0A}KS-Trials done{0F}
if "%status%" equ "status_combinations" cecho {0F}{\t}{\t}{\t} [o] {%overwrite_files_color%}Overwrite{0F} - [m] {%meta_color%}Delete meta{0F} - {0A}Combinations done{0F}
:echo_interface
echo.
echo. 
echo.   Reductions trials :
echo.   -----------------
echo.
echo.   [0] Reset        [1] Reductions      [2] Filtering     [3] Palette trials
echo.
echo.                                                     
echo.
echo.   Compression trials :
echo.   ------------------
echo.
echo.   [4] Uncompress   [5] 7z's deflate    [6] Zopfli        [7] All compressors
echo.
echo.
echo    [8] KS-Trials    [9] Auto-combine    [a] Analyse
echo.
echo.                                                    
echo.
echo.
set /p png="--> Choose an option : "
echo.
:check_png
if "%png%" neq "0" if "%png%" neq "1" if "%png%" neq "2" if "%png%" neq "3" if "%png%" neq "4" if "%png%" neq "5" if "%png%" neq "6" if "%png%" neq "7" if "%png%" neq "8"  if "%png%" neq "9" if "%png%" neq "a" if "%png%" neq "b" if "%png%" neq "m" if "%png%" neq "o" goto :png_run
:overwrite_files_display
if "%png%" equ "o" (
if "%overwrite_files%" equ "0" set "overwrite_files=1" & goto :script_run
if "%overwrite_files%" equ "1" set "overwrite_files=2" & goto :script_run
if "%overwrite_files%" equ "2" set "overwrite_files=0" & set "meta_keep=0" & goto:script_run
)
:meta_display
if "%png%" equ "m" (
if "%meta_keep%" equ "0" set "meta_keep=1" & goto :script_run
if "%meta_keep%" equ "1" set "meta_keep=0" & goto :script_run
)
:png_working
cls
echo.
cecho {0E}{\t}{\t}{\t}{\t}{\t}{\t}{\t}{\t}  Working...{0F}
set "start_time=%time%"
echo.
echo  %separation%
echo. %name% - %version%
echo  %separation%
echo.
echo  "%file_name%"
echo  In  : %size_in%
:png_options
if "%png%" equ "0" call :option_reset "%~f1" & set "status=status_reset"
if "%png%" equ "1" call :option_reductions "%~f1" & set "status=status_reductions"
if "%png%" equ "2" call :option_filtering "%~f1" & set "status=status_filtering"
if "%png%" equ "3" call :option_palette "%~f1" & set "status=status_palette"
if "%png%" equ "4" call :option_nocompression "%~f1" & set "status=status_nocompression"
if "%png%" equ "5" call :option_7zdeflate "%~f1" & set "status=status_7zdeflate"
if "%png%" equ "6" call :option_zopfli "%~f1" & set "status=status_zopfli"
if "%png%" equ "7" call :option_allcompressors "%~f1" & set "status=status_allcompressors"
if "%png%" equ "8" call :option_kstrials "%~f1" & set "status=status_kstrials"
if "%png%" equ "9" call :option_combinations "%~f1" & set "status=status_combinations"
if "%png%" equ "a" call :option_analyse "%~f1" & set "status=status_ready"
call :stream_optimization "%~f1"
goto:finish_data
:option_reset
1>nul 2>&1 truepng -f0 -zc1 -zm1 -zs3 -quiet -force -y "%~f1"
1>nul 2>&1 pngout -c6 -f0 -s4 -k%meta_keep% -q -y -force "%~f1"
exit /b
:option_reductions
set "zlib_memlevel="
set "zlib_strategy="
pngout -c6 -f0 -s4 -k%meta_keep% -q -y -force "%~f1"
>"%temp_path%png.log" 2>nul truepng -f0,5 -zc7 -zm4-9 -zs0,1 -force -y "%~f1"
for /f "tokens=2,4,6,8,10 delims=:	" %%a in ('findstr /r /i /b /c:"zc:..zm:..zs:" "%temp_path%png.log"') do (set "zlib_memlevel=%%b" &set "zlib_strategy=%%c")
call :check_colortype "%~f1"
if "%colortype%" geq "4" 1>nul 2>&1 cryopng -quiet -f1 -zc7 -zs1 -force -nx "%~f1" -out "%temp_path%%~n1-trans.png"
if "%colortype%" geq "4" if exist "%temp_path%%~n1-trans.png" for %%i in (2,4) do 1>nul 2>&1 cryopng -quiet -f%%i -zc7 -zs1 -nx "%temp_path%%~n1-trans.png"
if "%colortype%" geq "4" if exist "%temp_path%%~n1-trans.png" 1>nul 2>&1 truepng -f1,2,4,5 -fs:7 -na -zc7 -zs1 -quiet -force -y "%temp_path%%~n1-trans.png"
if "%colortype%" geq "4" call :check_compare "%~f1" "%temp_path%%~n1-trans.png"
if "%colortype%" equ "3" call :option_palette "%~f1"
exit /b
:option_filtering
pngwolf --in="%~f1" --out="%~f1" --max-stagnate-time=0 --max-evaluations=1 --zlib-level=7 --zlib-strategy=1 --even-if-bigger 1>nul 2>&1
exit /b
:option_palette
call :check_colortype "%~f1"
if "%colortype%" neq "3" exit /b
set "ks-flate_level=2"
if "%png%" equ "9" set "ks-flate_level=1"
if "%png%" equ "3" 1>nul 2>&1 truepng -f0,5 -zc7 -zs0 -quiet -force -y "%~f1"
call :option_nocompression "%~f1"
1>nul 2>&1 pngout -c6 -s4 -k%meta_keep% -q -y -force "%~f1" "%temp_path%%~n1-p0.png"
1>nul 2>&1 pngout -c3 -s%ks-flate_level% -k%meta_keep% -q -y "%temp_path%%~n1-p0.png"
1>nul 2>&1 advdef -z -3 -q -f "%temp_path%%~n1-p0.png"
1>nul 2>&1 pngout -f6 -s%ks-flate_level% -k%meta_keep% -ks -q -y -force "%~f1" "%temp_path%%~n1-p1.png"
1>nul 2>&1 advdef -z -3 -q -f "%temp_path%%~n1-p1.png"
1>nul 2>&1 pngout -f6 -s%ks-flate_level% -k%meta_keep% -ks -kp -q -y -force "%~f1" "%temp_path%%~n1-p2.png"
1>nul 2>&1 advdef -z -3 -q -f "%temp_path%%~n1-p2.png"
for %%i in (0,1,2) do call :check_compare "%~f1" "%temp_path%%~n1-p%%i.png"
exit /b
:option_nocompression
1>nul 2>&1 advdef -z -0 -q -f "%~f1"
exit /b
:option_7zdeflate
1>nul 2>&1 advdef -z -3 -q -f "%~f1"
exit /b
:option_zopfli
1>nul 2>&1 advdef -z -4 -q -f "%~f1"
exit /b
:option_allcompressors
set "number_iterations=10"
1>nul 2>&1 advdef -z -0 -q -f "%~f1"
1>nul 2>&1 advdef -z -2 -q -f "%~f1"
echo.
echo  - zlib deflate: %~z1
1>nul 2>&1 advdef -z -0 -q -f "%~f1"
1>nul 2>&1 advdef -z -3 -q -f "%~f1"
echo  - 7z's deflate: %~z1
:option_allcompressors_loop
1>nul 2>&1 advdef -z -0 -q -f "%~f1"
1>nul 2>&1 advdef -z -4 -i %number_iterations% -q -f "%~f1"
echo  -    zopfli %number_iterations%: %~z1
set /a "number_iterations+=5"
if %number_iterations% equ 30 exit /b
goto :option_allcompressors_loop
:option_kstrials
set "number_of_trials=0"
set "size_kstrials=0"
:option_kstrials_run
title [%number_of_trials%] %file_name% - Best trial: %size_kstrials%
for /L %%i in (1,1,4) do start /b /low /wait pngout -f6 -r -k0 -kp -ks -q -y -force "%~f1" "%temp_path%%~n1-%%i.png"
1>nul 2>&1 huffmix -q "%temp_path%%~n1-1.png" "%temp_path%%~n1-2.png" "%temp_path%%~n1-12.png"
1>nul 2>&1 huffmix -q "%temp_path%%~n1-3.png" "%temp_path%%~n1-4.png" "%temp_path%%~n1-34.png"
1>nul 2>&1 huffmix -q "%temp_path%%~n1-12.png" "%temp_path%%~n1-34.png" "%temp_path%%~n1-f.png"
call :kstrials_check "%~f1" "%temp_path%%~n1-f.png" >nul
set /a "number_of_trials+=4"
if %size_kstrials% lss %size_in% goto :option_kstrials_end
goto :option_kstrials_run
:option_kstrials_end
call :check_compare "%~f1" "%temp_path%%~n1-f.png" >nul
exit /b
:kstrials_check
set "size_kstrials=%~z2"
exit /b
:option_combinations
call :option_reductions "%~f1"
if "%colortype%" equ "3" call :option_nocompression "%~f1"
if "%colortype%" equ "3" call :option_palette "%~f1"
call :option_filterzopfli "%~f1"
exit /b
:option_filterzopfli
pngwolfz --in="%~f1" --out="%~f1" --max-stagnate-time=0 --max-evaluations=1 --zlib-level=7 --zlib-memlevel=!zlib_memlevel! --zlib-strategy=!zlib_strategy! --zopfli-iter=10 1>nul 2>&1
exit /b
:option_analyse
1>"%temp_path%%~n1-analyse.dat"  2>nul truepng -info "%~f1"
type "%temp_path%%~n1-analyse.dat" | find /v "TruePNG" | find /v "x128">"%temp_path%%~n1-display.dat"
cls
echo.
cecho {0A}{\t}{\t}{\t}{\t}{\t}{\t}{\t}{\t}    Finished{0F}
echo.
echo  %separation%
echo. %name% - %version%
echo  %separation%
echo.
type  "%temp_path%%~n1-display.dat"
echo.
echo %separation%
echo.
echo  --^> Press a key to restart
echo.
1>nul 2>&1 pause
goto :script_run
exit /b
:stream_optimization
if "%meta_keep%" equ "0" truepng -nz -md remove all -quiet -force -y "%~f1"
deflopt -k -b -s "%~f1" >nul
1>nul 2>nul defluff < "%~f1" > "%~f1.tmp"
call :check_move "%~f1" "%~f1.tmp"
deflopt -k -b -s "%~f1" >nul
exit /b
:check_colortype
for /f "tokens=1 delims=/c " %%i in ('pngout -l "%~f1"') do set "colortype=%%i"
exit /b
:check_filtering
for /f "tokens=2 delims=/f " %%i in ('pngout -l "%~f1"') do set "filtering=%%i"
exit /b
:check_compare
if %~z1 leq %~z2 (1>nul 2>&1 del /f /q %2) else (1>nul 2>&1 move /y %2 %1 || exit /b 1)
exit /b
:check_move
1>nul 2>&1 move /y %2 %1
exit /b
:finish_data
set "size_out=%~z1"
:finish_interface
cls
echo.
cecho {0A}{\t}{\t}{\t}{\t}{\t}{\t}{\t}{\t}    Finished{0F}
set "finish_time=%time%"
echo.
echo  %separation%
echo. %name% - %version%
echo  %separation%
echo.
echo  "%file_name%"
echo  In  : %size_in%
if "%overwrite_files%" equ "0" echo  Out : %size_out% - skipped
if "%overwrite_files%" equ "1" (
if %size_in% leq %size_out% (
call :check_move "%~f1" "%temp_path%%~n1.bak"
echo  Out : %size_out% - skipped
)
if %size_out% lss %size_in% (
call :check_compare "%~f1" "%temp_path%%~n1.bak"
echo  Out : %size_out%
)
)
if "%overwrite_files%" equ "2" echo  Out : %size_out%
echo.
echo  %separation%
echo  Started at  : %start_time%
echo  Finished at : %finish_time%
echo  %separation%
echo.
if "%auto_close%" equ "0" echo  --^> Press a key to restart
echo.
:restore_file
if "%overwrite_files%" equ "0" call :check_move "%~f1" "%temp_path%%~n1.bak"
if "%overwrite_files%" equ "1" call :check_compare "%~f1" "%temp_path%%~n1.bak"
:clean_temporary_files
if exist "%temp%\%name%" 1>nul 2>&1 rd /s /q "%temp%\%name%"
if "%auto_close%" equ "1" exit
1>nul 2>&1 pause
set "autorun=0"
goto:script
:set_separation
set "separation=---------------------------------------------------------------------------"
exit /b
:script_info
color 0f
echo.
echo.
echo.
echo. HOW TO USE:
echo  ----------
echo.
echo  Drag-and-drop file per file on %name%.cmd file
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
if exist "%temp%\%name%" 1>nul 2>&1 rd /s /q "%temp%\%name%"
1>nul 2>&1 pause
exit