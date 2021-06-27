---
title: MyBatis-模糊查询&动态SQL
tags:
  - MyBatis
  - SQL
abbrlink: 5882fb3c
categories: 框架
data: 2020-06-22 10:30:21
---

> 本文讲述了模糊查询的操作方法，配置实体类全局路径方法等内容，主要对 `MyBatis` 的动态SQL查询方式进行了相关总结。

<!-- more -->

## 模糊查询

- \#{} sql语句占位符
- ${} sql语句拼接


```sql
select * from student where name like #{data};
-- => select * from student where name like ?;
select * from student where name like '%${data}%'; 
-- => select * from student where name like '%data%';
```

## 配置实体类路径 (别名)

在全局配置文件中使用

```xml
<!--  别名设置，放在settings标签之下，environment 标签之前  -->
<typeAliases>
	<!-- 单个别名配置 -->
    <typeAlias alias="student" type="com.kawyang.entity.Student"/>
    <!--   批量别名，扫描包内所有内容，别名为类名(首字母大小写都可以)     -->
    <package name="com.kawyang.entity"/>
</typeAliases>
```
 > 配置文件书写顺序
properties?,settings?,typeAliases?,typeHandlers?,objectFactory?,
objectWrapperFactory?,plugins?,environments?,databaseIdProvider?,mappers?


## 动态SQL


### if

> 通过 if 标签可以判断是否包含查询的字段

```xml
<select id="findByStudent" parameterType="student" resultType="student">
        select * from student where 1=1
        <if test="name != null and name != ''">
            and name like #{name}
        </if>
        <if test="age != -1">
            and age=#{age}
        </if>
    </select>
```

### where

> 通过 where 标签可以解决以上 1=1 的多余内容  


```xml
<select id="findByStudent" parameterType="student" resultType="student">
        select * from student
        <where>
	        <if test="name != null and name != ''">
	            and name like #{name}
	        </if>
	        <if test="age != -1">
	            and age=#{age}
	        </if>
        </where>
    </select>
```
where 会自动判断第一条判断条件，并将 and 删除


### foreach

select * from student where id in (1,2,3);

后端传递的参数为 Integer 的 集合
需要对该集合进行封装

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ListIds extends Serializable{
	private List<Integer> listIds;
}

```

```xml
<!-- 查询所有用户在 id 的集合之中 -->
<select id="findInIds" resultType="student" parameterType="ListIds"> 
<!--select * from student where id in (1,2,3);-->
	select * from student
	<where>
		<if test="ids != null and ids.size() > 0">

			<foreach collection="student" open="id in ( " close=")" separator="," item="id" >
				#{id}
			</foreach>
	    </if>
	</where>
</select>

<select id="findByIds" resultType="com.kawyang.entity.Student" parameterType="com.kawyang.entity.ListIds">
        select * from student
        <where>
        <!-- 
			foreach 
			collection="需要遍历的元素" 
			open="元素之前的部分"
			close="之后部分" 
			separator="分割方式" 
			item="属性名" </foreach>  -->
            <foreach collection="ids"  open="id in ( " close=")" separator="," item="id" >
                #{id}
            </foreach>
        </where>
    </select>

```


### choose

choose 标签，类似 java 中的 `switch-case-default` 结构。

```xml
<select id="findByStu" parameterType="com.item.entity.Student" >
    select * from student
    <where>
        <choose>
            <when test="id != 0">
                id = #{id}
            </when>
            <when test="name != null">
                name=#{name}
            </when>
        </choose>
    </where>

</select>
```

### sql

使用 sql 标签 将 使用次数较多的sql语句用sql🏷️进行定义，使用 include🏷️引入到真正的查询语句中，使用方便。
例子：
```xml
<sql id="selectAll" >
    select * from student
</sql>

<select id="findByStudent" parameterType="com.kawyang.entity.Student" resultType="com.kawyang.entity.Student" >
--         select * from student
<include refid="selectAll"></include>
<where>
    <choose>
        <when test="id != 0">
            id=#{id}
        </when>
        <when test="name != null">
            name=#{name}
        </when>
    </choose>
</where>
</select>
```

### 注解形式使用动态SQL(待补充)

添加  `<script>` 标签，即可使用 xml 中形式进行配置。

```java
    @Select("<script>" +
            "select * from student" +
            "        <where>" +
            "            <if test=\"ids != null and ids.size>0\">" +
            "                <foreach collection=\"ids\"  open=\"id in ( \" close=\")\" separator=\",\" item=\"id\" >" +
            "                    #{id}" +
            "                </foreach>" +
            "            </if>" +
            "        </where> " +
            "</script>")
    List<Student> findByIds(ListIds listIds);
```

