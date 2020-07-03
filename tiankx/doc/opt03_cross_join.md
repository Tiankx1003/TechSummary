# 笛卡尔积优化

#### 需求
1. 对用户等级数据的起止期展开成连续日期
2. 为用户表扩展出时间维度(通过和日历表做笛卡尔积实现)

表结构如下

[**user_level**](../sql/user_level.sql)

| col        | type   | comment  |
| ---------- | ------ | -------- |
| name       | string | 姓名     |
| id         | string | 编号     |
| level      | string | 等级     |
| start_date | date   | 开始时间 |
| end_date   | date   | 结束时间 |


[**user_level_smooth**](../sql/user_level_smooth.sql)

| col        | type   | comment  |
| ---------- | ------ | -------- |
| the_date   | date   | 日期     |
| name       | string | 姓名     |
| id         | string | 编号     |
| level      | string | 等级     |


[**user_info**](../sql/user_info.sql)

| col  | type   | comment |
| ---- | ------ | ------- |
| name | string | 姓名    |
| id   | string | 编号    |


[**user_date**](../sql/user_date.sql)

| col      | type   | comment |
| -------- | ------ | ------- |
| the_date | date   | 日期    |
| name     | string | 姓名    |
| id       | string | 编号    |

#### 处理逻辑

[**cross_join**](../sql/cross_join.sql)

#### 优化方式
打散左表，扩容右表，通过虚拟主键关联，提升并发度
```sql
-- 原有逻辑
select count(1)
from tab1 t1
cross join tab2 t2
;

-- 优化后逻辑
set mapred.reduce.task=5; -- 根据性能调节并发度，与打散、翻倍一致
select count(1)
from (
    select  t.*, 
            pmod(hash(t.col1),5) v_key -- 左表打散
    from tab1
    ) t1
cross join (
    select tab2.*, v_tab.v_key
    from tab2
    lateral view explode (split('0,1,2,3,4',',') v_tab as v_key -- 右表扩容五倍
    ) t2
on t1.v_key = t2.v_key -- 虚拟主键关联
;
```

 * 该方法也可用于解决数据倾斜(解决数据倾斜，表大小允许，首选mapjoin)