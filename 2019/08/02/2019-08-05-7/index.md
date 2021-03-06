# 整数反转


<!--more-->


## 【简单】7. 整数反转

### 题目

[原题地址](https://leetcode-cn.com/problems/reverse-integer/)

给出一个 `32` 位的有符号整数，你需要将这个整数中每位上的数字进行反转。

**示例 1：**

```text
输入: 123
输出: 321
```

**示例 2：**

```text
输入: -123
输出: -321
```

**示例 3：**

```text
输入: 120
输出: 21
```

**注意:**

假设我们的环境只能存储得下 `32` 位的有符号整数，则其数值范围为 `[−2^31, 2^31 − 1]`。请根据这个假设，如果反转后整数溢出那么就返回 `0`。

### 解题思路

#### 1. 暴力解法

1. 一个 `32` 位的有符号整数，将 `整数` 变为 `字符串`，然后第一位替换最后一位，第二位替换倒数第二位，以此类推。
2. 当前面存在符号，需要用第二位替换最后一位，第三位替换倒数第二位。

   如：`-123`，符号需要保留在第一位。则是第二位替换最后一位

#### 2.巧解

1. 反转整数，说明第一位反而最后会变成最大位。
2. 题目 说明 给出一个 `32` 位的有符号整数。说明只能是整数，
3. 利用 `%` 运算符，当每次 `%` `10` 获得他最后一位。
4. 前一次获得的值 `* 10` 加上最后一位获得最后的反转整数

### 参考代码

#### 1.暴力解法

```go
func reverse(x int) int {
    s := []rune(strconv.Itoa(x))
    lenX := len(s)
    i := 0
    if s[0] == 45 {
        i = 1
    }
    for ; i <= (lenX-1)/2; i++ {
        if s[0] == 45 {
            s[i], s[lenX-i] = s[lenX-i], s[i]

        } else {
            s[i], s[lenX-i-1] = s[lenX-i-1], s[i]
        }
    }

    num, err := strconv.Atoi(string(s))
    if err != nil {
        return 0
    }
    if num > math.MaxInt32 || num < math.MinInt32 {
        return 0
    }
    return num
}
```

#### 2.巧解

```go
func reverse(x int) int {
    num := 0
    for x != 0 {
        tmp := x % 10
        x = x / 10
        num = num*10 + tmp
    }
    if num > math.MaxInt32 || num < math.MinInt32 {
        return 0
    }
    return num
}
```

