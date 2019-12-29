# 重复 N 次的元素


<!--more-->



## 【简单】961. 重复 N 次的元素

### 题目

[原题地址](https://leetcode-cn.com/problems/n-repeated-element-in-size-2n-array)

在大小为 `2N` 的数组 `A` 中有 `N+1` 个不同的元素，其中有一个元素重复了 `N` 次。

返回重复了 `N` 次的那个元素。

**示例 1：**

```text
输入：[1,2,3,3] 
输出：3
```

**示例 2：**

```text
输入：[2,1,2,5,3,2] 
输出：2
```

**示例 3：**

```text
输入：[5,1,5,2,5,3,5,4]
输出：5
```

**提示：**

```text
4 <= A.length <= 10000
0 <= A[i] < 10000
A.length 为偶数
```

### 解题思路

这题的算法题目，主要是考我们的分析能力。

题目：在大小为 `2N` 的数组 `A` 中有 `N+1` 个不同的元素，其中有一个元素重复了 `N` 次。

* 数组长度为 `2N`
* 除重后有 `N+1` 个不同的数字
* 有一个数字重复了`N` 次，其他的数字仅出现了`一次`，排除掉这个重复的数字，其他的数字只有 `N` 个

根据上述可以得到，只要有一个数字重复，就是结果需要返回的元素

### 参考代码

1、判断重复，用空间来换取时间, 来判断是否有重复

```go
func repeatedNTimes(A []int) int {
    n := uint(len(A) / 2)

    lists := make(map[int]uint, n+1)
    for _, v := range A {
        if _, ok := lists[v]; ok {
            lists[v]++
        } else {
            lists[v] = 1
        }
        if lists[v] == n {
            return v
        }
    }
    return -1
}
```

2、相邻的相同的元素之间的间隔，最多只能为1，否则就是最后一个与前面的相等

```go
func repeatedNTimes(A []int) int {
    for i:=0;i<len(A)-2;i++{
        if A[i]==A[i+1]||A[i]==A[i+2]{
            return A[i]
        }
    }
    return A[len(A)-1] 
}
```

