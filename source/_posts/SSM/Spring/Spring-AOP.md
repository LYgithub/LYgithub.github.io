---
dtitle: Spring-AOP
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

## 关键词

- 增强处理(Advice)：切入的公共代码
- 切面(Aspect)：横切关注点被模块化的抽象对象
- 通知：切面对象完成的工作（非业务代码，日志...）
- 目标(Target Object)：被通知的对象，即被切面的对象
- AOP代理(AOP Proxy)：切面、通知、目标混合之后的对象
- 连接点(Join Point)：通知插入业务代码的具体位置，获取方法的`参数`
- 切点(Point Cut)：AOP通过切点定位到连接点
- 织入(Weaving)：切入，动态织入

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
      <dependency>
          <!--  IoP注解  -->
          <groupId>org.springframework</groupId>
          <artifactId>spring-context</artifactId>
          <version>5.1.3.RELEASE</version>
      </dependency>
  </dependencies>
  ```

Invocationhandler

  生成代理类的类，imlements InvocationHandler

  - 接收..?到回复..?委托对象

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

- 

## 使用

- 编写日子打印类

> log4j 使用 
>
> Logger logger = Logger.getLogger(MyLogger.class);
>
> logger.info("something")

```java
package com.yang.logger;

import org.apache.log4j.Logger;
import org.aspectj.lang.JoinPoint;
import org.springframework.stereotype.Component;

import java.util.Arrays;

// 注入到 IoC 容器
@Component("log")
public class MyLogger {
    private Logger logger = Logger.getLogger(MyLogger.class);

    ///@Test
    //public void test(){
    //    logger.info("日志信息...info");
    //    logger.debug("日志信息...debug");
    //    logger.warn("日志信息...warn");
    //    logger.error("日志信息...error");
    //}

    /**
     * 方法执行结束后执行
     */
    public void AfterLog(JoinPoint joinpoint){
        // 通过设置参数获取 切点参数
        Object target = joinpoint.getTarget();
        String name = joinpoint.getSignature().getName();
        Object[] args = joinpoint.getArgs();
        String s = Arrays.toString(args);
        logger.info(target + ">>>" + name + "方法被调用，参数为：" + s);

    }
}

```



- 配置文件 `applicationContext.xml` ，需要引入依赖：`xmlns:aop="http://www.springframework.org/schema/aop"`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context.xsd
       http://www.springframework.org/schema/mvc
       http://www.springframework.org/schema/mvc/spring-mvc-3.2.xsd
        http://www.springframework.org/schema/aop
        http://www.springframework.org/schema/aop/spring-aop-3.2.xsd">

    <!-- ... -->
    <!--  后置增强  -->
    <aop:config>
        <aop:pointcut id="point" expression="execution(* com.yang.controller.*.*(..))"/>
        <aop:aspect ref="log">
            <aop:after method="AfterLog" pointcut-ref="point" />
        </aop:aspect>
    </aop:config>
</beans>
```

- 

