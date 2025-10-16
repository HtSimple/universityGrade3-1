# 检查参数数量
if [ $# -ne 2 ]; then
    echo "用法: $0 <文件名> <单词>"
    exit 1
fi

file="$1"
word="$2"

# 检查文件是否存在
if [ ! -f "$file" ]; then
    echo "不存在"
    exit 0
fi

# 统计单词出现次数（不区分大小写）
count=$(grep -i -o "\b$word\b" "$file" | wc -l)

echo "$word在文中出现次数为:$count"