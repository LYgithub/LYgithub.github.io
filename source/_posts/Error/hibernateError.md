---
abbrlink: 53f99461
tags:
	- JavaEE
categories: JavaWeb

---
# Hibernater Error

<!-- more -->

## javax/xml/bind/JAXBException

> 缺少相关依赖

## 没有提供链接

```shell
WARN: HHH000181: No appropriate connection provider encountered, assuming application will be supplying connections
8月 21, 2020 10:58:46 上午 org.hibernate.engine.jdbc.env.internal.JdbcEnvironmentInitiator initiateService
WARN: HHH000342: Could not obtain connection to query metadata : The application must supply JDBC connections
```

> 原因：Configuration configuration = new Configuration(); 没有调用`configure()`方法获取配置文件
>
> 修改：Configuration configuration = new Configuration().configure(); 



## 配置文件版本

```sh
WARN: HHH90000012: Recognized obsolete hibernate namespace http://hibernate.sourceforge.net/hibernate-configuration. Use namespace http://www.hibernate.org/dtd/hibernate-configuration instead.  Support for obsolete DTD/XSD namespaces may be removed at any time.

WARN: HHH90000012: Recognized obsolete hibernate namespace http://hibernate.sourceforge.net/hibernate-mapping. Use namespace http://www.hibernate.org/dtd/hibernate-mapping instead.  Support for obsolete DTD/XSD namespaces may be removed at any time.
```

> 提示 使用`Use namespace http://www.hibernate.org/dtd/hibernate-configuration` 替换`http://hibernate.sourceforge.net/hibernate-configuration`
>
> 使用：  `http://www.hibernate.org/dtd/hibernate-mapping` 替换 `http://hibernate.sourceforge.net/hibernate-mapping. `

## java.lang.NoClassDefFoundError: com/sun/xml/bind/v2/model/annotation/AnnotationReader

## org.hibernate.internal.util.config.ConfigurationException: Unable to perform unmarshalling at line number 0 and column 0 in RESOURCE hibernate.cfg.xml. Message: null

>  缺少依赖

## Hibernate 依赖

- hibernate-core
- Mysql-connection-java
- jaxb-api
- jaxb-impl
- jab-core
- activation

```xml
<dependency>
  <groupId>org.hibernate</groupId>
  <artifactId>hibernate-core</artifactId>
  <version>5.3.7.Final</version>
</dependency>

<dependency>
  <groupId>mysql</groupId>
  <artifactId>mysql-connector-java</artifactId>
  <version>8.0.20</version>
</dependency>

<dependency>
  <groupId>javax.xml.bind</groupId>
  <artifactId>jaxb-api</artifactId>
  <version>2.3.0</version>
</dependency>

<dependency>
  <groupId>com.sun.xml.bind</groupId>
  <artifactId>jaxb-impl</artifactId>
  <version>2.3.0</version>
</dependency>

<dependency>
  <groupId>com.sun.xml.bind</groupId>
  <artifactId>jaxb-core</artifactId>
  <version>2.3.0</version>
</dependency>

<dependency>
  <groupId>javax.activation</groupId>
  <artifactId>activation</artifactId>
  <version>1.1.1</version>
</dependency>
```

## xml文件引用

### hinernate.cfg.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE hibernate-configuration PUBLIC
        "-//Hibernate/Hibernate Configuration DTD 3.0//EN"
        "http://www.hibernate.org/dtd/hibernate-configuration-3.0.dtd">

<hibernate-configuration>
    <session-factory>
        <property></property>
    </session-factory>
</hibernate-configuration>
```

### mapper.hbm.xml

```xml
<!DOCTYPE hibernate-mapping PUBLIC "-//Hibernate/Hibernate Mapping DTD 3.0//EN"
        "http://www.hibernate.org/dtd/hibernate-mapping-3.0.dtd">
<hibernate-mapping package="kawyang.entity">
	<class>
	</class>
</hibernate-mapping>
```

