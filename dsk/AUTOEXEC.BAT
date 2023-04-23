mode 80
alias exit = a:\omsxctl exit 0
echo Enabling throttling;
omsxctl set throttle on
echo Enabling renderer;
omsxctl set renderer SDL
echo BOOT COMPLETED, to leave type: exit
