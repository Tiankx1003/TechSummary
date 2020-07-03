create table if not exists quotation_smooth(
    the_date string comment '日期',
    id string comment '编号',
    value1 decimal(38,8) comment '核心数值1',
    value2 decimal(38,8) comment '核心数值2',
    smooth_date string comment '平滑取自的日期',
    is_smooth string comment '是否平滑，1是，0否'
)
;