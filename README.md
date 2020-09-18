# bilibili-script
自動合並bilibili下載視頻

## Requirements
- Termux
- ffmpeg

## Installation
安裝Termux，啓動後輸入命令安裝ffmpeg
>apt update && apt install ffmpeg wget

授權Termux存儲權限
>termux-setup-storage
>（外置卡不能寫，要保存到外置卡只有root）

下載bilibili.sh
>wget https://github.com/null4n/bilibili-script/raw/master/bilibili.sh -O $HOME/../usr/bin/bilibili
>chmod 755 $HOME/../usr/bin/bilibili

## Usage
bilibili -i [input dir] -t [custom title] -d [output dir]
源路徑是必須的，只到番號，如
>/sdcard/Android/data/com.bilibili.app/download/123456789

title是自定義標題（文件名），不用此參數自動從entry.json裏讀取

輸出路徑爲空直接輸出到源路徑

> - 同一個番號裏有多個P的自動處理 
> - 動漫番多個劇集自動處理
> - 支持舊版.blv和新版.m4s格式
