# 环形链表


<!--more-->


## 【简单】141. 环形链表

### 题目

[原题地址](https://leetcode-cn.com/problems/linked-list-cycle/submissions/)

给定一个链表，判断链表中是否有环。

为了表示给定链表中的环，我们使用整数 pos 来表示链表尾连接到链表中的位置（索引从 0 开始）。 如果 pos 是 -1，则在该链表中没有环。

**示例 1：**

```text
输入：head = [3,2,0,-4], pos = 1
输出：true
解释：链表中有一个环，其尾部连接到第二个节点。
```

**示例 2：**

```text
输入：head = [1,2], pos = 0
输出：true
解释：链表中有一个环，其尾部连接到第一个节点。
```

**示例 3：**

```text
输入：head = [1], pos = -1
输出：false
解释：链表中没有环。
```

### 解题思路

#### 1、空间换时间

利用 `HashMap`，循环迭代 `ListNode`，放入 `HashMap` 中。当存在于 `HashMap` 中，说明存在环路 时间复杂度O\(n\) 空间复杂度O\(n\)

#### 2、快慢指针

慢指针永远会比快时间慢至少 `1` 的速度 在每一次迭代，快指针与慢指针的距离会慢慢增大，直到循环到最后一位。如果存在回环，则快指针等于慢指针跳出这个循环返回 `true`

### 参考代码

#### 1、空间换时间

```go
/**
 * Definition for singly-linked list.
 * type ListNode struct {
 *     Val int
 *     Next *ListNode
 * }
 */
func hasCycle(head *ListNode) bool {
    a := make(map[*ListNode]uint8)
    for head != nil {
        if head.Next == nil {
            return false
        }
        if _, ok := a[head]; ok {
            return true
        } else {
            a[head] = 1
        }
        head = head.Next
    }
    return false
}
```

#### 2、快慢指针

```go
func hasCycle(head *ListNode) bool {
    if head == nil || head.Next == nil{
        return false
    }
    slow := head
    fast := head.Next
    for slow != fast{
        if fast == nil || fast.Next == nil {
            return false
        }
        fast = fast.Next.Next
        slow = slow.Next
    }
    return true
}
```

