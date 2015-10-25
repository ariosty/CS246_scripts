#!/bin/bash

if [ $# -ne 2 ]; then
    echo "usage: runValgrind.sh test_suite program" 1>&2
    exit 1
fi

sum=0
while read line
do
    in_file=$line".in"
    arg_file=$line".args"
    out_file=$line".out"
    error=0
    ls "$arg_file" >/dev/null 2>/dev/null
    if [ $? -ne 0 ]; then
        str=`valgrind "$2" <"$in_file" 2>&1 >/dev/null | tail -1 | egrep -o [0-9]* | cut -d \  -f2`
    else
        str=`valgrind "$2" $(cat "$args_file") <"$in_file" 2>&1 >/dev/null | tail -1 | egrep -o [0-9]* | cut -d \  -f2`
    fi
    error=`echo $str | cut -d \  -f2`
    sum=$((sum+error))
    echo "Test" $line": $error errors"
done <$1

echo "Total:" $sum "errors."
