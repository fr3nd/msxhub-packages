rem Managed autoexec.bat for msxhub-packages
mode 80
COLOR 15,0,0
ver
echo Extending search path;
PATH + A:\UTILS
PATH
dir/w files
echo Display openMSX;
omsxctl after time 2 enable_gui
echo BOOT COMPLETED
cd files