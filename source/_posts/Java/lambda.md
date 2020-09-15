---
title: lambda入门
abbrlink: 1ba1fa2d
categories: Java
---
> 总结 lambda 使用

<!-- more -->
## @FunctionalInterface

```java
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface FunctionalInterface {}
```

> 函数式接口: 注解用于接口，只允许有一个抽象函数

> - java.lang.Runnable,
> - java.awt.event.ActionListener,
> - java.util.Comparator,
> - java.util.concurrent.Callable
> - java.util.function包下的接口，如Consumer、Predicate、Supplier等

## lambda

**基本语法：**

**(parameters) -> expression** 或 **(parameters) ->{ statements; }**

当 statements 只包含一句语句时可以省略 `{ }`



## 示例

1. 编写函数式接口

```java
@FunctionalInterface
interface MyInterface2{
    public abstract int method(int x,int y);
}
```

2. 将接口作为函数参数

```java
private static void test2(MyInterface2 myInterface2,int x,int y){
    myInterface2.method(x,y);
}
```

3. 调用方法，使用lambda 表达式

```java
test2((x,y)->{
            int sum = x + y;
            return sum;
},2,3);
```

- 可以转换为

```java
test2((x,y)->x + y,2,3);
```

## 格式

### 完整格式

```java
(int x, int y )->{
    int sum = x + y;
    return sum;
}
```

### 省略参数类型

```java
(x, y )->{
    int sum = x + y;
    return sum;
}
```

### 省略参数括号

> 当参数列表包含一个参数时可以省略 `()`,` 参数的数据类型不许一块省略`

```java
x->{
    int double_nu = x * 2;
    return double_nu;
}
```

### 省略大括号

> 当实现方法的语句只包含一句，或直接返回值时可以省略

```java
(int x, int y ) -> x + y
(int x) -> 2 * x
```


---

# 参考内容

[@FunctionInterface](https://www.jianshu.com/p/52cdc402fb5d)

[JAVA8 Lambda 使用实例](https://blog.csdn.net/qq_37176126/article/details/81273195)

