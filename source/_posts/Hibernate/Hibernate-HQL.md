---
title: Hibernate-HQL(Hibernate Query Language)
categories: 文章类型
abbrlink: 387c2947
date: 2020-08-22 17:57:05
tags:
---

> 面向对象的数据查询,直接使用实体类的属性实现查询。

<!-- more -->

## 格式

> 将表格信息修改为 JavaBean 信息

- SQL

```sql
select  <cloums> from <table-name> where <id> = ?
```

- HQL

```sql
select <class.属性> from <class-name>  as s where <s.属性>=?
```

## 简单使用

```java
// 1. 创建 session 对象
Configuration configuration = new Configuration().configure();
SessionFactory sessionFactory = configuration.buildSessionFactory();
Session session = sessionFactory.openSession();
// 2. 创建查询对象
Query query = session.createQuery(hql);
// 3. 执行查询方法，获取数据
List<Student> list = query.list();
```

## 查询

### from

```sql
  from Student // 从 Student 关联的 数据表进行查询 
  ```

```sql
  from Student as s // 表格取别名
  ```

```sql
  from Student s //省略 as
```

### select

```sql
  select s from Student as s // 查询全部信息
  ```

```sql
  select s.id, s.name from Student as s // 查询相应属性
  ```

```sql
  select new Student(s.id,s.name) from Student s// 将数据封装成对象,必须有相应的构造函数
  ```

### where & 不同参数的设置形式

```sql
  where s.age between 18 and 20
  ```

```sql
  where s.age between  :ageMin and :ageMax
  ```

  > 使用 `:name ` 的形式 设置HQL 中参数
  >
  > 运用 query.setParameter("name", value); 的方式设置变量的值

```sql
  where s.age between  ? and ?
  ```

  > 使用 `?` 的形式设置 参数
  >
  > 则运用  query.setParameter(index, value); 的形式设置变量的值，下标从 0 开始

```sql
  where s.age in (:ids)
  ```

  

  > query.setParameterList("ids", int []{1,2,3,4,4}); 设置集合参数

### 统计函数

> min(), max(), avg(), count(),

```sql
  select count( * ) from Strudent
  ```

```sql
  select min(s.id) from Student s
  ```

### order by

> - asc 升序 (默认)
> - desc 降序

```sql
  where s.age> 20 order by s.name desc
  ```

  

### 连接查询

> - 内连接 inner (**inner join**) - inner 可以省略
> - 外连接 outer (**outer join , left outer join , right outer join **) - outer 可以省略

```sql
  select s.name , d.name from Student s [inner] join s.classes d;
  ```

```sql
  select s.name , d.name from Student s left [outer] join s.classes d;
  ```

### distinct 过滤掉重复值

```sql
  select distinct s.age from Student s 
  ```

## Query使用

- creatQuery(HQL);
- list() : 返回List 查询结果
- setMaxResults() ： 返回最大记录书
- setParameterList()
- uniqueResult() ： 返回Object 类，当查询结果只有一个时
- excuteUpdate() : 执行 update 和 delete 语句。

### 分页查询

- setFirstResult() : 起始位置，从 0 开始
- setMaxResults() ： 每页记录数

```java
Query query = session.creatQuery("from Student s order by s.id");
query.setFirstResult((pageNum -1) * pageSize);
```



