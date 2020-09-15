---
title: SSM-CRUD总结
categories: SSM
tags:
  - SSM
abbrlink: 20ec3355
date: 2020-08-07 14:38:55
---

> 本文对 SSM 整合的项目总结

<!-- more -->

# 整体框架

## 开发技术

> Maven 项目管理

![](https://gitee.com/KawYang/image/raw/master/img/20200807182752.png)

# $\color{red}{Error}$整理

## 发布Error

> 服务器环境 Window Server 2012R2

### URL 路径错误

#### 静态文件

> - 相对路径: 不可以确定唯一资源 ,
>   -  **不** 以`/ 或 ./`开头。 **可以不写** , 以本文件路径为准
> - 绝对路径:确定唯一资源,找到当前路径和目标资源之间的`相对关系`
>   - / 开始，以 服务器 路径为准

- 文件加载使用绝对路径

```jsp
<!-- 获得站点的根路径 -->
<% pageContext.setAttribute("APP_PATH",request.getContextPath()); %>
<!-- 绝对路径 -->
<script src="${APP_PATH}/static/updateEmp.js" ></script>
<!-- 相对路径 -->
<script src="static/updateEmp.js" ></script>
```

---

**pageContext.setAttribute 不提示**

- 添加`jsp-api`依赖

```xml
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>jsp-api</artifactId>
    <version>2.0</version>
</dependency>
```

#### 请求的URL

> IDEA 运行的路径为 `/` , 当发布到服务器时，URL的根路径为项目`Tomcat\webapps`下的文件名，如果直接采用 `localhost:8080/add..`的方式进行访问会出现 404 错误。

- 解决
1. 在 jsp 网页文件中，获取项目路径

```java
<% pageContext.setAttribute("APP_PATH",request.getContextPath()); %>
```

2. 使用 JavaScript 获取变量，当发送请求时，添加该 PATH 即可。

```jsp
<script type="text/javascript">
  var App_Path = "${APP_PATH}";
</script>
```

3. 在 JS 文件中，直接使用 App_Path 变量即可。[^资源]

### 数据库连接错误

> 在本地采用远程连接 MySQL 数据库的方式报 `serverTimezone` 错误。

```shell
8月 07, 2020 5:03:42 下午 com.mchange.v2.resourcepool.BasicResourcePool 
警告: com.mchange.v2.resourcepool.BasicResourcePool$ScatteredAcquireTask@1ecb3ad -- Acquisition Attempt Failed!!! Clearing pending acquires. While trying to acquire a needed new resource, we failed to succeed more than the maximum number of allowed acquisition attempts (30). Last acquisition attempt exception: 
java.sql.SQLException: The server time zone value '�й���׼ʱ��' is unrecognized or represents more than one time zone. You must configure either the server or JDBC driver (via the 'serverTimezone' configuration property) to use a more specifc time zone value if you want to utilize time zone support.
```

- 解决

  设置时区: 东八区设置为 `serverTimezone=GMT%2B8 ` 

  [参考链接](https://blog.csdn.net/love20yh/article/details/80799610)

### JS文件编码错误

> 访问网站时发现 使用 JS 文件加载的内容，中文乱码.

- 解决

  将 JS 文件编码改为 `UTF-8 with BOM` 







---

# 参考内容

[学习资源](https://www.bilibili.com/video/BV19t41197zi?p=1)

[^资源]:



