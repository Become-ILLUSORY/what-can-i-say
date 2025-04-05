#!/bin/sh

# 定义下载链接和文件名
download_url_1="http://www.fish2018.ip-ddns.com/p/jsm.json"
downloaded_file_1="PG.json"
download_url_2="https://pg.banye.tech:7777/pg/lib/tokenm?token=banye"
downloaded_file_2="token.json"

# 定义要替换的文本和替换后的文本
old_text_0="./pg.jar"
new_text_0="http://www.fish2018.ip-ddns.com/p/pg.jar"
old_text_1="./lib/"
new_text_1="http://www.fish2018.ip-ddns.com/p/lib/"
old_text_2="http://www.fish2018.ip-ddns.com/p/lib/tokenm.json"
new_text_2="https://github.boki.moe/gh/Become-ILLUSORY/what-can-i-say@main/PG/token.json"

# 第三波替换的内容
old_text_3="./"
new_text_3="http://www.fish2018.ip-ddns.com/p/lib/"

# 第四波替换的内容
old_text_4="https://tg.banye.tech:7777/"
new_text_4=""


# 要插入的 JSON 结构体
insert_struct='[
    {
        "key": "Wexconfig",
        "name": "🐮配置┃中心🐮",
        "type": 3,
        "jar": "https://fs-im-kefu.7moor-fs1.com/ly/4d2c3f00-7d4c-11e5-af15-41bf63ae4ea0/1742475704348/wex.txt",
        "api": "csp_WexconfigGuard"
    },
    {
        "key": "Wexemby",
        "name": "🀄️emby┃4K🀄️",
        "type": 3,
        "jar": "https://fs-im-kefu.7moor-fs1.com/ly/4d2c3f00-7d4c-11e5-af15-41bf63ae4ea0/1742475704348/wex.txt",
        "api": "csp_WexembyGuard",
        "searchable": 1,
        "changeable": 1
    }
]'

# 下载第一个文件
echo "开始下载 $downloaded_file_1..."
curl -o "$downloaded_file_1" "$download_url_1"
if [ $? -ne 0 ]; then
    echo "下载 $downloaded_file_1 失败。"
    exit 1
fi

# 下载第二个文件
echo "开始下载 $downloaded_file_2..."
curl -o "$downloaded_file_2" "$download_url_2"
if [ $? -ne 0 ]; then
    echo "下载 $downloaded_file_2 失败。"
    exit 1
fi


# 第零波文本替换（在第一个文件中）
echo "正在对 $downloaded_file_1 进行第零波替换..."
sed -i "s|$old_text_0|$new_text_0|g" "$downloaded_file_1"
if [ $? -ne 0 ]; then
    echo "替换 $downloaded_file_1 中 $old_text_0 为 $new_text_0 失败。"
    exit 1
fi

# 延迟 0.5 秒
sleep 0.5


# 第一波文本替换（在第一个文件中）
echo "正在对 $downloaded_file_1 进行第一波替换..."
sed -i "s|$old_text_1|$new_text_1|g" "$downloaded_file_1"
if [ $? -ne 0 ]; then
    echo "替换 $downloaded_file_1 中 $old_text_1 为 $new_text_1 失败。"
    exit 1
fi

# 延迟 0.5 秒
sleep 0.5

# 第二波文本替换（在第一个文件中）
echo "正在对 $downloaded_file_1 进行第二波替换..."
sed -i "s|$old_text_2|$new_text_2|g" "$downloaded_file_1"
if [ $? -ne 0 ]; then
    echo "替换 $downloaded_file_1 中 $old_text_2 为 $new_text_2 失败。"
    exit 1
fi

# 延迟 0.5 秒
sleep 0.5

# 第三波文本替换（在第二个文件中），仅绝对匹配 ./ 时替换
echo "正在对 $downloaded_file_2 进行第三波替换..."
sed -i "s|\([^.]*\)\./\([^.]*\)|\1$new_text_3\2|g" "$downloaded_file_2"
if [ $? -ne 0 ]; then
    echo "替换 $downloaded_file_2 中 $old_text_3 为 $new_text_3 失败。"
    exit 1
fi


# 第四波文本替换（在第二个文件中），仅绝对匹配tgsearch时替换
echo "正在对 $downloaded_file_2 进行第四波替换..."
sed -i "s|$old_text_4|$new_text_4|g" "$downloaded_file_2"
if [ $? -ne 0 ]; then
    echo "替换 $downloaded_file_2 中 $old_text_4 为 $new_text_4 失败。"
    exit 1
fi


# 在第一个 JSON 文件的指定位置插入结构体
echo "正在向 $downloaded_file_1 中插入结构体..."
jq --argjson insert "$insert_struct" '
    .sites = [
        .sites[] as $site
        | if $site.key == "https://github.com/fish2018/PG"
          then ($site, $insert[])
          else $site
          end
    ]
' "$downloaded_file_1" > temp.json && mv temp.json "$downloaded_file_1"
if [ $? -ne 0 ]; then
    echo "向 $downloaded_file_1 中插入结构体失败。"
    exit 1
fi

echo "EMBY操作完成。"


#json中alist修改
# 使用 jq 修改 ext 字段并将结果保存到临时文件
jq '.sites[] |= if .key == "AList" then .ext = "https://github.boki.moe/gh/Become-ILLUSORY/what-can-i-say@main/PG/alistjar.json" else . end' "$downloaded_file_1" > temp.json

# 检查 jq 命令是否执行成功
if [ $? -ne 0 ]; then
    echo "错误: 修改 JSON 文件时出现问题。"
    rm -f temp.json
    exit 1
fi

# 将临时文件重命名为原始文件
mv temp.json PG.json

echo "alist-JSON 文件已更新。"    

