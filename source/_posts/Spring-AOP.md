---
title: Spring-AOP
categories: 框架
abbrlink: 97375e6e
date: 2020-07-08 16:47:29
tags: 
	- Spring
	- AOP
---

> AOP

<!-- more -->
## AOP

Aspect Oriented Programming  ---- 面向切面编程

- 降低耦合度
- 易拓展
- 复用
- 非业务集中，便于统一管理
- 业务代码比较纯粹，没有其他代码影响

### 使用

- 创建Maven工程，添加坐标

  ```xml
  <dependencies>
      <dependency>
          <groupId>org.springframework</groupId>
          <artifactId>spring-aop</artifactId>
          <version>5.1.3.RELEASE</version>
      </dependency>
      <dependency>
          <groupId>org.springframework</groupId>
          <artifactId>spring-aspects</artifactId>
          <version>5.2.7.RELEASE</version>
      </dependency>
  </dependencies>
  ```

Invocationhandler

  生成代理类的类，

  imlements InvocationHandler

  - 接收jjadf 啊收到回复ahsudjf 委托对象

  - 设置返回代理类

    Proxy.newProxyInstance()

  - 编写委托对象方法

### Spring框架对AOP进行封装

不需要创建InvocationHandler，只需要创建一个切面对象，将业务代码在切面中完成即可

- 创建切面类对象 Aspect（切面）
- 添加注解

LoggerAspect

- `@Aspect` ： 表示该类为切面类
- `@Component`：将该类对象注入到IoC容器中
- `@Befor` :表示方法执行的具体位置和时机  

CalImpl2 也需要添加`@Component`



```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:p="http://www.springframework.org/schema/p"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd">
    <!--  自动扫描  -->
    <context:component-scan base-package="com.item" ></context:component-scan>
<!--    <bean class="com.item.AOP.LoggerAspect" p:id="" />-->
    <!--  使 Aspect 标签生效，为目标类自动生成代理对象  -->
    <aop:aspectj-autoproxy />
</beans>
```

context:component-scan 标签是扫描包内所有添加@Component注解的类，注入到IoC中

aop:aspectj-autoproxy 让Spring结合切面类和目标类自动生成代理对象。

- 切面：横切关注点被模块化的抽象对象
- 通知：切面对象完成的工作（非业务代码，日志...）
- 目标：被通知的对象，即被切面的对象
- 代理：切面、通知、目标混合之后的对象
- 连接点：通知插入业务代码的具体位置
- 切点：AOP通过切点定位到连接点

