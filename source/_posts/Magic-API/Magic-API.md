## Magic-API 学习笔记

### 注解

- @Configuration
- [@ConditionalOnClass({DataSource.class,RequestMappingHandlerMapping.class})](https://blog.csdn.net/lbh199466/article/details/88303897)
- @AutoConfigureAfter({DataSourceAutoConfiguration.class})
- @EnableConfigurationProperties(MagicAPIProperties.class)
- @NestedConfigurationProperty
- [Spring Boot 之 spring.factories](https://www.cnblogs.com/huanghzm/p/12217630.html)

- [springboot之additional-spring-configuration-metadata.json自定义提示](https://blog.csdn.net/weixin_43367055/article/details/100174407)





### Swagger 使用

#### 1. pom 依赖

```xml
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger2</artifactId>
    <version>2.7.0</version>
    <scope>provided</scope>
</dependency>
```

#### 2.配置

```java

```









---

[ 博客园-Swagger介绍及使用](https://www.jianshu.com/p/349e130e40d5)

![image-20210326225548075](https://gitee.com/KawYang/image/raw/master/img/image-20210326225548075.png)

![image-20210326225615139](https://gitee.com/KawYang/image/raw/master/img/image-20210326225615139.png)

<img src="https://gitee.com/KawYang/image/raw/master/img/image-20210326230622476.png" alt="image-20210326230622476" style= />

![image-20210326231022339](https://gitee.com/KawYang/image/raw/master/img/image-20210326231022339.png)

