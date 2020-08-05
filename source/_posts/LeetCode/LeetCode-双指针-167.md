---
title: LeetCode-双指针&167
categories: LeetCode
abbrlink: 16b04212
date: 2020-07-11 09:48:16
tags:
	- LeetCode
	- 双指针
---

> 给定一个已按照`升序排列`的有序数组，找到两个数使得它们相加之和等于目标数。函数应该返回这两个下标值 index1 和 index2，其中 index1必须小于index2。

> 示例：

输入: numbers = [2, 7, 11, 15], target = 9
输出: [1,2]
解释: 2 与 7 之和等于目标数 9 。因此 index1 = 1, index2 = 2 。

<!-- more -->

[题目链接](https://leetcode-cn.com/problems/two-sum-ii-input-array-is-sorted/)

## 原始解法

通过双层循环，依次便利测试，如果测试成功返回下标，不成功继续测试。
时间复杂度 `O(n^2)`

```java
class Solution {
    public int[] twoSum(int[] numbers, int target) {
        int index1,index2, sum[]= new int[2];
        for(index1 = 0; index1 < numbers.length; index1 ++){
            for(index2 = index1 + 1; index2 < numbers.length ; index2 ++ ){
            	// 测试成功！
                if(numbers[index1] + numbers[index2] == target){
                    sum[0] = index1 + 1;
                    sum[1] = index2 + 1;
                    return sum;
                }
                // 如果和大于 target index2 不需要继续向下测试
                else if(numbers[index1] + numbers[index2] > target){
                    break;
                }
            }
        }
        return sum;
    }
}
```

## 双指针方法

两个指针分别指向数组两头：

如果 sum > target ： 需要减小大值 => index2 前移

如果 sum < target ： 需要增大小值 => index1 后移

如果 sum = target ： 获取到需要的坐标

- 通过如上方法，数组最多遍历一遍，所以时间复杂度 为 `O(n)`

> 实例如下：

```java
class Solution {
    public int[] twoSum(int[] numbers, int target) {
        int index1, index2;
        index1 = 0;
        index2 = numbers.length - 1;
        while(index1 < index2){
            if(numbers[index1] + numbers[index2] > target ){
                index2--; 
            }
            else if(numbers[index1] + numbers[index2] == target ){ 
                return new int[]{index1+1,index2+1}; 
            }
            else if(numbers[index1] + numbers[index2] < target ){
                index1 ++ ; 
            }
        }
        return null;
    }
}
```
## 结果对比

|方法 |提交结果 | 运行时间 | 内存消耗 | 语言 |
| :------- | :------- | :------- | :------: | :--- |
| 原始方法 |通过     | `82 ms`    | 39.8 MB  | Java |
| 双指针 | 通过     | `1 ms`     | 40 MB    | Java |


---
来源：力扣（LeetCode）
链接：https://leetcode-cn.com/problems/two-sum-ii-input-array-is-sorted
著作权归领扣网络所有。商业转载请联系官方授权，非商业转载请注明出处。








