# 检查是否提供了参数
if [ $# -ne 1 ]; then
    echo "用法: $0 <秒数>"
    exit 1
fi

# 检查参数是否为正整数
if ! [[ $1 =~ ^[0-9]+$ ]]; then
    echo "错误: 请输入一个正整数作为秒数"
    exit 1
fi

seconds=$1

# 倒计时逻辑
while [ $seconds -gt 0 ]; do
    echo "剩余时间: $seconds 秒"
    sleep 10
    seconds=$((seconds - 10))
done

echo "倒计时结束!"