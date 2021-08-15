#!/bin/bash

#set -x

# brew install imagemagick


usage() {
    echo "pdf2png [v|vertical|h|horizontal]  /path/to/xx.pdf"
}

pdf2png() {
    local filePath=""
    local direction="vertical"
    if [ $# -lt 1  ];then
        usage
        exit 1
    elif [ $# -eq 1 ];then
        filePath=$1
    else 
        direction=$1
        filePath=$2
    fi

    local fileDir=`dirname $filePath`

    if [ -z "$fileDir" ];then
        fileDir=`pwd`
    else
        fileDir=$(cd $fileDir && pwd)
    fi

    local fileName=`basename $1`
    local filePrefix=${fileName%.pdf}
    local outputFileName="$filePrefix".png

    local tmpOutDir=/tmp/pdf2png
    rm -rf $tmpOutDir
    mkdir $tmpOutDir

    cp $1 $tmpOutDir/input.pdf

    pushd $tmpOutDir
    convert -density 150 input.pdf -quality 90 output.png
    if [ "$direction"x = "vertical"x -o "$direction"x = "v"x ];then
        #垂直拼接
        convert -append output-*.png out.png
    else
        #水平拼接
        convert +append output-*.png out.png
    fi

    cp -f  out.png "$fileDir"/$outputFileName
    popd
    rm -rf $tmpOutDir
}

pdf2png $@
