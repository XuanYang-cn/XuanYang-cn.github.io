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

function __printf__ () {
    echo "$1"
    return
}

__printf__ "Hello function"

a=11
if [[ $a -gt 10 ]];then
    echo "${a} > 10"
elif [[ $a -eq 10 ]];then
    echo "${a} = 10"
else
    echo "${a} < 10"
fi

b=8
case $b in
    1)
        echo 1
        ;;
    2)
        echo 2
        ;;
    3)
        echo 3
        ;;
    default)
        echo 4
        ;;
esac

for i in `ls`;do
    echo ${i}
done

for ((i = 1; i < 5; i++));do
    echo ${i}
done

for (( i=1; i<100; i++ ));do
    if [[ $[ $i % 2 ] -eq 0 ]]; then
        sum=$[ ${sum} + $i ]
    fi
done

echo "sum=${sum}"
