@REM This script starts the Django server
@REM Run the command ".\start_server.bat" from the "CarePluse" folder

@echo off
cd /d %~dp0backend
call venv\Scripts\activate
cd careplus
python manage.py runserver %1