# 针对时间平滑

#### 需求
表quotation_info只有工作日数据(不包含节假日和周末)
现在需要平滑数据，若当前无数据，取最近的上一条数据
如：周六日没有数据，则平滑取本周五数据

[**样例数据**](../data/quotation_info.txt)

表结构如下

[**quotation_info**](../sql/quotation_info.sql)

| col      | type          | comment   |
| :------- | :------------ | :-------- |
| the_date | string        | 日期      |
| id       | string        | 编号      |
| value1   | decimal(38,4) | 核心数值1 |
| value2   | decimal(38,4) | 核心数值2 |


[**quotation_smooth**](../sql/quotation_smooth.sql)

| col          | type          | comment            |
| :----------- | :------------ | :----------------- |
| the_date     | string        | 日期               |
| id           | string        | 编号               |
| value1       | decimal(38,4) | 核心数值1          |
| value2       | decimal(38,4) | 核心数值2          |
| smooth_date  | string        | 平滑取自的日期     |
| is_smooth    | string        | 是否平滑(1是，0否) |


[**calendar**](../sql/calendar.sql)

| col      | type   | comment |
| -------- | ------ | ------- |
| date_day | string | 日期    |
| year     | string | 年      |
| month    | string | 月      |
| day      | string | 日      |


#### 处理逻辑

[**get_quotation_smooth**](../sql/get_quotation_smooth.sql)

[**样例数据**](../data/quotation_smooth.txt)

[**xlsx文件**](../data/demo.xlsx) 可做直观比对

#### 优化方式
原有处理逻辑是直接拿缺失日期区间和日历表(10000条数据)做笛卡尔积，性能较差
有如下优化点
1. 连续日期不做平滑，只平滑不连续日期
2. 按年平滑，不跨年时只和所在年份平滑(365条)
3. 只有跨年数据对整张日历表做平滑