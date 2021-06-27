---
title: JavaScript-学习总结
categories: 文章类型
abbrlink: 20425d10
date: 2020-09-25 10:51:42
tags:
---

> 

<!-- more -->

## 变量声明

- var : 在代码块中重新定义会覆盖外部变量,可以先使用后声明,重新声明后变量值不会丢失.
- let : 解决 var 作用域问题,let 在其声明的作用域内起作用.
- const : 常量不可修改,声明时必须初始化,类似java常量,对于对象类型,内部信息可以变化.**const** 关键字在不同作用域，或不同块级作用域中是可以重新声明赋值的:

## 正则表达式

> /表达式/[修饰符]
>
> - 修饰符
>   - i - 执行对大小写不敏感皮配
>   - g - 全局搜索
>   - m - 执行多行匹配

```javascript
var patt = /Runnable/i;
var s = "Runnable";
//
var n = s.search(patt); // 返回匹配的位置
var txt = s.replace(patt, "replace_text"); // 返回替换后的字符串
// 
patt.text(s); // 返回 Bool 类型,检测是否符合 patt 表达式格式
patt.exec(s); // 返回 数组存放匹配的结果
```

## DOM

####  创建新HTML元素节点 - appendChild()

```javascript
let element = document.createElement("p");
let node = document.createTextNode("内容");
element.appendChild(node);
```

#### 创建新HTML 元素 - insertBefore()

```javascript
//在 element 元素内的 ele2 之前插入 ele1
element.insertBefore(ele1, ele2);
```

```javascript
let element = document.getElementById("div1");
let ele1 = document.createElement("p");
let ele2 = document.getElementById("div1-p1");
element.insertBefore(ele1, ele2);
```

#### 移除元素 - removeChild()

```javascript
let element = document.getElementById("div1");
element.removeChild( document.getElementById("div1-p1") );
```

#### 替换元素 -  replaceChild()

```javascript
let element = document.getElementById("div1");
let newEle = document.createElement("p").appendChild(document.creatTextNode("新元素"));
let oldEle = document.getElementById("div1-p1");
element.replaceChild(newEle, oldEle);
```

### Collection集合

getElementsByTagName()

```javascript
let elements = document.getElementsByTagName("p");
for(let i = 0; i<elements.length; i++){
    elements[i].style.color = "red";
}
```

> HTMLCollection 类似数组而`不是数组`

### NodeLiet 对象

```javascript
let elements = document.querySelectorAll("p");
for(let i = 0; i<elements.length; i++){
    elements[i].style.backgroundColor = "red";
}
```

##### 区别:

HTMLCollection 可以通过 id , name 或 索引来获取

NodeList 只能通过 索引 获取, 只有 NodeList 对象有包含属性节点和文本节点。

## JavaScript对象

> 函数也可以是对象

### 对象

#### 创建对象

- 使用`Object`定义并创建对象
- 使用`函数`来定义对象,然后创建新的对象实例

```javascript
let obj = new Object();
obj.firstName = "Kaw";
obj.lastName = "Yang";
obj.age = 21;
// obj = { firstName:"Kaw", lastName:"Yang", age:21}

// 使用对象构造器

function Person (firstName , lastName , age){
    this.firstName = firstName;
    this.lastName = lastName;
    this.age = age;
    
    function ChangeName(firstName){
        this.firstName = firstName;
    }
}
let person = new Person("", "", 2);
```

> JavaScript 是面向对象的, 但是不使用类
>
> JavaScript 基于 ==prototype(原型)== ，而不是基于类的。

#### for...in

```javascript
let person = { firstName:"Kaw", lastName:"Yang", age:21};
for(let x in person){
    alert(x +"==>" + person[x]);
}
```

### 原型prototype对象

> 所有对象都是通过原型对象继承来的

#### 作用

通过原型对象,可以对一个已经存在的对象 de 构造器 添加属性.

```javascript
function Person (firstName , lastName , age){
    this.firstName = firstName;
    this.lastName = lastName;
    this.age = age;
    
    function ChangeName(firstName){
        this.firstName = firstName;
    }
}
Person.prototype.nationality = "China";
let person = new Person("Kaw", "Yang", 21);
for(let x in person){
    alert(x +"==>" + person[x]);
}
```

### 数字对象 - Number

#### 格式化

```javascript
var a=123;
b=a.toFixed(2); // b="123.00"

var a=123;
b=a.toPrecision(2); // b="1.2e+2"
```

### 字符串 

#### 匹配 - match

#### 替换 - replace

#### 转换 - toUpperCase/ toLowerCase

#### 数组 - split

#### 转义 - \

### 日期

```javascript
let d = new Date();
d.getFullYear();
d.getTime(); // 时间戳1970 年 1 月 1 日 至今
d.toUTCString(); // 将当日的日期（根据 UTC）转换为字符串。
d.getDay();  // 返回数字 0 为周天
d.getMonth)(); // 从 0 开始 
```

#### 创建

```javascript
new Date();
new Date(value);
new Date(dateString);
new Date(year, monthIndex [, day [, hours [, minutes [, seconds [, milliseconds]]]]]);
```

#### 设置

```javascript
d.setFullYear(2020, 01, 01);
d.setDate( d.getDate() + 5); // 5 天后

```

#### 比较

