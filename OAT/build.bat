set GAME_FOLDER=C:\Users\Kiels Main\Downloads\pluto_t6_full_game
set OAT_BASE=C:\Users\Kiels Main\Downloads\OATbo2
set MOD_BASE=%cd%

"%OAT_BASE%\Linker.exe" --verbose --load "%GAME_FOLDER%\zone\all\zm_transit.ff" --add-asset-search-path "%MOD_BASE%" mod

powershell -Command "Compress-Archive -Force -Path images -DestinationPath mod.iwd"

pause