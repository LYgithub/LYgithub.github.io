---
title: MyBatis-数据缓存
tags:
  - MyBatis
  - 缓存
abbrlink: 579a3ded
categories: 框架
date: 2020-07-06 16:08:04
---

> 将查询过的数据进行缓存，可以减少数据库访问的次数，减轻负担服务器的，同时也可以提高数据访问时间。

<!-- more -->

## 一级缓存

> 一级缓存是 SqlSession 级别的缓存，只要 SqlSession 没有被 close 或 flush ，就会存在。

- 当执行两次相同的查询时，MyBatis 会将第一次查询的结果保存到缓存中，再次运行查询代码，就不需要执行SQL 语句，直接从缓存中获取数据。

- 当调用 SqlSession 对数据进行 修改、插入、删除、commit()、close() 等就会清空一级缓存。以保证缓存中数据为最新数据，避免脏读。
- 一级缓存清空：
	- 调用 SqlSession对象的 `clearCache()` 方法
	- close()
	- commit()


## 二级缓存

> 二级缓存是 `Mapper` 映射级别的缓存，多个 SqlSession 对象，操作同一个 Mapper 映射的 SQL ，公用一个缓存对象。

### 使用步骤

#### 引入坐标

```xml
<!-- ehchache 缓存  -->
<dependency>
    <groupId>net.sf.ehcache</groupId>
    <artifactId>ehcache</artifactId>
    <version>2.8.3</version>
</dependency>
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis-ehcache</artifactId>
    <version>1.0.0</version>
</dependency>
```

#### 开启缓存

在 MyBatis的配置文件中(config.xml)，使用 settings 标签下 的 setting 标签 开启缓存。

```xml
<settings>
        <!--  打印SQL  -->
        <setting name="logImpl" value="STDOUT_LOGGING"/>
        <!--  开启延迟加载  -->
        <setting name="lazyLoadingEnabled" value="true"/>
        <!--  开启二级缓存  -->
        <setting name="cacheEnabled" value="true"/>
    </settings>
```

#### 配置Mapper

```xml
<mapper namespace="...">
	<cache></cache>
	<cache type="org.mybatis.caches.ehcache.LoggingEhcache" >
		<!--   创建缓存之后，对吼一次访问缓存的时间值缓存失效的时间间隔  -->
	    <property name="timeToIdleSeconds" value="3600"/><!--1 hour-->
		<!--   缓存自创建时间起至失效的时间间隔  -->
	    <property name="timeToLiveSeconds" value="3600"/><!--1 hour-->
		<!--        -->
	    <property name="maxEntriesLocalHeap" value="1000"/>
	    <property name="maxEntriesLocalDisk" value="10000000"/>
		<!--   缓存回收策略，移除-近期使用最少的对象 -->
	    <property name="memoryStoreEvictionPolicy" value="LRU"/>
	</cache>
</mapper>
```


#### 配置 useCache 属性

> 如果每次查询都需要最新的数据，需要将 select🏷️ 中的 `useCache` 属性设置为 `false`, 禁用二级缓存。

```xml
<select id="findAll" resultType="com.item.entity.Student" useCache="false">
    select id,name from student 
</select>
```

#### 测试

> 步骤

使用`同一个`Mapper映射，创建两个`不同`的 SqlSession 对象，分别执行`相同` 的SQL操作

if : 执行一次 SQL 语句
	二级缓存成功！
else :
	二级缓存失败！

```java
public class FindCache {
    public static void main(String[] args) {
        InputStream resourceAsStream = FindCache.class.getClassLoader().getResourceAsStream("config.xml");
        SqlSessionFactoryBuilder builder = new SqlSessionFactoryBuilder();
        SqlSessionFactory build = builder.build(resourceAsStream);
        SqlSession sqlSession = build.openSession();
        IGoodRepository mapper = sqlSession.getMapper(IGoodRepository.class);
        Good goodById = mapper.findGoodById(2);
        System.out.println(goodById.toString());
        //关闭一级缓存
        sqlSession.close();

        SqlSession sqlSession1 = build.openSession();
        IGoodRepository mapper1 = sqlSession1.getMapper(IGoodRepository.class);
        Good goodById1 = mapper1.findGoodById(2);
        System.out.println(goodById1);
    }
}
```

结果:

```shell
Cache Hit Ratio [com.kawyang.repository.IGoodRepository]: 0.0
Opening JDBC Connection
Created connection 392918519.
Setting autocommit to false on JDBC Connection [com.mysql.cj.jdbc.ConnectionImpl@176b75f7]
==>  Preparing: select * from good where id=?
==> Parameters: 2(Integer)
<==    Columns: id, name
<==        Row: 2, 电冰箱
<==      Total: 1
Good(id=2, name=电冰箱, consumers=null)
Resetting autocommit to true on JDBC Connection [com.mysql.cj.jdbc.ConnectionImpl@176b75f7]
Closing JDBC Connection [com.mysql.cj.jdbc.ConnectionImpl@176b75f7]
Returned connection 392918519 to pool.
Cache Hit Ratio [com.kawyang.repository.IGoodRepository]: 0.5
Good(id=2, name=电冰箱, consumers=null)
```

> 一下具体内容及原因，有待进一步了解学习。

⚠️ : 如果使用 sqlSession.clearCache(); 清除缓存，但依然缓存着其他 SqlSession 对象的缓存数据。

如下测试：

```java
public class FindCache {
    public static void main(String[] args) {
        InputStream resourceAsStream = FindCache.class.getClassLoader().getResourceAsStream("config.xml");
        SqlSessionFactoryBuilder builder = new SqlSessionFactoryBuilder();
        SqlSessionFactory build = builder.build(resourceAsStream);
        SqlSession sqlSession = build.openSession();
        IGoodRepository mapper = sqlSession.getMapper(IGoodRepository.class);
        Good goodById = mapper.findGoodById(2);
        System.out.println(goodById.toString());

        SqlSession sqlSession1 = build.openSession();
        IGoodRepository mapper1 = sqlSession1.getMapper(IGoodRepository.class);
        Good goodById1 = mapper1.findGoodById(2);
        System.out.println(goodById1.toString());

        //关闭一级缓存
        sqlSession.clearCache();
        System.out.println("====    🆑 sqlSession缓存    ====");
        System.out.println(sqlSession1.getMapper(IGoodRepository.class).findGoodById(2));
    }
}
```

结果:

```
Opening JDBC Connection
Created connection 392918519.
Setting autocommit to false on JDBC Connection [com.mysql.cj.jdbc.ConnectionImpl@176b75f7]
==>  Preparing: select * from good where id=?
==> Parameters: 2(Integer)
<==    Columns: id, name
<==        Row: 2, 电冰箱
<==      Total: 1
Good(id=2, name=电冰箱, consumers=null)
Cache Hit Ratio [com.kawyang.repository.IGoodRepository]: 0.0
Opening JDBC Connection
Created connection 1804126860.
Setting autocommit to false on JDBC Connection [com.mysql.cj.jdbc.ConnectionImpl@6b88ca8c]
==>  Preparing: select * from good where id=?
==> Parameters: 2(Integer)
<==    Columns: id, name
<==        Row: 2, 电冰箱
<==      Total: 1
Good(id=2, name=电冰箱, consumers=null)
====    🆑 sqlSession缓存    ====
Cache Hit Ratio [com.kawyang.repository.IGoodRepository]: 0.0
Good(id=2, name=电冰箱, consumers=null)
```
