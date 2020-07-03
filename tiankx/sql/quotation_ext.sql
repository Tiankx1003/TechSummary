create table if not exists quotation_ext(
    the_date string comment '日期',
    id string comment '编号',
    value1 decimal(38,4) comment '核心数值1',
    value2 decimal(38,4) comment '核心数值2',
    value3 decimal(38,4) comment '核心数值3',
    value3 decimal(38,4) comment '核心数值4',
    value4 decimal(38,4) comment '核心数值5'
)
;

create table quotation_ext_smooth like quotation_ext;