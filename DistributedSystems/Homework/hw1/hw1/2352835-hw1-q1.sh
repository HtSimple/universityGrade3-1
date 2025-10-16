# 判断质数函数
is_prime() {
    local n=$1
    if [ $n -le 1 ]; then
        return 1   # 不是质数
    fi
    if [ $n -eq 2 ]; then
        return 0   # 是质数
    fi
    if [ $((n % 2)) -eq 0 ]; then
        return 1   # 偶数不是质数
    fi
    # 检查从 3 到 sqrt(n) 的奇数
    for ((i=3; i*i<=n; i+=2)); do
        if [ $((n % i)) -eq 0 ]; then
            return 1
        fi
    done
    return 0
}

sum=0
up=100

# 遍历 0 到 100
for ((num=0; num<=up; num++)); do
    if is_prime $num; then
        sum=$((sum + num))
    fi
done

echo "1-$up之间所有质数之和为：$sum"