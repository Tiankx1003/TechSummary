-- Oracle处理方式
insert overwrite table quotation_ext_smooth
select  the_date, id
        ,lag(value1 ignore nulls) over (
                                        partition by id
                                        order by the_date desc
                                        ) value1
        ,lag(value2 ignore nulls) over (
                                        partition by id
                                        order by the_date desc
                                        ) value2
        ,lag(value3 ignore nulls) over (
                                        partition by id
                                        order by the_date desc
                                        ) value3
        ,lag(value4 ignore nulls) over (
                                        partition by id
                                        order by the_date desc
                                        ) value4
        ,lag(value5 ignore nulls) over (
                                        partition by id
                                        order by the_date desc
                                        ) value5
from quotation_ext
;

-- Hive处理方式


-- 优化后
insert overwrite table quotation_ext_smooth
select  the_date, id
        ,value1[0] value1
        ,value2[0] value2
        ,value3[0] value3
        ,value4[0] value4
        ,value5[0] value5
from (
    select  the_date, id
            ,collect_list(value1 ignore nulls) over (
                                                    partition by id
                                                    order by the_date desc
                                                    ) value1
            ,collect_list(value2 ignore nulls) over (
                                                    partition by id
                                                    order by the_date desc
                                                    ) value2
            ,collect_list(value3 ignore nulls) over (
                                                    partition by id
                                                    order by the_date desc
                                                    ) value3
            ,collect_list(value4 ignore nulls) over (
                                                    partition by id
                                                    order by the_date desc
                                                    ) value4
            ,collect_list(value5 ignore nulls) over (
                                                    partition by id
                                                    order by the_date desc
                                                    ) value5
    from quotation_ext
    ) quotation_ext_col
;

