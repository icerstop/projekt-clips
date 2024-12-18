@echo off

REM Uruchomienie aplikacji Java z odpowiednim ustawieniem ścieżki do bibliotek
REM Można odaplić program w odpowiednim języku rosyjskim, hiszpańskim oraz japońskim
java -Djava.library.path="./Release_lib" -Duser.language=ru -jar Release.jar

REM Sprawdzanie kodu zakończenia
if %ERRORLEVEL% neq 0 (
    echo Wystapil blad przy uruchamianiu aplikacji Java!
    echo Kod bledu: %ERRORLEVEL%
) else (
    echo Aplikacja zostala uruchomiona pomyslnie.
)

pause