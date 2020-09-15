---
abbrlink: ffb50895
title: Hibernate

---



> ORM 框架



<!-- more -->

## 操作

1. 创建 Maven 项目
2. 导入相关依赖

- hibernate-core
- mysql-connector-java
- jaxb-api
- jaxb-impl
- jaxb-core
- junit-jupiter
- c3p0 》c3p0
- lombok

3.  创建 hibernate.cfg.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE hibernate-configuration PUBLIC
        "-//Hibernate/Hibernate Configuration DTD 3.0//EN"
        "http://www.hibernate.org/dtd/hibernate-configuration-3.0.dtd">

<hibernate-configuration>
    <session-factory>
    </session-factory>
</hibernate-configuration>
```

3. 创建 JavaBean 及 classMapper.hbm.xml

```xml
<!DOCTYPE hibernate-mapping PUBLIC "-//Hibernate/Hibernate Mapping DTD 3.0//EN"
        "http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">
<hibernate-mapping package="com.kawyang.entity">
    <class table="Student" name="Student">
        <id name="id" column="id" type="int" >
            <!-- 由 数据库设置 主键的生成方式 -->
            <generator class="native"></generator>
        </id>
        <property name="name" column="name" type="java.lang.String" />
        <property name="age" column="age" type="int"/>
        <property name="birthday" column="birthday" type="date" />
    </class>
</hibernate-mapping>
```



3. 数据查询

