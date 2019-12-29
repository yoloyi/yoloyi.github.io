# 两数之和


<!--more-->


## 【简单】1. 两数之和

### 题目

[原题地址](https://leetcode-cn.com/problems/two-sum)

给定一个整数数组 `nums` 和一个目标值 `target`，请你在该数组中找出和为目标值的那 两个 整数，并返回他们的数组下标。

你可以假设每种输入只会对应一个答案。但是，你不能重复利用这个数组中同样的元素。

**示例：**

```text
给定 nums = [2, 7, 11, 15], target = 9

因为 nums[0] + nums[1] = 2 + 7 = 9
所以返回 [0, 1]
```

### 解题思路

* 1、 这道题目在普通有一种暴力解法，是两层循环。但是时间复杂度为 `O(n^2)` 
* 2、另外一种方式是将每个值利用hash保存起来，使用 `map` 来寻找对应的 `index` 时间复杂度为 `O(n)` 

### 参考代码

```go
func twoSum(nums []int, target int) []int {
    numsMap := make(map[int]int, len(nums))
    for k, v := range nums {
        numsMap[v] = k
    }
    for k, v := range nums {
        tmp := target - v
        if _, ok := numsMap[tmp]; ok && k != numsMap[tmp] {
            return []int{k, numsMap[tmp]}
        }
    }
    return []int{-1, -1}
}
```

