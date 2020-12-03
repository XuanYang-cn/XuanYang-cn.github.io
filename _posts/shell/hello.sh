#!/bin/bash
echo "Hello World"
a=`pwd`
echo $a

echo "Program Name : $0"
echo "Arg1 : $1"
echo "Arg2 : $2"
echo "Arg3 : $3"
echo "Arg4 : $4"
echo "\$@ : $@"
echo "\$* : $*"
echo "\$# : $#"
Name="u"
last | grep "${Name}" 1>/dev/null 2>/dev/null

if [[ $? -eq 0 ]];then
    echo "$Name logged in!"
fi
