create table if not exists num2 (i int);-- 创建一个表用来储存0-9的数字
create table  if not exists calendar(datelist date); -- 生成一个存储日期的表，datalist是字段名
create table if not exists calendar_detail( --存放2000年以来10000天日期数据
    date_day string comment '日期',
    year string comment '年',
    month string comment '月',
    day string comment '日'
) comment '日历明细表';


insert into num2 (i) values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);-- 生成0-9的数字，方便以后计算时间

-- 这里是生成并插入日期数据
insert overwrite table calendar 
select
    date_add(
        (   -- 这里的起始日期，你可以换成当前日期
            '2000-01-01'
        ),
        numlist.id
    ) as `date`
from
    (
        select
            n1.i + n10.i * 10 + n100.i * 100 + n1000.i * 1000 as id
        from
            num n1
        cross join num as n10
        cross join num as n100
        cross join num as n1000
    ) as numlist;

insert overwrite table calendar_detail
select datelist, year(datelist), month(datelist), day(datelist) 
from calendar;
