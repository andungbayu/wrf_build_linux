# enter WPS directory
cd WPS
./compile >& compile.log &
tail -f compile.log
ls
