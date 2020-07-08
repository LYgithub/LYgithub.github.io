---
title: Spring-工厂方法
categories: 框架
abbrlink: 6c92115f
tags: Spring
date: 2020-07-08 16:40:37
---

> 📝 : Spring的工厂方法，将🏭 交给 `IoC容器` 进行管理，🏭包括：静态🏭、实例🏭。


<!-- more -->

## Spring 的工厂方法

> 使用工厂创建独享，并将工厂交给 IoC容器 进行管理

### 静态工厂

- 实体类

```java
package com.item;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Car {
    Long id;
    String name;
}
```

- 静态工厂

```java
package com.item.factory;

import com.item.Car;

import java.util.HashMap;
import java.util.Map;

public class CarFactory {
    static Map<Long, Car> carMap;
    static {
        carMap = new HashMap<Long, Car>();
        carMap.put(1L, new Car(1L, "宝马"));
        carMap.put(2L, new Car(2L, "奔驰"));
    }

    public static Car getCar(Long id, String s){
        System.out.println(s);
        return carMap.get(id);
    }

}
```

- 配置工厂

> 将类使用bean🏷️配置到工厂的方法中，IoC容器使用配置的方法，根据传递的参数来获取对象。

配置参数 : index (0开始、形参位置)、name(形参名称)

```xml
<!--配置静态工厂 默认为单例模式-->
<bean id="car" class="com.item.factory.CarFactory" factory-method="getCar" scope="prototype">
    <!--配置参数 getCar-->
    <constructor-arg index="0" value="2" />
    <constructor-arg name="s" value="String" />
</bean>
```

- 获取IoC容器中对象

```java
public static void main(String[] args) {
    try {
        ApplicationContext context = new ClassPathXmlApplicationContext("config-factory.xml");
        Car car =(Car) context.getBean("car");
        System.out.println(car);
    } catch (Exception e) {
        e.printStackTrace();
    }
}
```

### 实例工厂

- 工厂类

同上

- 配置文件

> 在配置文件中配置两个 bean (🏭bean、获取Car的bean)，将🏭类先交给 IoC容器管理，然后再配置Car，调用容器中🏭创建对象的方法。

```xml
<!--配置工厂 bean-->
<bean id="factory" class="com.item.factory.InstanceCarFactory" />
<!--配置对象 Car  使用工厂 factory获取  -->
<bean id="car2" factory-bean="factory" factory-method="getCar">
    <constructor-arg name="id" value="2" />
</bean>
```

- 使用

```java
public static void main(String[] args) {
    InstanceCarFactory factory = new InstanceCarFactory();
    System.out.println(factory.getCar(1L));

    ApplicationContext context = new ClassPathXmlApplicationContext("config-factory.xml");
    Car car2 = (Car) context.getBean("car2");
    System.out.println(car2);

}
```



