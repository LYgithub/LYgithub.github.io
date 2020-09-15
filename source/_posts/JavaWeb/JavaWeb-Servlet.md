---
title: JavaWeb-Servlet
categories: JavaWeb
tags:
  - Servlet
  - JavaWeb
abbrlink: 3dd30874
date: 2020-07-11 16:09:23
---

> Servlet 笔记

<!-- more -->

## B/S 浏览器/服务器

### 网络通信

1. IP
2. 端口
3. 传输协议
   1. 基本协议
      1. TCP：安全协议，三次握手，速度慢
      2. UDP：不安全，速度快

## C/S 客户端/服务器

---

## 服务器(Tomcat)

* 安装了服务器软件的计算机

* 服务器软件：接收请求，处理请求，做出响应

* web服务器软件

  * 在web服务器软件，部署项目，浏览器访问 （web容器）

    常见的Java相关web服务器：

    1. webLogic ： oracle

     2. webSphere ： IBM
 3. JBOSS ： JBOSS

 4. TomCat : Apache基金组织

     

### download

1. 下载

2. 解压

   * 安装路径无中文

3. 启动

   >  修改端口号：`conf/server.xml`

4. 关闭

   > `ctrl + c`

### 配置部署

1. 放到 `webapps`目录下

   > /hello : 虚拟目录/访问目录
   >
   > 简化部署：打包为 war包，自动解压和删除

2. 配置路径

   Server.xml -> TomCat的整体配置文件

   ```xml
   <Host>
   	<Context docBase="D:\\"  path="\"/>
   </Host>
   ```

3. 热部署

   /conf/Catalina/localhost

   下创建`xxx.xml` 文件

   

### 动态项目与静态项目

动态：

	-- 根目录
		-- WEB-INF 目录
			--classes : 字节码文件
			--lib ： jar包
			-- web.xml ： 配置

## Servlet ： server applet

> 一个接口
>
> 被浏览器访问到（TomCat识别）

### 快速入门

1. 创建JavaEE项目

2. 实现Servlet接口

   * Servlet接口 service 方法，提供服务

3. 实现抽象方法

4. 配置

   > Web.xml

```xml
    <servlet>
        <servlet-name>add_servlet</servlet-name>
        <servlet-class>com.servlet.AddServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>add_servlet</servlet-name>
        <url-pattern>/page/求和/hello</url-pattern>
    </servlet-mapping>
```



### 原理

