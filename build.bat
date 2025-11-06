@echo off
setlocal enabledelayedexpansion

echo -------------------------------------------------------
echo 🛠️ Compilando y enlazando asm_primitive_roots.asm
echo -------------------------------------------------------

:: Ajusta la versión de SDK y MSVC a la instalada en tu equipo
set "SDK_LIB=C:\Program Files (x86)\Windows Kits\10\Lib\10.0.26100.0\um\x64"
set "UCRT_LIB=C:\Program Files (x86)\Windows Kits\10\Lib\10.0.26100.0\ucrt\x64"
set "MSVC_LIB=C:\Program Files (x86)\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35219\lib\x64"

ml64 /c /Fo asm_primitive_roots.obj asm_primitive_roots.asm
if %errorlevel% neq 0 (
    echo ❌ Error al ensamblar el código
    pause
    exit /b 1
)

link asm_primitive_roots.obj ^
    /subsystem:console ^
    /entry:main ^
    /defaultlib:kernel32.lib ^
    /defaultlib:ucrt.lib ^
    /defaultlib:vcruntime.lib ^
    /defaultlib:libcmt.lib ^
    /LIBPATH:"%MSVC_LIB%" ^
    /LIBPATH:"%SDK_LIB%" ^
    /LIBPATH:"%UCRT_LIB%" ^
    /OUT:asm_primitive_roots.exe

if %errorlevel% neq 0 (
    echo ❌ Error al enlazar el código
    pause
    exit /b 1
)

echo ✅ Compilación y enlace exitosos!
echo -------------------------------------------------------
echo Ejecutando el programa...
echo -------------------------------------------------------

asm_primitive_roots.exe

pause
endlocal
