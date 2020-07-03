create table if not exists quotation_info(
    the_date string comment '日期',
    id string comment '编号',
    value1 decimal(38,8) comment '核心数值1',
    value2 decimal(38,8) comment '核心数值2'
)
;