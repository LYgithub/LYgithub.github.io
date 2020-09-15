---
abbrlink: bae4ff13

---


# Redis(Remote Dictionary Server)

> Key - Value  的非关系型数据库，C语言编写的，提供多种持久化机制，基于内存的存储的，提供了主从，哨兵以及集群的搭建方式，更加方便的横向和垂直拓展。



<!-- more -->

## 目标

> 1. Redis基于内存存储数据和读取数据 => 提高存储速度
> 2. 将Session共享数据存放在 Redis中 => 多服务器存储共享
> 3. Redis接收用户请求是单线程的 => 解决多服务器锁不能互斥的问题

NoSQL => 非关系型数据库 => Not Only SQL

