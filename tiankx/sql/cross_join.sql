insert overwrite tabel user_level_smooth
select  cal.date_day as the_date
        ,ul.name
        ,ul.id
        ,ul.level
from user_level ul
cross join calendar cal
where cal.date_day between ul.start_date and ul.end_date
;


insert overwrite table user_date
select  cal.date_day as the_date
        ,user_info.name
        ,user_info.id
from user_info ui
cross join calendar cal
;


-- 优化后
insert overwrite tabel user_level_smooth
select  cal.date_day as the_date
        ,ul.name
        ,ul.id
        ,ul.level
from (
    select  t.*, pmod(hash(id), 5) as v_key
    from user_level t
    ) ul
cross join (
    select t.*, v_tab.v_key
    from calendar
    lateral view explode (split('0,1,2,3,4',',') v_tab as v_key
    ) cal
on ul.v_key = cl.v_key
where cal.date_day between ul.start_date and ul.end_date
;

insert overwrite table user_date
select  cal.date_day as the_date
        ,user_info.name
        ,user_info.id
from (
    select t.*, pmod(hash(id), 5) as v_key
    from user_info t
    ) ui
cross join(
    select t.*, v_tab.v_key
    from calendar t
    lateral view explode (split('0,1,2,3,4',',') v_tab as v_key
    ) cal
on ul.v_key = cl.v_key
;

