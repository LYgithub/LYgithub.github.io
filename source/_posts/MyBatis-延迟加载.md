---

title: 延迟加载
data: 2020-6-22 10:30:21
tags: MyBatis

---

> 本文主要总结了 `Mybatis` 的数据库延迟加载问题，将多表查询的 SQL 语句进行拆分，根据需要进行相应的查询操作。

<!-- more -->

### assocation 延迟加载

> assocation实现一对一延迟加载

将级联操作 转换为两部，通过两次查询方式进行获取数据。

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





## 缓存

### 一级缓存

### 二级缓存

### 三级缓存