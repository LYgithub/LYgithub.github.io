---
title: MyBatis-延迟加载
tags:
  - MyBatis
  - SQL
abbrlink: 70e7f4d8
categories: 框架
date: 2020-06-22 10:30:21
---

> 本文主要总结了 `Mybatis` 的数据库延迟加载问题，将多表查询的 SQL 语句进行拆分，根据需要进行相应的查询操作。

<!-- more -->

### assocation 延迟加载

> assocation实现一对一延迟加载

将级联操作 转换为两条SQL语句，通过两次查询方式进行获取数据。

含有 注入对象的对象查询，当查询结果不涉及注入对象信息时，不进行内嵌对象的查询。

```xml
<!--  延迟加载  -->
<resultMap id="resultStuLazy" type="com.item.entity.Student" >
    <id column="id" property="id" />
    <result column="name" property="name" />
    <!-- 添加select 属性 -->
    <association property="classes" javaType="com.item.entity.Classes_"
                 select="com.item.repository.IClasses.findById"
                 column="cid">
    </association>
</resultMap>

<select id="findById" resultMap="resultStuLazy">
    select id,name,cid from student where id=#{id}
</select>
```


> 在全局配置文件中开启延迟加载


```xml
<settings>
    <setting name="lazyLoadingEnabled" value="true"/> 
    <setting name="aggressiveLazyLoading" value="false"/>
</settings>
```
[name 参数参考](https://www.jianshu.com/p/6f5b42d52d38)


### Collection 延迟加载

> Collection 实现一对多延迟加载。

在查询班级信息时，如果需要查询班级内所有👨‍🎓信息，需要进行级联操作。
可以将该操作分为两步：

- 先根据🆔查询出班级信息 => select * from classes where id=?
- 再根据👩‍🎓的班级🆔，查询出班级内所有👨‍🎓 => select * from student where cid=?

> 查询班级信息

采用配置文件的方式，用 `collection` 配置第二步的操作，使用 `ofType` 属性，完成数据类型的指定。
如下：
```xml
    <!--  延迟加载start  -->
    <resultMap id="classLazy" type="com.kawyang.entity.ClassesStu">
        <id property="id" column="id" />
        <result property="name" column="name" />
        <collection property="students" ofType="com.kawyang.entity.Student"
                    select="com.kawyang.repository.IStudentRepository.findByCid"
                    column="id" />
    </resultMap>

    <select id="findByIdLazy" resultMap="classLazy" parameterType="int">
        select * from classes where id=#{id}
    </select>
    <!--  延迟加载end  -->
```

> 根据班级 🆔 查询所有👩‍🎓👨‍🎓，使用注解方式如下：


```java
/**
 *
 * @param id
 * @return
 */
@Select("select * from student where cid=#{id}")
List<Student> findByCid(int id);
```

### 测试

```java
IStudentRepository mapper = MapperUtil.getMapper("config.xml", IStudentRepository.class);
Student byIdLazy = mapper.findByIdLazy(2);
//通过 🆔 查询学生信息，只需要获取 name 属性，不需要进行第二步操作。
System.out.println(byIdLazy.getName());
System.out.println("------------");
//需要获取班级的名称，需要进行两次查询操作。
System.out.println(byIdLazy.getClasses().getName());

System.out.println("============");

IClassRepository mapper1 = MapperUtil.getMapper("config.xml", IClassRepository.class);
ClassesStu byIdLazy1 = mapper1.findByIdLazy(2);
//通过 🆔 查询本季信息，只需要获取 name 属性，不需要进行第二步操作。
System.out.println(byIdLazy1.getName());
System.out.println("------------");
//需要获取班级所有👩‍🎓👨‍🎓信息，需要进行两次查询操作。
System.out.println(byIdLazy1.getStudents());
```

> 运行结果

```shell
Opening JDBC Connection
Created connection 1267149311.
Setting autocommit to false on JDBC Connection [com.mysql.cj.jdbc.ConnectionImpl@4b8729ff]
==>  Preparing: select * from student where id=?
==> Parameters: 2(Integer)
<==    Columns: id, name, cid
<==        Row: 2, KawYang, 2
<==      Total: 1
KawYang
------------
==>  Preparing: select * from classes where id=?
==> Parameters: 2(Integer)
<==    Columns: id, name
<==        Row: 2, 二班
<==      Total: 1
二班

============

Opening JDBC Connection
Created connection 1414549197.
Setting autocommit to false on JDBC Connection [com.mysql.cj.jdbc.ConnectionImpl@54504ecd]
==>  Preparing: select * from classes where id=?
==> Parameters: 2(Integer)
<==    Columns: id, name
<==        Row: 2, 二班
<==      Total: 1
二班
------------
==>  Preparing: select * from student where cid=?
==> Parameters: 2(Integer)
<==    Columns: id, name, cid
<==        Row: 2, KawYang, 2
<==        Row: 3, 张三, 2
<==      Total: 2
[Student(id=2, name=KawYang, classes=null), Student(id=3, name=张三, classes=null)]

Process finished with exit code 0

```

⚠️ : 由于 MyBatis 默认开启一级缓存，所以在第二步查询时，只执行了第二条SQL语句。
