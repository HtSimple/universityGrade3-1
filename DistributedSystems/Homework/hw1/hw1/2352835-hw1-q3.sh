# 检查参数数量
if [ $# -ne 2 ]; then
    echo "用法: $0 <目录路径> <文件名>"
    exit 1
fi

dir="$1"
filename="$2"

# 检查目录是否存在
if [ ! -d "$dir" ]; then
    echo "错误: $dir 不是一个有效的目录"
    exit 1
fi

# 查找文件
result=$(find "$dir" -name "$filename")

if [ -n "$result" ]; then
    echo "$result"
else
    echo "不存在"
fi