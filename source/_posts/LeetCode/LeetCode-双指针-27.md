---
title: LeetCode-双指针&移除元素-27
categories: LeetCode
tags:
  - LeetCode
  - 双指针
abbrlink: 276090df
date: 2020-07-11 15:51:17
---

>给你一个数组`nums` 和一个值 val，你需要 原地 移除所有数值等于`val`的元素，并返回移除后数组的新长度。
不要使用额外的数组空间，你必须仅使用 O(1) 额外空间并 `原地` 修改输入数组。
元素的`顺序可以改变`。你不需要考虑数组中超出新长度后面的元素。

<!-- more -->
# 示例 
示例 1:

给定 nums = [3,2,2,3], val = 3,

函数应该返回新的长度 2, 并且 nums 中的前两个元素均为 2。

你不需要考虑数组中超出新长度后面的元素。
示例2:

给定 nums = [0,1,2,2,3,0,4,2], val = 2,

函数应该返回新的长度 5, 并且 nums 中的前五个元素为 0, 1, 3, 0, 4。

注意这五个元素可为任意顺序。

你不需要考虑数组中超出新长度后面的元素。

# 说明

为什么返回数值是整数，但输出的答案是数组呢?

请注意，输入数组是以「引用」方式传递的，这意味着在函数里修改输入数组对于调用者是可见的。

你可以想象内部操作如下:
```java
// nums 是以“引用”方式传递的。也就是说，不对实参作任何拷贝
int len = removeElement(nums, val);

// 在函数里修改输入数组对于调用者是可见的。
// 根据你的函数返回的长度, 它会打印出数组中 该长度范围内 的所有元素。
for (int i = 0; i < len; i++) {
	print(nums[i]);
}
```

# 解

![](https://gitee.com/KawYang/image/raw/master/img/20200711155701.png)

> i 标记符合元素的结尾， 初始值为 : 第一个为 val 的值，在 i 之前全部符合要求。
> j 标记查找后方元素，如果 为 val : 跳过，如果不同：将元素移动到 i 标记处.

```java
class Solution {
    public int removeElement(int[] nums, int val) {
        if(nums.length == 0) {
            return 0;
        }
        int i = 0;
        // 找出 i 的初始值
        while(i<nums.length && nums[i] != val){
            i++;
        }
        // j 查找不同的元素，如果不相同，移动到 i 的位置，i后移。
        for(int j = i; j< nums.length; j++){
            if(nums[j] != val){
                nums[i] = nums[j];
                i++;
            }
        }
        return i;
    }
}
```
---

来源：力扣（LeetCode）
链接：https://leetcode-cn.com/problems/remove-element
著作权归领扣网络所有。商业转载请联系官方授权，非商业转载请注明出处。