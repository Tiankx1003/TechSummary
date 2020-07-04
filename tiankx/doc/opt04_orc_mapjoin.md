# orc & mapjoin

使用orc默认压缩，有以下缺点
1. 作为左表时，同样的切片大小，orc比textfile起的mapper少
    曾有5亿数据join 1亿数据只起 3 mapper，3 reducer 的情况
    使用textfile起了 300+ mapper，500+ reducer
2. *hive on mr*是磁盘中的大小判断是否作为小表进行mapjoin
    所以会出现海量数据被当做小表做mapjoin导致内存溢出的问题
    如果一个任务中多长表关联，非压缩的小表体积大于压缩后的大表
    那么mapjoin就很难设置(旧版本可手工指定mapjoin，新版本已废弃)

10MB

大表 9M

小表 11M


