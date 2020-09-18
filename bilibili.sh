#!/data/data/com.termux/files/usr/bin/bash

function_help() {
    echo "bilibili.sh -i [input dir] -t [custom title] -d [dir]"
    echo -e "-i  -  example -> /sdcard/Android/data/com.bilibili.app/download/xxxxxxxx (Required)\n"
    echo -e "-t  -  use custom title (empty to read from entry.json) (Optional)\n"
    echo -e "-d  -  output dir (Optional)\n"
    exit 0
}

if [ $# = 0 ]; then
    function_help
fi

POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--help)
            function_help
            ;;
        -i)
            input="$2"
            shift
            shift
            ;;
        -t)
            title="$2"
            shift
            shift
            ;;
        -d)
            dir="$2"
            shift
            shift
            ;;
        *)
            POSITIONAL+=("$1")
            shift
            ;;
    esac
done

if [ -z "$input" ]; then
    function_help
fi

if [ -n "$dir" ]; then
    mkdir -p "$dir"
else
    dir="$input"
fi

cd "$input"
pw=$PWD
for n in $(find -maxdepth 1 -type d|grep '[0-9]'); do
    cd $n
    cd $(find -maxdepth 1 -type d|grep '[0-9]')

    if [ -f cat ]; then
        rm cat
    fi

    if [ -z "$title" ]; then
        title=$(grep -o "\"title\":\".*\"," ../entry.json|sed -n -e 's/"//gp'|awk -F',' '{print $1}'|awk -F':' '{print $2}')
    fi
    index=$(grep -o "\"index\":\".*\"," ../entry.json|sed -n -e 's/"//gp'|awk -F',' '{print $1}'|awk -F':' '{print $2}')
    sub=$(grep -o "\"index_title\":\".*\"" ../entry.json|sed -n -e 's/"//gp'|awk -F',' '{print $1}'|awk -F':' '{print $2}')
    part=$(grep -o "\"part\":\".*\"" ../entry.json|sed -n -e 's/"//gp'|awk -F',' '{print $1}'|awk -F':' '{print $2}')
    if [ -z $index ] || [ $index -lt 10 ]; then
        index=" 0${index}"
    else
        index=" ${index}"
    fi
    if [ "$index" = " 0" ]; then
        index=""
    fi

    if [ -z "$sub" ] && [ -z "$part" ]; then
        fname="${title}${index}"
    fi
    if [ -n "$sub" ]; then
        fname="${title}${index} - ${sub}"
    fi
    if [ -n "$part" ]; then
        fname="${title}${index} - ${part}"
    fi

    echo "Converting ${fname}......"
    if [ -n "$(find|grep blv)" ]; then
        for i in $(ls *.blv| grep -v sum); do
            echo file\ \'${i}\' >> cat
        done
        ffmpeg -f concat -safe 0 -i cat -c copy -y "${dir}/${fname}.mp4" > /dev/null 2>&1
        rm cat
    else
        ffmpeg -i video.m4s -i audio.m4s -c copy -map 0:v -map 1:a -y "${dir}/${fname}.mp4" > /dev/null 2>&1
    fi
    cd $pw
    echo -e "Done.\n"
done