![image-20200607181108630](https://gitee.com/KawYang/image/raw/master/img/image-20200607181108630.png)



### 示例

```java

```

## Servlet 方法

> 注意配置Servlet 

1. init ： 初始化方法 在Servlet创建时执行，只会执行一次

   * 何时创建

     * 默认第一次被访问

       ```xml
           <servlet>
               <servlet-name>Demo1</servlet-name>
               <servlet-class>com.KawYang.Servlet.Demo1Test</servlet-class>
       <!--        1. 第一次访问时 负数 -1
                   2. 服务器启动时 正数 0 或 1-->
               <load-on-startup>-1</load-on-startup>
           </servlet>
       ```

   * Servlet 是单例的

     * 多个用户访问`存在线程安全问题`
     * 解决：尽量不在Servlet定义成员变量，即使定义了成员变量，不要对其修改值

2. Service ： 提供服务的方法，每次Servlet被访问时执行

3. destroy ： 销毁方法，在Servlet`正常关闭`时执行

   * 服务器被关闭时执行
   * Servlet 结束之前

4. ServletConfig ： Servlet配置

5. getServletInfo : 获取版本，作者...

## Servlet 生命周期

创建 -> 提供服务 -> 被销毁

## Servlet 3.0

> 支持注解配置，不需要 xml

### 注解配置

配置资源路径

```java
@WebServlet(urlPatterns = "/Demo1") 
@WebServlet("/Demo1") //value 可以省略 
public class Demo1Test implements Servlet {
    @Override
    ...
}
```

## IDEA与Tomcat

1. IDEA会为 每个web项目创建一份配置文件

   ```shell
   08-Jun-2020 15:32:33.041 信息 [main] org.apache.catalina.startup.VersionLoggerListener.log CATALINA_BASE:         /Users/mac/Library/Caches/IntelliJIdea2019.3/tomcat/_Demo1
   ```

2. 工作空间项目 和 TomCat部署的文本项目

   1. 真正访问的是 `部署` 项目，对应**工作空间**下 web文件的所有内容
   2. WEB-INF 下文件**不能**被访问

3. 断点调试

   Debug 运行

## Servlet体系结构

Servlet (接口) -> GenericServlet (类)-> HttpServlet (类)

### GenericServlet

>  其他方法默认空实现，只将**Service**进行抽象

### HttpServlet

> 对Http协议 简化操作 和 Web的封装

![image-20200608160714672](https://gitee.com/KawYang/image/raw/master/img/image-20200608160714672.png)

1. 继承HttpServlet
2. 复写 `doGet、doPost`

### 配置

1. urlPatterns : 访问路径 可以定义多个，名为value 可以省略 
   1. /xx
   2. /xx/xx
      * 目录结构
      * /* 优先级最低
   3. **`* .do`**
      * 不能用**/**

---

# Http

## 特点

* 基于 TCP/IP 的高级协议

* 默认端口 80
* 基于请求响应模型的。一次请求对应一个响应
* 无状态协议：每次请求之间相互独立，不能交互数据

## 历史版本

1.0 ： 每次请求都建立新的连接

1.1：复用连接

## 请求消息数据格式

1. 请求行 ： 请求方式  请求url 请求协议/版本

   * GET : 在请求行中，url中 ，长度有限，不安全
   * POST ： 数据在请求体中，长度无限制，安全

2. 请求头 ： 名称 ： 值

   * Referer ：从哪里来，

     * 防盗链
     * 统计

     ![image-20200608163915586](https://gitee.com/KawYang/image/raw/master/img/image-20200608163915586.png)

   * Connection ： keep-alone 复用

3. 请求空行 ： 空行，分割作用

4. 请求体 ： userName=Jary

### Request

![image-20200608164323934](https://gitee.com/KawYang/image/raw/master/img/image-20200608164323934.png)

1. 服务器创建 Request 和 response
2. Request 获取请求消息，response 设置响应消息

### Request 继承结构

。。。

### Request功能

1. 请求行数据

   * GET /test/Demo1?name=zhangsan HTTP/1.1
   * 方法
     1. String getMethod() : GET
     2. **String getContextPath() : 虚拟路径 /test**
     3. String getServletPath() : Servlet 路径  /Demo1
     4. String getQueryString() : 参数name=zhangsan 
     5. **String getRequestURI() ：/test/Demo1**
     6. String getRequestURL()  : http://loaclhost/test/Demo1
     7. String getProtocol() : HTTP/1.1 版本
     8. String getRemoteAddr() : 客户IP
   * URL : 统一资源定位符 ` http://loaclhost/test/Demo1`
   * URI ：统一资源标识符 `/test/Demo1`

2. 请求头数据

   * 方法
     1. String getHeader(String name) ： 获取请求头信息
     2. Enumeration<String> getHeaderNames() : 获取请求头名称

3. 请求体数据

   * 还有POST方式，才有请求体
   * 步骤：
     1. 获取流对象
        * getReader() : 获取字符输入流，智能操作字符
        * ServletInputStream getInputStream（） ： 获取字节输入流，可操作所有类型数据
     2. 再从流对象中拿出数据

   ```java
   BufferedReader br = req.getReader();
   String line = null;
   while((line = br.readerLine()) != null){
       System.out.println(line);
   }
   ```

   

### 其他方法

1. 获取请求参数 

   1. String  getParameter(String name) => 获取值
   2. String  getParameterValues(String name)   => hobby=xx&hobby=game
   3. Enumeration<String> GetParameterNames() =>  获取名称
   4. Map<String, String[]> getParameterMap() => 获取所有参数的集合

   * 中文乱码

     * Tomcat8 解决get中文乱码

     * ```java
       req.setCharacterEncoding("utf-8");
       ```

2. 请求转发 :exclamation:

   1. 获取请求转发器对象

   2. 使用转发

      ```java
      req.getRequestDispatcher("http://www.baidu.com").forward(req, resp);
      ```

      **特点**

      1. 浏览器**地址栏**没有变
      2. 服务器**内部**资源
      3. 转发使用**一次请求**

3. 共享

   1. 域对象 ： 一个有作用范围的对象
      * request域：一次请求的范围，一般用于请求转发的多个资源中共享数据
   2. 方法
      * setAttribute(String name, Object obj) : 存储数据
      * getAttribute(String name) : 取值
      * removeAttribute(String name) : 删除

4. 获取ServletContext

   ```java
   ServletContext servletContext = request.getServletContext();
   System.out.println(servletContext);
   ```

## 登录练习 :exclamation:

[用户登录](https://www.bilibili.com/video/BV1aE411L7XV?p=256)

---

## 响应消息数据格式

### 响应消息

1. 响应行 

   * 格式 ： 协议/版本 响应状态码 状态码描述
   * 状态码：三位
     * 1xx ： 服务器接收客户端消息，没有接收完成
     * 2xx ： OK
     * 3xx :  重定向 302 ，资源跳转；304 访问缓存
     * 4xx ：客户端错误， 404 ； 405 无Post/Get方法
     * 5xx ：服务器错误 

   ![image-20200609164456185](https://gitee.com/KawYang/image/raw/master/img/image-20200609164456185.png)

2. 响应头

   * 头名称 ： 值
   * Content-Type ： 响应体数据编码格式
   * Content-disposition ： 打开响应体格式
     * 默认 ： in-line 当前页面中展示
     * attachment；filename=xxx ： 附件格式打开，文件下载 
   
3. 响应空行

4. 响应体 

   * 传送的数据

### 方法

状态码：setStatus(int c)

响应头 ： setHeader（String name, String value)

响应体 ：

1. 步骤

   1. 获去输出流
      1. 字符输出流
         * PrintWriter getWriter()
      2. 字节输出流
         * ServletOutputStream getOutputStream()
   2. 使用输出流输出到浏览器中

   

### 练习:exclamation:

### 重定向

```java
//自动跳转到Demo2  重定向
//设置状态码
resp.setStatus(302);
// 设置头
resp.setHeader("location", "/HomeWork/responseDemo2");
resp.sendRedirect("/HomeWork/responseDemo2");
```

* **$ \color {red}{ forword 和   Redirect 区别}$**

* 特点

  * 地址栏发生变化
  * 可访问其他服务器的资源
  * 两次请求
  * 不能共享数据

* 路径 

  * 绝对路径： 确定唯一资源

    规则： 判断定义的路径是给谁用的

    ​	客户端： **添加虚拟目录**（项目访问路径） => 重定向  ： 建议**动态获取** `String contextPath = req.getContextPath();`

    ​	服务器：**不需要加虚拟目录** => 转发

    > "/HomeWork/responseDemo2" 省略 http://loaclhost:8080 

  * 相对路径 ： 不可以确定唯一资源 , **不** 以`/` 开头，或 `./`开头 **可以不写**

    >  **找到当前路径和目标资源之间的相对关系**

1. 服务器输出字符数据
2. 服务器输出字节流
4. 验证码

### 转发

```java
req.getRequestDispatcher("responseDemo3").forward(req, resp);
```





# ServletContext对象

1. 代表整个web应用，可以和程序的容器`tomcat`进行通讯
2. 功能
   1. 获取 MIME类型：
   2. 域对象 ： 共享数据 
   3. 获取文件的真实`服务器`路径

## 获取

request.getServletContext

httpServlet.getServletContext -> this.geServletContext

```java
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doPost(req, resp);
        this.getServletContext();
        req.getServletContext();
    }
}
```

1. 获取 MIME类型：

   * MIME ,或联网通信过程中定义的一种文件数据类型

     * 格式 ： 大类型/小类型  text/ html  image/jpeg

   * **String  getMimeType(String file)**

   * tomcat下的`web.xml` 

   * ```java
     ServletContext servletContext = req.getServletContext();
     String file = "a.jpg";
     String mimeType = servletContext.getMimeType(file);
     System.out.println(mimeType);
     ```

2. 域对象 ： 共享数据 

   * setAttribute(String name, Object value)
   * getAttribute(String name)
   * removeAttrivute(String name)
   * 范围 ：**共享所有用户的请求数据**

3. 获取文件的真实`服务器`路径

   * String getRealPath(String path)
   * 配置文件  src  web WEB-INF
     * web => /xxx
     *  WEB-INF => /WEB-INF/xx
     * src`已经配置到服务器`  =>  /WEB-INF/classes/xx



## 案例   ： 文件下载

1. 页面显示下载链接

2. 点击链接弹出下载提示框

   1. 使用响应头设置资源的打开方式

      `Content-dispostion:attachment;filename=xxx`

3. 下载

步骤：

- 定义页面，编辑超链接href属性 ，指向Servlet ，传递资源名
- 定义Servlet
  - 获取文件名
  - 加载进内存
  - 指定响应头
  - 写出到response对象中





## 中文乱码

1. 获取浏览器
2. 返回不同的编码方式设置filename