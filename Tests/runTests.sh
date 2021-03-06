#!/usr/bin/env bash
cd `dirname ${TM_FILEPATH:-.}`
testFiles=(*.jsonrnc) # create array of jsonrnc files

for file in ${testFiles[@]}
do
    touch $file    # force the creation of a new jsonrnc.json file
    name=`basename $file .jsonrnc`
    if [ -f $name.json ]; then
        ../Src/ValidateJsonRnc.py --stats $name.jsonrnc $name.json | cmp $name.out
    else
        ../Src/ValidateJsonRnc.py --stats $name.jsonrnc $name.jsonl | cmp $name.out
    fi
    if [ $? != 0 ]; then
        echo 'no match for: ' $file
    fi
done

../Src/SplitJson.py <TestSplitter.txt | cmp TestSplitter.out
if [ $? != 0 ]; then
    echo 'no match for: TestSplitter'
fi
echo "Test complete for `expr ${#testFiles[@]} + 1` files"

