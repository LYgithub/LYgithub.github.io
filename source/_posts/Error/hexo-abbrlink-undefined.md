---
title: hexo-abbrlink-undefined
tags:
  - hexo
  - Error
abbrlink: b3b09752
categories: hexo
date: 2020-07-07 00:13:40
---

> 本文解决的问题： 安装 `hexo-abbrlink` 后，并配置 `abbrlink` 连接，出现 `undefined`问题，所有文章标题都指向同一篇文章，并且无法重新启动 hexo 服务。

<!-- more -->

## 错误信息Error
```xml
> hexo s
INFO  Start processing
FATAL Something's wrong. Maybe you can find the solution here: https://hexo.io/docs/troubleshooting.html
TypeError: Cannot read property 'enable' of undefined
    at Hexo.logic (/Users/mac/blog/node_modules/hexo-abbrlink/lib/logic.js:59:44)
    at Hexo.tryCatcher (/Users/mac/blog/node_modules/bluebird/js/release/util.js:16:23)
    at Hexo.<anonymous> (/Users/mac/blog/node_modules/bluebird/js/release/method.js:15:34)
    at /Users/mac/blog/node_modules/hexo/lib/extend/filter.js:62:52
    at tryCatcher (/Users/mac/blog/node_modules/bluebird/js/release/util.js:16:23)
    at Object.gotValue (/Users/mac/blog/node_modules/bluebird/js/release/reduce.js:166:18)
    at Object.gotAccum (/Users/mac/blog/node_modules/bluebird/js/release/reduce.js:155:25)
    at Object.tryCatcher (/Users/mac/blog/node_modules/bluebird/js/release/util.js:16:23)
    at Promise._settlePromiseFromHandler (/Users/mac/blog/node_modules/bluebird/js/release/promise.js:547:31)
    at Promise._settlePromise (/Users/mac/blog/node_modules/bluebird/js/release/promise.js:604:18)
    at Promise._settlePromise0 (/Users/mac/blog/node_modules/bluebird/js/release/promise.js:649:10)
    at Promise._settlePromises (/Users/mac/blog/node_modules/bluebird/js/release/promise.js:729:18)
    at _drainQueueStep (/Users/mac/blog/node_modules/bluebird/js/release/async.js:93:12)
    at _drainQueue (/Users/mac/blog/node_modules/bluebird/js/release/async.js:86:9)
    at Async._drainQueues (/Users/mac/blog/node_modules/bluebird/js/release/async.js:102:5)
    at Immediate.Async.drainQueues [as _onImmediate] (/Users/mac/blog/node_modules/bluebird/js/release/async.js:15:14)
    at processImmediate (internal/timers.js:456:21)
```

## 解决办法
根据错误提示，找到`/Users/mac/blog/node_modules/hexo-abbrlink/lib/logic.js:59:44` 59 行，如图
![](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9naXRlZS5jb20vS2F3WWFuZy9pbWFnZS9yYXcvbWFzdGVyL2ltZy8yMDIwMDcwNzAwMDYxNy5wbmc?x-oss-process=image/format,png)
发现提示 `abbrlink.auto_category.enable` 未定义，因此在根目录配置文件内添加该属性即可解决。
最终 `abbrlink` 配置如下：
> 修改 abbrlink 配置：
```xml
#permalink: :year/:month/:day/:title/
permalink: kawyang/:abbrlink.html
abbrlink: 
  auto_category: 
    enable: false
  alg: crc32
  rep: hex
```

## enable 差别

- true : 含有提示, 如图所示
![](https://gitee.com/KawYang/image/raw/master/img/20200707001755.png)

- false : 没有提示，如图所示

![](https://gitee.com/KawYang/image/raw/master/img/20200707001913.png)
