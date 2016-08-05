@ECHO OFF
REM [customize those variables]
SET editor=F:\dev\text_editors\notepp\notepad++.exe
SET editorargs=-x835 -y39
SET projectspath=f:\dev\projects\pascal
SET compilerpath=F:\dev\compilers\fpc\2.6.4\bin\i386-win32
SET compiler=fpc
REM ###########################

SETLOCAL
SET new=/new
SET del=/del
SET list=/lst
SET help=/?

IF [%1]==[%new%] GOTO CreateProject
IF [%1]==[%del%] GOTO DeleteProject
IF [%1]==[%list%] GOTO ListProjects
IF [%1]==[%help%] GOTO Usage
IF [%1]==[] GOTO Usage
GOTO LoadProject

:CreateProject
IF [%2]==[] GOTO NameNotSpecified
IF EXIST "%projectspath%\%2" ECHO: ERROR: Project "%2" already exists! && GOTO:EOF

ENDLOCAL
SET prjname=%2

ECHO: Creating project "%prjname%"...

MKDIR "%projectspath%\%prjname%"
MKDIR "%projectspath%\%prjname%\bin"
MKDIR "%projectspath%\%prjname%\code"
MKDIR "%projectspath%\%prjname%\data"
MKDIR "%projectspath%\%prjname%\tools"

REM COPY "%~dp0files\*" "%projectspath%\%prjname%\code"
COPY "%~dp0tools\*" "%projectspath%\%prjname%\tools"

TYPE "%~dp0files\main.pas" >> "%projectspath%\%prjname%\code\%prjname%.pas"

SET path=%projectspath%\%prjname%\tools;%compilerpath%;%path%

START "" "%editor%" "%editorargs%" "%projectspath%\%prjname%\code\*.pas"
CD /D "%projectspath%\%prjname%\data"

ECHO: Done!
GOTO:EOF

:LoadProject
IF NOT EXIST "%projectspath%\%1" ECHO: ERROR: Project "%1" was NOT found! && GOTO:EOF

ENDLOCAL
SET prjname=%1
SET path=%projectspath%\%prjname%\tools;%compilerpath%;%path%

ECHO: Loading project "%prjname%"...
START "" "%editor%" "%editorargs%" "%projectspath%\%prjname%\code\*.pas"

CD /D "%projectspath%\%prjname%\data"

ECHO: Done!
GOTO:EOF

:DeleteProject
IF [%2]==[] GOTO NameNotSpecified
IF NOT EXIST "%projectspath%\%2" ECHO: ERROR: Project "%2" was NOT found! && GOTO:EOF

SET /P confirm=Project "%2" will be deleted. Correct? [y\n]: 
IF NOT [%confirm%]==[y] ECHO: Aborted. && GOTO:EOF

ECHO: Deleting project "%2"...
RMDIR /S /Q "%projectspath%\%2"

ECHO: Done!
GOTO:EOF

:ListProjects
ECHO:List of available projects:
ECHO.
DIR /B /L /ON /AD /P "%projectspath%"
GOTO:EOF

:Usage
ECHO: "%~n0" is a small bat file that aims to help manage Pascal projects.
ECHO.
ECHO: NOTE: If you are planning to use this tool, please make sure you
ECHO: have modified variables at the beginning of the batch files to
ECHO: suite your needs.
ECHO.
ECHO: USAGE:
ECHO: %~n0 [%new%] [%del%] [..] project_name
ECHO.
ECHO: %new% - create a project with "project_name"
ECHO: %del% - delete a project with "project_name"
ECHO: %list% - show a list of existing projects
ECHO: %help% - show this information
ECHO.
ECHO: If none of a keywords are specified project with "project_name" will be loaded
GOTO:EOF

:NameNotSpecified
ECHO: ERROR: Name for a project was NOT specified!
GOTO:EOF
