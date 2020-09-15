---
title: Docker 入门
abbrlink: fa8faa2e
---



# Docker入门[^菜鸟教程]

<!-- more -->

## 关键词

### 镜像(**Image**)

> Docker 镜像（Image），就相当于是一个 root 文件系统。

### 容器(**Container**)

> 镜像（Image）和容器（Container）的关系，就像是面向对象程序设计中的类和实例一样，镜像是静态的定义，容器是镜像运行时的实体。容器可以被创建、启动、停止、删除、暂停等

### 仓库(**Repository**)

> 仓库可看成一个代码控制中心，用来保存镜像。

## 中央仓库

> 
>
> 1. 官方 ： https://hub.docker.com
>
> 2. 国内：
>
>    Https://c.163.com/hub
>
>    http://hub.daocloud.io/
>
> 3. 公司内部
>    1. 添加配置 /etc/docker/daemon.json
>    2. 重启服务 `systemctl daemon-reload, systemctl restart docker `

## 安装

### 安装相应的依赖

```sh
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common
```

### 添加密钥

```sh
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
```

### 验证

```sh
sudo apt-key fingerprint 0EBFCD88
```

### 修改稳定版仓库

 ```sh
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
  $(lsb_release -cs) \
  stable"
 ```

### 安装 Docker Engine-Community

```sh
$ sudo apt-get update
$ sudo apt-get install docker-ce docker-ce-cli containerd.io
# 查看不同的版本信息
$ apt-cache madison docker-ce
# 安装 前后 version 相互对应
$ sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io
# 如下
$ sudo apt-get install docker-ce=5:18.09.0\~3-0\~debian-stretch docker-ce-cli=5:18.09.0\~3-0\~debian-stretch containerd.io
```



## 命令

### 镜像操作

- 拉取 ubuntu 镜像 : `docker pull ubuntu[:latest]` 
  docker pull daocloud.io/library/tomcat:8.5.15-jre8

- 查看镜像：`docker images`

- 删除镜像：`docker rmi <image id>`

### 镜像导入/导出

- 导出

  docker save -o <file> <id>

- 导入

  docker load -i <file>

- 修改镜像ID

  docker tag <image id> name:version
### 容器操作

- 运行容器: `docker run ubuntu -it /bin/bash` 

**常用参数 ：**

-d: 后台运行

-p : 映射当前 Linux 的端口和容器端口。-p linux: 容器

--name : 制定容器的名字

-v :指定数据卷的路径: -v  <路径｜数据卷name>:<innerfile> <imageId>

- 查看运行的容器：`docker ps [-aq]` q只查看标示

- 查看运行的容器: `docker logs -f` 滚动查看

- Docker logs --tail 10 最新10条

- 进入容器：`docker exec -it bash`

- 停止运行容器：`docker stop <id|name>`

- 查看容器：`docker container ls -a`

- 启动容器：`docker run｜start <id|name>`

- 删除容器(先停止): `docker rm <id|name>`

  docker rm $(docker ps -qa) //删除所有容器

- 文件复制： 宿主机 `docker cp file id:innerfile`
---

> Mvn clean package -DskipTests 打包

### 数据卷

宿主机的目录映射到容器

- 创建数据卷

  `docker volume create <name>`

- 默认存放的目录 /var/lib/docker/volmne/<name>/_data

- 查看详细信息

  docker volume inspect <name>

  docker volume ls

- 删除数据卷

  docker volume rm <name>

- -v :指定数据卷的路径: -v  <路径｜数据卷name>:<innerfile> <imageId>

  > 指定路径不能够自带 inner 文件中的内容，需要自己创建
  >
  > 指定数据卷名：会将 inner 中的文件内容 "映射"到数据卷中的 _data文件中

#### docker 命令权限问题

```shell
# 创建docker用户组
sudo groupadd docker
# 将用户添加到 docker 组中
sudo gpasswd -a $USER docker
# 切换当前会话到新 group 或者重启 X 会话
newgrp docker
```

## 自定义镜像

![image-20200816171434986](https://gitee.com/KawYang/image/raw/master/img/image-20200816171434986.png)

## Docker-Compose

> 批量管理容器
>
> 通过Docker-Compose.yml文件管理

### 下载 Docker-Compose

1. github 下载
2. 修改文件名，权限设置为可执行
3. 配置环境变量

### 应用

> yml 文件  key: value 空格
>
> 不能使用【Tab】键

```yml
version: '3.1'
servie:
  mysql: 
    restart: always # docker 启动 容器跟着启动
    image: daocloud.io/library/mysql # 制定镜像的路径
    container_name: mysql # 制定容器名称
    ports: 
      - 3306: 3306
      # - 3308: 122 多个映射
    environment:
      MYSQL_ROOT_PASSWORD: root
      TZ: Asia/Shanghai
    volumes: 
      - /opt/docker/mysql/data: /var/lib/mysql #映射数据卷
  tomcat: 
    resatart: always
    images: daocloud.io/library/tomcat
    container_name: tomcat
    ports:
      - 8080: 8080
    environment:
      TZ: Asia/Shanghai
    volumes:
      - /opt/docker_tomcat/tomcat_webapps: /usr/local/tomcat/webapps
      - /opt/docker_tomcat/logs/: /usr.local/tomcat/logs
```

### 管理

> 运行 docker-compase 会找当前目录 的 yml 文件

- 启动容器 `docker-compase up -d`
- 关闭 `docker-compose down`
- 启动已存在的容器：`docker-compose start｜stop ｜restart`
- 查看 `docker-compose ps`

### Docker-compose 管理 Dockerfile文件

[yml文件]()

```yml
version: '3.1'
servie:
  ssm: 
    restart: always # docker 启动 容器跟着启动
    build:
      context: ../ # dockerfile 目录
      dockerfile: Dockerfile # dockerfile 文件
    image: ssm:1.0.1 # 制定镜像的路径
    container_name: ssm # 制定容器名称
    ports: 
      - 8081: 8080
    environment:
      TZ: Asia/Shanghai

```

[dockerfile]()

```
from daocloud.io/library/tomcat
copy ssm.war /usr/local/tomcat/webapp
```

> 没有自定义镜像，docker compose 会创建镜像，如果有镜像，会直接使用

>  如果想重新构建：docker-compose build ｜ docker-compose up --build



## $\color{red}{ CI CD}$

。。。

# 参考内容

[^菜鸟教程]:https://www.runoob.com/docker/docker-tutorial.html

[笔记连接](https://www.lixian.fun/3812.html)