```javascript
var x=new Date();
x.setFullYear(2100,0,14);
var today = new Date();
if (x>today){
    alert("今天是2100年1月14日之前");
}
else{
    alert("今天是2100年1月14日之后");
}
```

### 数组

> 数组中可以有不同的对象
>
> 属性: length , 方法:  indexOf(value);
>
> 使用原型机制添加方法:
>
> ​	Array.prototype.myFun = function(){}

#### 创建

```javascript
// 1.
let array = new Array();
array[0] ="";
array[1] = "";

// 2.
let array = new Array("", "", ..);

// 3. 
let array = [ "", "", ..];
```

#### 方法

- concat(array, ..) // 合并

- join() // 组成字符串 `,`分割 

- pop() //删除最后一个

- push(); //添加到最后

- 将一个数组中的元素的顺序反转排序 - reverse()

- 删除数组的第一个元素 - shift()

- 从一个数组中选择元素 - slice()
- 数组排序（按字母顺序升序）- sort()
- 数字排序（按数字顺序升序）- sort()
- 数字排序（按数字顺序降序）- sort(function(a, b){return b-a} )
- 在数组的第2位置添加一个元素 - splice()
- 转换数组到字符串 -toString()
- 在数组的开头添加新元素 - unshift()

### Math()

#### round() - 四舍五入 floor 向下取

#### random() - 随机(0,1)

#### max(a,b) - a,b 最大

#### min(a,b) -a,b最小

#### Other

- sqrt() // 开方
- PI // 𝞹
- Math.floor(Math.random() * 11) // 0 -11 

###  RegExp对象

> RegExp：是正则表达式（regular expression）的简写。

```javascript
let patt = new RegExp("\\w+", "ig");
let patt = /w+/ig
```



| 方法  | 使用            | 返回值                                                       |
| ----- | --------------- | ------------------------------------------------------------ |
| match | str.match(patt) | ***["RUnoob", index: 6, input: "Visit RUnoob", groups: undefined]***   0: "RUnoob" groups: undefined index: 6 input: "Visit RUnoob" length: 1 __proto__: Array(0) |
| test  | str.test(patt)  | Boolean                                                      |
| exec  | patt.exec(str)  | **["e", index: 2, input: "The best things in life are free", groups: undefined]** 0: "e"groups: undefinedindex: 2input: "The best things in life are free"length: 1 __proto__: Array(0) |
|       |                 |                                                              |

## 浏览器BOM - Browser Object Model

#### window 对象

> DOM 自动成为 window 对象的成员

#### 尺寸

- window.innerWidth
- window.innerHeigh
- window.open()
- window.moveTo()
- window.close()
- window.resizeTo()

#### Screen

/...

#### Location

- location.href
- location.pathname
- location.assign(href) // 重新加载

#### History

> 1. *History {length: 7, scrollRestoration: "auto", state: null}*
>
> 2. 1. length: 7
>    2. scrollRestoration: "auto"
>    3. state: null
>    4. __proto__: History

- history.back() - 上一页

- history.forward() - 下一页

  

#### Navigator

> 访问者浏览器信息

#### 弹窗

> window 下的方法

##### 警告弹窗 - alert

- 显示警告信息 \n 换行

##### 确认弹窗 - confirm

- 返回 Boolean 类型

##### 提示弹窗 - prompt

- 参数 : tag1 -> 提示信息 , tag2 -> 默认输入框内容
- 返回值: 输入的内容

#### 计时器

- let i = setInterval(function, time) 
  - clearInterval(i)  - 停止
- let t = setTimeout(funcation, time)
  - clearTimeout(t) - 停止

#### cookie

> cookie 是一些数据,存储在客户端的文本文件.
>
> 当服务器向客户端发送页面技术后不会记录客户端的信息
>
> cookie 用于存储客户端信息.

- 创建cookie

  document.cookie = “username =**yang**;key=value”

- 读取 cookie

  let cook = document.cookie;

- 修改 cookie

  document.cookie = “username= **changeName**;key=value”

- 删除 cookie

  document.cookie = “username=; key=value”

```javascript
/// 实现的功能: 如果 有 name 的 cookie 显示, 没有就设置 cookie
function showCookie() {
    // 1. 获取 cookie
    let cookies = document.cookie;
    // 2. 裁剪 cookie
    let cookieList = cookies.split(";");
	// 3. 查找 name cookie 的值
    for (let i =0; i< cookieList.length; i++){
        // 删除 前后 空格
        let name_cookie = cookieList[i].trim();
        // 查找到name 的cookie
        if(name_cookie.indexOf("name") === 0){
            // 裁剪出 cookie 的值
            let name = name_cookie.substr("name=".length, name_cookie.length);
            // 没有设置 cookie , 跳出循环, 设置 cookie
            if(name.length === 0){
                break;
            }else{
            	// cookie 有值, 返回结束
                alert("欢迎回来 " + name);
                return;    
            }
            
        }
    }
    let name = prompt("请输入用户名：");
    document.cookie = "name=" + name + ";"
}


//// setCookie(key, value, tiem)  ==> 设置cookie 
//// getCookie(key) ==> 获取 cookie
//// checkCookie() ==> 检查cookie 业务
```

---

## 类库

### JQuery

- 是目前最受欢迎的框架
- 使用CSS选择器的方式进行操作
- 同时提供了用户界面和插件
- 

### MooTools - 动画特效

## Prototype - Web任务API

