---
title: Spring-IoC(控制反转)&DI(依赖注入)
categories: 框架
tags: Spring
abbrlink: 6c92115f
date: 2020-07-08 15:40:07

---

> 本文主要记录了 `Spring` 框架的 `IoC & ID` 基本内容。

<!-- more -->

## Spring框架两大核心机制

- IoC （控制翻转) / DI （依赖注入)
- AOP  (面向切面编程)

企业级开发框架，是软件设计层面的框架，优势在于可以将应用程序进行分层

MVC ：Struts2 、Spring MVC

ORMapping ： Hibernate、MyBatis、Spring Data

![image-20200615165841634](https://gitee.com/KawYang/image/raw/master/img/image-20200615165841634.png)

优点：

1. 容易与第三方框架整合
2. 集中管理

## IoC

> IoC (控制反转) : 将对象使用交给 Spring 进行管理。即创建对象由IoC容器创建。

### 入门 

步骤：

- 创建maven项目，添加pom依赖


```xml
<dependencies>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-context</artifactId>
        <version>5.1.3.RELEASE</version>
    </dependency>
    
    <!-- 简化实体类代码开发 @Data 自动生成 get、set方法  -->
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.12</version>
        </dependency>
</dependencies>
```

- 创建实体类

传统方式：手动 new 方式创建对象

IoC方式：在配置文件中添加管理对象，xml格式自定义文件名，`resources` 下

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<beans xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns="http://www.springframework.org/schema/beans"
      xsi:schemaLocation="http://www.springframework.org/schema/beans
      http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">

    <bean id="student" class="com.item.Student" >
        <property name="id" value="1" />
        <property name="name" value="张三" />
        <property name="age" value="12" />
    </bean>

</beans>
```

- 使用方法

```java
//加载配置文件
ApplicationContext applicationContext = new ClassPathXmlApplicationContext("iocconfig.xml");
Object student = applicationContext.getBean("student");
System.out.println(student);
```

### 配置文件

通过配置Bean标签进行管理

-  `id`:  对象名, `getBean` 的 查找参数。
- `class` ： 对象模版类 `必须有无参构造` ，通过反射机制创建对象， 反射机制是调用无参构造创建
- `property` ：完成属性赋值
  - `name` ： 属性名
  - `value` ： 属性值 String 直接赋值，其他的引用类型，不能通过value赋值，
  -  `ref`  : 将IoC中的另外一个Bean添加，`依赖注入`

```xml
<bean id="student" class="com.item.Student" >
    <property name="id" value="1" />
    <property name="name" value="张三" />
    <property name="age" value="12" />
    <property name="classes" ref="classes" />
</bean>

<bean id="classes" class="com.item.Classes" >
    <property name="id" value="1" />
    <property name="name" value="一班" />
</bean>
```

## IoC底层原理

> 读取配置文件 -> 获取对象创建信息 -> 反射创建对象并存储 -> 获取对象

- 读取xml，解析
- 通过反射机制实例化配置文件中所有的Bean

```java
package com.item.ioc;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;


public class ClassPathXmlApplicationContext implements ApplicationContext{
    //存储创建的对象
    private Map<String, Object> ioc = new HashMap<String, Object>();

    public ClassPathXmlApplicationContext(String path) throws Exception {
        SAXReader reader = new SAXReader();
        Document read = reader.read("./src/main/resources/" + path);
        // 解析 xml 获取配置信息
        Element rootElement = read.getRootElement();
        Iterator iterator = rootElement.elementIterator();
        while (iterator.hasNext()){
        	/** 循环每一个类配置信息 */
            Element element = (Element) iterator.next();
            String id = element.attributeValue("id");
            String className = element.attributeValue("class");

            //通过反射创建对象
            Class aClass = Class.forName(className);
            Constructor constructor = aClass.getConstructor();
            Object o = constructor.newInstance();

            Iterator iterator1 = element.elementIterator();
            while (iterator1.hasNext()){
                Element next =(Element) iterator1.next();
                System.out.println("---------------");
                String name = next.attributeValue("name");
                String value = next.attributeValue("value");

                String ref = next.attributeValue("ref");
                System.out.println(ref);
                //基本变量赋值
                if(ref == null){
                    String mothedName = "set" + name.substring(0, 1).toUpperCase() + name.substring(1);
                    System.out.print(name+ "\t" + value + "\t");
                    Field field = aClass.getDeclaredField(name);
                    System.out.println(field.getType().getName());
                    Method method = aClass.getDeclaredMethod(mothedName, field.getType());
                    Object v = null;
                    if(field.getType().getName() == "int"){
                        v = Integer.parseInt(value);
                    }
                    if(field.getType().getName() == "String"){
                        v = value;
                    }
                    ....
                    method.invoke(o, v);

                }else{ //注入
                    //直接赋值Bean

                    Object obj1 = ioc.get("Classes");
                    System.out.println(obj1);

                    
                }
            }
            ioc.put(id, o);

        }
        System.out.println("=============");
        System.out.println(ioc);
    }

    public Object getBean(String id) {
        return ioc.get(id);
    }
}
```

## 运行时类进行获取Bean

```java
//通过配置文件 🆔 进行获取
Object student = applicationContext.getBean("student");
//通过 运行时类 获取
Student bean = applicationContext.getBean(Student.class);
System.out.println(bean);
```

> 配置文件中只能有一个实例 ,如下抛异常

```xml
<bean id="classes" class="com.item.Classes" >
    <property name="id" value="1" />
    <property name="name" value="一班" />
</bean>

<bean id="classes2" class="com.item.Classes" >
    <property name="id" value="1" />
    <property name="name" value="一班" />
</bean>
```

## 有参构造创建

- 在实例中创建有参构造
- 在xml中配置

```xml
    <bean id="classes3" class="com.item.Classes">
        <!--  两种设置参数方式。-->
        <constructor-arg name="name" value="三班" />
        <constructor-arg index="0" value="2" />
    </bean>
```

## 集合注入

> 使用 `list` 标签 注入类型的集合对象。

```xml
    <bean id="student" class="com.item.Student" >
        <property name="id" value="1" />
        <property name="name" value="张三" />
        <property name="age" value="12" />
        <property name="classes_List" >
            <list>
                <ref bean="classes"></ref>
                <ref bean="classes2"></ref>
            </list>
        </property>
    </bean>
	<bean id="classes" class="com.item.Classes" >
        <property name="id" value="1" />
        <property name="name" value="一班" />
    </bean>

    <bean id="classes2" class="com.item.Classes" >
        <property name="id" value="1" />
        <property name="name" value="一班" />
    </bean>

```

## Scope 作用域

Spring 管理的bean是根据 `scope` 来生成的，表示bean的作用域

- singleton：单例模式，在加载文件时创建bean，通过IoC容器获取的bean是 `唯一` 的。
- prototype：原型模式，在调用getBean时创建bean对象，通过IoC容器获取的bean是 `不同` 的。
- request：请求，表示在一次HTTP请求内有效。
- session：会话，表示在一个用户会话内有效。

request和session只是用于web项目，大多情况下用单例和原型较多

```xml
<bean id="classes" class="com.item.Classes" scope="singleton" >
    <property name="id" value="1" />
    <property name="name" value="一班" />
</bean>
```

## Spring 的继承

> Java 是类层面的继承，子类可以继承父类的内部结构信息。
> Spring 是对象层面的继承，子对象可以继承父对象的属性值。(一种赋值方式)

- 对象层面的继承
- 可以使不同类之间继承，子类中必须包含父类所有属性

```xml
<bean id="classes" class="com.item.Classes" scope="singleton" >
    <property name="id" value="1" />
    <property name="name" value="一班" />
</bean>
<bean id="cla" class="com.item.Classes" parent="classes" >
	<!--对属性进行重写 -->
    <property name="id" value="3" />
</bean>
```


## Spring 的依赖

描述bean和bean之间的`关系`，配置依赖之后，被依赖对象一定`先创建`，再创建依赖bean

> 修改创建顺序

```xml
<bean id="cla" class="com.item.Classes" parent="classes" depends-on="student">
    <property name="id" value="3" />
</bean>
```

![image-20200620174623885](https://gitee.com/KawYang/image/raw/master/img/image-20200620174623885.png)


## Spring 的 P 命名空间

p 命名空间是对 IoC/ DI 的简化

> 引入约束

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<beans xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns="http://www.springframework.org/schema/beans"
       xmlns:p="http://www.springframework.org/schema/p"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans-3.0.xsd">
    <bean>
        ...
    </bean>
```

> 使用方法

```xml
<!--p命名空间-->
<bean id="classes_p" class="com.item.Classes" p:id="1" p:name="adad"/>

<bean id="student_p" class="com.item.Student" p:id="1" p:name="李四" p:age="12" p:classes-ref="classes_p" />

```

## IoC自动装载（Autowire）

IoC负责创建对象，`DI` 完成对象的依赖注入，配置 `property` 标签的 `ref`属性。

IoC自动选择bean 进行注入

- byName ：通过名称装载

  > 按照名字进行装载，没有为null

  ```xml
  <!--传统装载-->
  <bean id="student" class="com.item.Student" >
      <property name="id" value="1" />
      <property name="name" value="张三" />
      <property name="age" value="12" />
      <property name="classes" ref="classes" />
  </bean>
  <!--自动装载-->
  <bean id="student2" class="com.item.Student" autowire="byName">
      <property name="id" value="1" />
      <property name="name" value="张三" />
      <property name="age" value="12" />
   </bean>
  ```

- byType ： 通过类型装载

> 多个同类型，抛出异常，不知装载那个.