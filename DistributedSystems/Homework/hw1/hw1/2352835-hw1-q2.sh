if [ $# -ne 1 ]; then
    echo "用法: $0 <目录路径>"
    exit 1
fi

dir="$1"

# 检查目录是否存在
if [ ! -d "$dir" ]; then
    echo "错误: $dir 不是一个有效的目录"
    exit 1
fi

# 查找目录中的所有文件（不含子目录），转换为小写，然后排序
find "$dir" -maxdepth 1 -type f -printf "%f\n" | tr '[:upper:]' '[:lower:]' | sort