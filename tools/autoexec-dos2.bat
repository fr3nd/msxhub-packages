rem Managed autoexec.bat for msxhub-packages
mode 80
echo Extending search path;
PATH + A:\ A:\SOFAROM
PATH
echo MSXDOS Version;
ver
echo Enabling renderer;
omsxctl set renderer SDL
echo Enabling throttling;
omsxctl set throttle on
echo BOOT COMPLETED