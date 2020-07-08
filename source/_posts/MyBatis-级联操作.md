---
title: MyBatis-级联操作
tags:
  - MyBatis
  - SQL
abbrlink: fb315360
date: 2020-06-21 09:30:21
categories: 框架
---

> 本文介绍了`MyBatis`的级联操作，通过查询多张表完成数据的获取，关键在于练习 `resultMap`、`association`、`collection` 标签。


<!-- more -->


# MyBatis 级联操作

[详细教程网络资源](http://c.biancheng.net/view/4367.html)


[项目](https://github.com/LYgithub/IDEAProjects/tree/master/MyBatisNodeDemo2)

## 一对一 (student -> class)

student 包含个人基本信息和内嵌对象 classes。
在查询student时，需要联合 student表和classes表进行查询。

### 数据表


```sql
CREATE TABLE classes(
    id int not null primary key,
    name varchar(20)
);

insert into classes (id,name) values (1,"一班"),(2,"二班"),(3,"三班");

CREATE TABLE student(
    id int not null primary key auto_increment,
    name varchar(10),
    cid int,
    foreign key (cid) references classes(id)
);

insert into student (id, name, cid) 
	values (1,"KawYang",1),(2,"KawYang",2),(3,"张三",2),(4,"李四",3),(5,"Tom",3),(6,"Jary",3);

```

### 实体类

- Classes类对象

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Classes{
	private int id;
	private String name;
}
```

- Student类对象

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Student{
	private int id;
	private String name;
	private Classes classes;
}

```

### Repository

编写数据库操作的接口


```java
public interface IStudentRepository {
    /**
     * find by id
     * @param id
     * @return student
     */
    Student findById(int id);

    /**
     * find all
     * @return student list
     */
    List<Student> findAll();
}
```

### Mapper

mapper🏷️ : `namespace` 属性映射到 `student` 的操作接口。
resultMap🏷️ : 配置类对象 --> 在 `select` 标签中，使用 `resultMap` 属性进行映射。
association🏷️ : 注入内嵌对象，`javaType` 将内嵌对象映射到实体类。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.kawyang.repository.IStudentRepository">
    
    <resultMap id="student" type="com.kawyang.entity.Student">
        <id property="id" column="sid"/>
        <result property="name" column="sname" />
        <association property="classes" ofType="com.kawyang.entity.Classes">
            <id property="id" column="cid" />
            <result property="name" column="cname" />
        </association>
    </resultMap>

    <select id="findById" resultMap="student" parameterType="int">
        select s.id as sid,s.name as sname, c.id as cid, c.name as cname
        from student s,classes c
        where s.cid=c.id and s.id=#{id}
    </select>

    <select id="findAll" resultMap="student">
        select s.id as sid,s.name as sname, c.id as cid, c.name as cname
        from student s,classes c
        where s.cid=c.id
    </select>
</mapper>

```


## 一对多 (class -> studentes)

一个班级含有多个👨‍🎓，通过查询班级信息，能够将班级中的所有学生信息查询出来
需要联合 classes类和student进行查询。

### 数据表

同上

### 实体类

- ClassesStu
```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ClassesStu{
	int id;
	String name;
	List<Student> students;
}

```

### Repository

```java
public interface IClassesStuRepository {
    /**
     * find classesStu by id
     * @param id key
     * @return classesStu
     */
    ClassesStu findById(int id);

    /**
     * find all classesStu
     * @return classesStu list
     */
    List<ClassesStu> findAll();
}
```

### Mapper

配置文件resultMap

```xml
    <resultMap id="classesStu" type="com.kawyang.entity.ClassesStu">
        <id property="id" column="cid" />
        <result property="name" column="cname" />
        <collection property="students" ofType="com.kawyang.entity.Student" >
            <id property="id" column="sid" />
            <result property="name" column="sname" />
        </collection>
    </resultMap>
```

collection🏷️ : 将查询的 `cid & cname` 相同的结果，将 sid 和 sname 封装成 `ofType` 指定类型的对象，并将多个对象以集合的方式返回。

```shell
==>  Preparing: select c.id as cid, c.name as cname, s.id as sid, s.name as sname from student s, classes c where c.id=s.cid
==> Parameters: 
<==    Columns: cid, cname, sid, sname
<==        Row: 1, 一班, 1, KawYang
<==        Row: 2, 二班, 2, KawYang
<==        Row: 2, 二班, 3, 张三
<==        Row: 3, 三班, 4, 李四
<==        Row: 3, 三班, 5, Tom
<==        Row: 3, 三班, 6, Jary
<==      Total: 6
```

## 多对多 (goods <-> consumers)

	一种商品可以被多个消费者购买
	一个消费者可以购买多个商品
	商品与消费者事多对多的关系。

### 数据表

good : 商品信息表
consumer : 消费者信息表
con_good : 中间表

```sql
CREATE TABLE good(
    id int primary key not null ,
    name varchar(30)
);

insert into good (id, name) VALUES (1,"电视"),(2, "电冰箱"),(3, "洗衣机"),(4,"笔记本");

CREATE TABLE consumer(
    id int primary key not null,
    name varchar(30)
);

insert into consumer (id, name) VALUES  (1,"KawYang"),(2,"李四"),(3,"张三");

CREATE TABLE con_good(
    id int primary key not null ,
    gid int,
    cid int,
    foreign key (gid) references good(id),
    foreign key (cid) references consumer(id)
);

insert into con_good (id, gid, cid) VALUES (1,1,1),(2,3,2),(3,1,3),(4,2,1),(5,4,2),(6,3,3);

```

### Mapper

	多对多相当于两个一对多的关系，需要配置两个xml文件

- IGoodMapper
```xml
<mapper namespace="com.kawyang.repository.IGoodRepository">
    <resultMap id="good" type="com.kawyang.entity.Good">
        <id property="id" column="gid"/>
        <result property="name" column="gname" />
        <collection property="consumers" ofType="com.kawyang.entity.Consumer">
            <id property="id" column="cid" />
            <result property="name" column="cname" />
        </collection>
    </resultMap>

    <select id="findAll" resultMap="good" >
        select g.id as gid,g.name as gname, c.id as cid, c.name as cname
        from good g,consumer c,con_good m
        where g.id=m.gid and m.cid=c.id
    </select>

    <select id="findById" resultMap="good" parameterType="int">
        select c.id as cid,c.name as cname,g.id as gid,g.name as gname
        from Good as g,Consumer as c, Con_good m
        where c.id = m.cid and g.id=m.gid and g.id=#{id}
    </select>
</mapper>
```

- IConsumerMapper
```xml
<mapper namespace="com.kawyang.repository.IConsumerRepository">
    <resultMap id="consumer" type="com.kawyang.entity.Consumer" >
        <id column="id" property="id" />
        <result column="name" property="name" />
        <collection property="goods" ofType="com.kawyang.entity.Good" >
            <id column="gid" property="id" />
            <result column="gname" property="name" />
        </collection>
    </resultMap>

    <select id="findAll" resultMap="consumer" >
        select c.id as id,c.name as name,g.id as gid,g.name as gname
        from Good as g,Consumer as c, Con_good m
        where c.id = m.cid and g.id=m.gid;
    </select>

    <select id="findById" resultMap="consumer" parameterType="int">
        select c.id as id,c.name as name,g.id as gid,g.name as gname
        from Good as g,Consumer as c, Con_good m
        where c.id = m.cid and g.id=m.gid and g.id=#{id}
    </select>
</mapper>

```






