    @echo off
    COLOR 0A
    :start
    ::Server name
    set serverName=ServerName
    ::Server files location
    set serverLocation="C:\steam\steamapps\common\DayZServer"
    ::Server Profile Folder Location
    set serverProfiles=C:\steam\steamapps\common\DayZServer\profiles
    ::Server Port
    set serverPort=2302
    ::Logical CPU cores to use (Equal or less than available)
    set serverCPU=4
    ::Server config
    set serverConfig=serverDZ.cfg
    ::InstanceID Number
    set instanceIdNumber=1
    ::exe
    set dayzsaExe=DayZServer_x64.exe
    set dzsalExe=DZSALModServer.exe
    set becExe=Bec.exe
    ::Battleye Parameters::
    set beFolder=C:\steam\steamapps\common\DayZServer\battleye
    set becFolder=C:\steam\steamapps\common\DayZServer\Bec
    set becConfig=Config.cfg
    ::Mod Settings::
    set serverMod=
    set modList=(C:\Steam\steamapps\common\DayZServer\Modlist.txt)
    set steamWorkshop=C:\Steam\steamapps\common\DayZServer\SteamCMD\steamapps\workshop\content\221100
    set steamcmdLocation=C:\Steam\steamapps\common\DayZServer\SteamCMD
    set steamUser=SteamID
    set steamcmdDel=5
    setlocal EnableDelayedExpansion 

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

    echo Agusanz

    ::Sets title for terminal (DONT edit)
    title %serverName% batch
    ::DayZServer location (DONT edit)
    cd "%serverLocation%"
    echo (%time%) %serverName% started.

    goto checkServer
    pause

    :checkServer
    tasklist /fi "imagename eq %dayzsaExe%" 2>NUL | find /i /n "%dayzsaExe%">NUL
    if "%ERRORLEVEL%"=="0" goto checkBEC
    cls
    echo Server is not running, taking care of it..
    goto killserver

    :checkBEC
    tasklist /fi "imagename eq %becExe%" 2>NUL | find /i /n "%becExe%">NUL
    if "%ERRORLEVEL%"=="0" goto loopServer
    cls
    echo Bec is not running, taking care of it..
    goto startBEC

    :loopServer
    FOR /L %%s IN (30,-1,0) DO (
    cls
    echo Server is running. Checking again in %%s seconds.. 
    timeout 1 >nul
    )
    goto checkServer

    :killserver
    taskkill /f /im %becExe%
    taskkill /f /im %dayzsaExe%
    taskkill /f /im %dzsalExe%
    goto checkmods

    :checkmods
    cls
    FOR /L %%s IN (%steamcmdDel%,-1,0) DO (
    cls
    echo Checking for mod updates in %%s seconds.. 
    timeout 1 >nul
    )
    echo Reading in configurations/variables set in this batch and modList. Updating Steam Workbench mods...
    @ timeout 1 >nul
    cd %steamcmdLocation%
    for /f "tokens=1,2 delims=," %%g in %modList% do steamcmd.exe +login %steamUser% +workshop_download_item 221100 "%%g" +quit
    cls
    echo Steam Workshop files up to date! Syncing Workbench source with server destination...
    @ timeout 2 >nul
    cls
    @ for /f "tokens=1,2 delims=," %%g in %modList% do robocopy "%steamWorkshop%\%%g" "%serverLocation%\%%h" *.* /mir
    @ for /f "tokens=1,2 delims=," %%g in %modList% do forfiles /p "%serverLocation%\%%h" /m *.bikey /s /c "cmd /c copy @path %serverLocation%\keys"
    cls
    echo Sync complete! If sync not completed correctly, verify configuration file.
    @ timeout 3 >nul
    cls
    set "MODS_TO_LOAD="
    for /f "tokens=1,2 delims=," %%g in %modList% do (
    set "MODS_TO_LOAD=!MODS_TO_LOAD!%%h;"
    )
    set "MODS_TO_LOAD=!MODS_TO_LOAD:~0,-1!"
    ECHO Will start DayZ with the following mods: !MODS_TO_LOAD!%
    @ timeout 3 >nul
    goto startserver

    :startserver
    cls
    echo Starting DayZ SA Server.
    timeout 1 >nul
    cls
    echo Starting DayZ SA Server..
    timeout 1 >nul
    cls
    echo Starting DayZ SA Server...
    cd "%serverLocation%"
    start %dzsalExe% -config=%serverConfig% -instanceId=%instanceIdNumber% -cpuCount=%serverCPU% -port=%serverPort% -dologs -adminlog -netlog -freezecheck -BEpath=%beFolder% -profiles=%serverProfiles% "-servermod=%serverMod%" "-mod=!MODS_TO_LOAD!%" "-scrAllowFileWrite"
    FOR /L %%s IN (30,-1,0) DO (
    cls
    echo Initializing server, wait %%s seconds to initialize Bec.. 
    timeout 1 >nul
    )
    goto startbec

    :startbec
    cls
    echo Starting BEC.
    timeout 1 >nul
    cls
    echo Starting BEC..
    timeout 1 >nul
    cls
    echo Starting BEC...
    timeout 1 >nul
    cd "%becFolder%"
    start %becExe% -f %becConfig% --dsc
    goto checkServer
