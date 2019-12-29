# 删除排序链表中的重复元素


<!--more-->


## 【简单】83. 删除排序链表中的重复元素

[原题地址](https://leetcode-cn.com/problems/remove-duplicates-from-sorted-list/)

给定一个排序链表，删除所有重复的元素，使得每个元素只出现一次。

**示例 1：**

```text
输入: 1->1->2
输出: 1->2
```

**示例 2：**

```text
输入: 1->1->2->3->3
输出: 1->2->3
```

### 解题思路

链表的基础

* 1、当链表为空表时，应该直接返回这个链表
* 2、初始化 `current` 为头位置，记录 `current` 当前循环位置，用当前的值去比较下一位值。当相等指向下下一位\(以此来去重\)。以此类推
* 3、时间复杂度 `O(n)`, 空间复杂度 `O(1)`

### 参考代码

```go
func deleteDuplicates(head *ListNode) *ListNode {
    if head == nil {
        return head
    }
    current := head
    for current.Next != nil {
        if current.Val == current.Next.Val {
            current.Next = current.Next.Next
        } else {
            current = current.Next
        }
    }
    return head
}
```

