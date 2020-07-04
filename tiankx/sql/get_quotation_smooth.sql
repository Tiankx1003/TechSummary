
inser overwrite table quotation_smooth
select  dimission.date_day the_date         -- 交易日期
        ,quotation.value1                   -- 核心数值1
        ,quotation.value2                   -- 核心数值2
        ,quotation.the_date smooth_date     -- 平滑取自的日期
        ,case when dimission.date_day = quotation.the_date then '0'
              else '1' end is_smooth        -- 平滑标记，1是
from (
    select  t.*, 
            lead(the_date,1,to_date(current_timestamp())) 
                over(partition by id order by the_date) valid_date
    from quotation_info t
    ) quotation
cross join calendar dimission
where dimission.date_day between quotation.the_date and quotation.valid_date
;


-- 优化，按年平滑发散
create table tmp_quotation_info as 
    select  t.*, 
            lead(the_date,1,to_date(current_timestamp())) 
                over(partition by id order by the_date) valid_date
            ,year(the_date) as year
    from quotation_info t
;

inser overwrite table quotation_smooth
select  dimission.date_day the_date         -- 交易日期
        ,quotation.value1                   -- 核心数值1
        ,quotation.value2                   -- 核心数值2
        ,quotation.the_date smooth_date     -- 平滑取自的日期
        ,case when dimission.date_day = quotation.the_date then '0'
              else '1' end is_smooth        -- 平滑标记，1是
from tmp_quotation_info quotation
cross join calendar dimission
on quotation.year = dimission.year
where datediff(quotation.valid_date, quotation.the_date) <> 1
    and year(quotation.the_date) = year(quotation.valid_date) -- 同年数据平滑
    and dimission.date_day between quotation.the_date and quotation.valid_date
union all
select  dimission.date_day the_date         -- 交易日期
        ,quotation.value1                   -- 核心数值1
        ,quotation.value2                   -- 核心数值2
        ,quotation.the_date smooth_date     -- 平滑取自的日期
        ,case when dimission.date_day = quotation.the_date then '0'
              else '1' end is_smooth        -- 平滑标记，1是
from tmp_quotation_info quotation
cross join calendar dimission
where datediff(quotation.valid_date, quotation.the_date) <> 1
    and year(quotation.the_date) <> year(quotation.valid_date) -- 跨年数据
    and dimission.date_day between quotation.the_date and quotation.valid_date
union all
select  quotation.the_date the_date         -- 交易日期
        ,quotation.value1                   -- 核心数值1
        ,quotation.value2                   -- 核心数值2
        ,quotation.the_date smooth_date     -- 平滑取自的日期
        ,'0' is_smooth                      -- 平滑标记，0否
from tmp_quotation_info quotation
where datediff(quotation.valid_date, quotation.the_date) = 1
;
