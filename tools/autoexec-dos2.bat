rem Managed autoexec.bat for msxhub-packages
mode 80
ver
echo Extending search path;
PATH + A:\UTILS
PATH
echo Enabling renderer;
omsxctl set renderer SDL
echo Enabling throttling;
omsxctl set throttle on
echo BOOT COMPLETED