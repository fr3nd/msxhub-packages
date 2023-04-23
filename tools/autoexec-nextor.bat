rem Managed autoexec.bat for msxhub-packages
echo Set mode 80.
mode 80
echo Add alias to leave type: exit
alias exit = a:\omsxctl exit 0
echo Enabling throttling;
omsxctl set throttle on
echo Enabling renderer;
omsxctl set renderer SDL
echo BOOT COMPLETED
