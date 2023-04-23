rem Managed autoexec.bat for msxhub-packages
mode 80
echo Extending search path
PATH + A:\ A:\SOFAROM
echo Enabling throttling;
omsxctl set throttle on
echo Enabling renderer;
omsxctl set renderer SDL
echo MSXDOS Version;
ver
echo BOOT COMPLETED
