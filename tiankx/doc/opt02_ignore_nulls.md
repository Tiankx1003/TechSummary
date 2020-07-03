# 针对字段平滑

#### 需求
表quotation_info有连续日期数据，但是五个数值字段有不规则的空值情况
需要对空值做补充，与之前的最近一条数值一致

[**样例数据**](../data/quotation_ext.txt)

表结构如下

[**quotation_ext & quotation_ext_smooth**](../sql/quotation_ext.sql)

| col      | type          | comment   |
| -------- | ------------- | --------- |
| the_date | string        | 日期      |
| id       | string        | 编号      |
| value1   | decimal(38,4) | 核心数值1 |
| value2   | decimal(38,4) | 核心数值2 |
| value3   | decimal(38,4) | 核心数值3 |
| value4   | decimal(38,4) | 核心数值4 |
| value5   | decimal(38,4) | 核心数值5 |


#### 处理逻辑

[**get_quotation_ext_smooth**](../sql/get_quotation_ext_smooth.sql)

[**样例数据**](../data/quotation_ext_smooth.txt)

[**xlsx文件**](../data/demo.xlsx) 可做直观比对

#### 优化方式
Oracle开窗支持`ignore nulls`
如lag往前取最近一条非空数据
```sql
lag(value_1 ignull nulls) over (
                                partition by col_1, col_2, ...
                                order by col_3, col_4, ...
                                )
```

Hive不支持`ignore nulls`，如果对n个字段做平滑然后关联到一起
时间按复杂度增加了n倍，可借助数据结构间接实现`ignore nulls`
```sql
select  col_1, col_2, ...
        ,value_1[0]
        ,value_2[0]
        ,value_3[0]
        ,...
from(
    select  col_1, col_2, ...
            ,collect_list(value_1) over (
                                        partition by col_1, col_2, ...
                                        order by col_3, col_4, ...
                                        ) value1
            ,collect_list(value_2) over (
                                        partition by col_1, col_2, ...
                                        order by col_3, col_4, ...
                                        ) value2
            ,collect_list(value_3) over (
                                        partition by col_1, col_2, ...
                                        order by col_3, col_4, ...
                                        ) value3
            ,...
    from tab1
    ) tab2
```