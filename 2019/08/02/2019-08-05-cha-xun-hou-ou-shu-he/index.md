# 查询后的偶数和


<!--more-->


## 【简单】985. 查询后的偶数和

### 题目

[原题地址](https://leetcode-cn.com/problems/sum-of-even-numbers-after-queries/)

给出一个整数数组 A 和一个查询数组 `queries`。

对于第 `i` 次查询，有 `val = queries[i][0]`, `index = queries[i][1]`，我们会把 `val` 加到 `A[index]` 上。然后，第 `i` 次查询的答案是 `A` 中偶数值的和。

_（此处给定的 `index = queries[i][1]` 是从 `0` 开始的索引，每次查询都会永久修改数组 `A`。）_

返回所有查询的答案。你的答案应当以数组 `answer` 给出，`answer[i]` 为第 `i` 次查询的答案。

**示例：**

```text
输入：
A = [1,2,3,4], queries = [[1,0],[-3,1],[-4,0],[2,3]]

输出：
[8,6,2,4]

解释：
开始时，数组为 [1,2,3,4]。
将 1 加到 A[0] 上之后，数组为 [2,2,3,4]，偶数值之和为 2 + 2 + 4 = 8。

将 -3 加到 A[1] 上之后，数组为 [2,-1,3,4]，偶数值之和为 2 + 4 = 6。

将 -4 加到 A[0] 上之后，数组为 [-2,-1,3,4]，偶数值之和为 -2 + 4 = 2。

将 2 加到 A[3] 上之后，数组为 [-2,-1,3,6]，偶数值之和为 -2 + 6 = 4。
```

**提示：**

```text
1 <= A.length <= 10000
-10000 <= A[i] <= 10000

1 <= queries.length <= 10000

-10000 <= queries[i][0] <= 10000

0 <= queries[i][1] < A.length
```

### 解题思路

#### 暴力解题

_参考代码1_

暴力解题直接根据数组循环来算出 A 改变后的偶数和，放入 answer 数组中。

时间复杂度 O\(n^2\)

#### 动态规划

_参考代码2_

运用每一次循环得出来的结果，做运算。

### 参考代码

1、暴力解题

```go
func sumEvenAfterQueries(A []int, queries [][]int) []int {
    answer := make([]int, len(A))
    for k := range A {
        querie := queries[k]
        val := querie[0]
        index := querie[1]
        A[index] += val
        tmp := 0
        for _, v := range A {
            if (v % 2) == 0 {
                tmp += v
            }
        }
        answer[k] = tmp
    }
    return answer
}
```

2、动态规划分析

```go
func sumEvenAfterQueries(A []int, queries [][]int) []int {
    sum := 0
    for _, v := range A {
        if v%2 == 0 {
            sum += v
        }
    }
    result := make([]int, len(A))
    for k, v := range queries {
        val := v[0]
        index := v[1]
        A[index] += val
        if A[index]%2 == 0 {
            if val%2 == 0 {
                sum = sum + val
            } else {
                sum = sum + A[index]
            }
        } else {
            if val%2 != 0 {
                sum = sum - (A[index] - val)
            }
        }
        result[k] = sum
    }
    return result
}
```

### 参考资料

* [算法-动态规划](https://blog.csdn.net/u013309870/article/details/75193592)

