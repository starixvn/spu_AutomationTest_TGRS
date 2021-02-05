@echo OFF
del /f /q /s "%~dp0\Auto_Reports\*.*"
if not exist "%~dp0\Auto_Reports" mkdir "%~dp0\Auto_Reports"

:: Run Testsuite
set myfolder=%date:~-4%%date:~4,2%%date:~7,2%%time:~0,2%%time:~3,2%%time:~6,2%
call robot -V Config/config_pro.py --listener "%~dp0\Libs\SkypeLib.py" --outputdir "%~dp0\Auto_Reports" "%~dp0\Testsuite\TGRS_Smoke_Test.robot"