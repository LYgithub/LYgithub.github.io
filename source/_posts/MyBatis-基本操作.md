---
title: MyBatis-基本操作
tags: MyBatis
abbrlink: 8661f06f
categories: 框架
date: 2020-06-20 16:47:42
---

> MyBatis 是一款优秀的半自动的轻量级的持久层框架。本文介绍了 `MyBatis` 的基本项目的创建和使用。

<!-- more -->

## 创建Maven项目

## pom.xml 导入相关依赖

- org.mybatis -> mybatis
- mysql-connection-java -> mysql
- org.projectlombok -> lombok
- log4j -> log4j

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>org.example</groupId>
    <artifactId>MyBatis</artifactId>
    <version>1.0-SNAPSHOT</version>


    <dependencies>

        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis</artifactId>
            <version>3.5.5</version>
        </dependency>

        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>8.0.20</version>
        </dependency>

        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>1.18.12</version>
        </dependency>

        <dependency>
            <groupId>log4j</groupId>
            <artifactId>log4j</artifactId>
            <version>1.2.17</version>
        </dependency>

    </dependencies>

</project>
```

-  **配置 `mapper` 读取位置** ，解决Mapper配置文件读取不到的关键
```xml
<build>
    <resources>
        <resource>
            <directory>src/main/java</directory>
            <includes>
                <include>**/*.xml</include>
            </includes>
        </resource>
    </resources>
</build>
```


> resources/config.xml

通过 `config.xml` 进行数据库的配置和相关Mapper的导入。

- 约束

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
    <configuration>
    	<!-- SQL配置 -->
    	<!-- 连接配置 -->
    	<!-- 注册Mapper -->
    </configuration>
```
- SQL 的相关配置

```xml
<settings>
	<!-- 打印SQL语句 -->
	<setting name="logImpl" value="STDOUT_LOGGING" />
</settings>
```

- 连接配置

```xml
<environments default="mysql">
    <environment id="mysql">
        <transactionManager type="JDBC" />
        <dataSource type="POOLED">
            <property name="driver" value="com.mysql.cj.jdbc.Driver"/>
            <property name="username" value="root"/>
            <property name="password" value="root"/>
            <property name="url" value="jdbc:mysql://localhost:3306/JavaWeb?userSSL=false&amp;allowPublicKeyRetrieval=true"/>
        </dataSource>
    </environment>
</environments>
```

- 注册Mapper

 ```xml
 <mappers>
    <!-- 注解形式注册 -->
    <mapper class="com.kawyang.repository.IClass" />
    <!-- 配置文件方式注册 -->
    <mapper resource="com/kawyang/mapper/IClassesMapper.xml" />
    <mapper resource="com/kawyang/mapper/IStudentMapper.xml" />
</mappers>
 ```

## entity

创建实体类对象。

lombok 会通过以下注解快速🔜完成设置  
			`@Data` : 自动添加 Get/Set 方法。  
			`@AllArgsConstructor` : 有参构造  
			`@NoArgsConstructor` : 无参构造  

- 配置文件形式

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Classes {

    private int id;
    private String name;
}
```


## repository 

> 编写数据库操作接口

- 配置文件形式

  通过配置文件形式，需要编写相应的 `Mapper` 配置文件，将接口中的方法与 数据库的操作进行映射。
  并且在 `config.xml` 中对配置文件 通过 mapper 🏷️的 `resource` 属性，完成注册。

```java
public interface IClasses {

    Classes findById(int id);

    List<Classes> findAll();

    int insertClass(Classes classes);

    int deleteById(int id);

    int updateClass(Classes classes);

    ClassesStudents findClassAndStudentById(int id);

    List<ClassesStudents> findAllClassAndStudent();
}
```

- 注解形式

通过一下注解，编写相应的SQL语句，完成接口方法与数据库操作的映射，不需要配置文件，在 `config.xml` 中，使用 mapper🏷️ 的  `class` 属性完成注册。

- @Insert(String sql) : 增
- @Delete(String sql) : 删
- @Update(String sql) : 改
- @Select(String sql) : 查

```java
public interface IClasses {

	@Select("select * from classes where id=#{id}")
    Classes findById(int id);

    @Select("select * from classes")
    List<Classes> findAll();

    @Insert("insert into classes (id,name) values (#{id},#{name})")
    int insertClass(Classes classes);

    @Delete("delete from classes where id=#{id}")
    int deleteById(int id);

    @Update("update from classes set name=#{name} where id=#{id}")
    int updateClass(Classes classes);
}
```



## mapper

com.mapper.IClassesMapper

编写数据库操作的Mapper文件，完成方法与查询语句的映射。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper>
	<select >..</select>
	<delete >..</delete>
	<update >..</update>
	<insert >..</insert>
</mapper>
```

Mapper🏷️ 通过属性 `namespace` : 数据库操作接口的全路径  
数据库操作🏷️ :
- select
	- id : 映射接口的方法名
	- parameterType : 方法参数的类型
	- resultType : 返回值类型的全路径
- delete
	- id : 映射接口的方法名
	- parameterType : 方法参数的类型
	- 无返回值属性，返回值为 `int` 类型
- update
	- id : 映射接口的方法名
	- parameterType : 方法参数的类型
	- 无返回值属性，返回值为 `int` 类型
- insert
	- id : 映射接口的方法名
	- parameterType : 方法参数的类型

- resultMap:

通过 `resultMap` 进行含有内嵌对象类的配置。  

如：StudentClas 类，除了包含student的基本信息外，含有内嵌对象 classes，需要通过 resultMap 来完成数据的配置。

```xml
<resultMap id="StudentCla" type="com.kawyang.entity.StudentCla" >
    <id property="id" column="sid"/>
    <result property="name" column="sname" />
    <collection property="students" ofType="com.kawyang.model.Classes">
        <id property="id" column="cid"/>
        <result property="name" column="cname" />
    </collection>
</resultMap>

<select id="selectStudentClaById" resultMap="StudentCla" parameterType="ind">
	select s.id as sid, s.name as sname, c.id as cid, c.name as cname
	from student s,classes c 
	where s.cid=c.id and s.id=#{id}
</select> 
```
- resultMap🏷️ :   
	- id -> resultMap 的 id  
	- type -> 实体类类型  
- id 和 result🏷️ : 
    - id : 指定主键信息 
    - result : 指定非主键信息
	- property -> 类的属性名称  
	- column -> 查询结果的列名  
- collection🏷️：完成对象注入  
	- property -> 类的注入对象的名称  
	- ofType -> 注入对象的类型  

## Main

1. 读取配置文件
2. 创建SQLSession对象
3. 使用SQLSession对象，创建 相应操作的 mapper 对象
4. 使用 mapper 对象完成 数据库的操作

```java
public class Main{
	public static void main(String[] args) {
		// 1. 读取配置文件
		InputStream in = Main.class.getClassLoader().getResourceAsStream("config.xml");
		// 2. 创建SQLSession对象
		// 2.1 创建 SqlSession 工厂🏭类
		SqlSessionFactoryBuilder bulider = new SqlSessionFactoryBuilder();
		// 2.2 使用配置文件 完成🏭创建
		SqlSessionFactory bulid = bulider.build(in);
		// 2.3 使用🏭创建 SqlSession
		SqlSession session = build.openSession();
		// 3. 使用SQLSession对象，创建 相应操作的 mapper 对象
		IStudentCla mapper = session.getMapper(IStudentCla.class);
		// 4. 使用 mapper 对象完成 数据库的操作
		StudentCla student = mapper.findById(2);

		// 5. 提交事务  添加数据时使用
		session.commit();
        
		// 5. 关闭 SqlSession
		session.close();
		
	}
}
```




















