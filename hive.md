

## 架构
  - Compiler：translate HQL into MapReduce
  - Metastore：central repository of metadata（schema on read, indexing)


## 表类型
1. managed table(default): metadata and data
2. external table：对hdfs上相应文件的一个引用, 删除操作只删除元数据，不删除数据。
3. partition分区表：

``` SQL
create table tableName (
　　 id int comment 'ID',
　　 name string comment 'name' 
　　) partitioned by (year int comment 'admission year', school string comment 'school name')
　　row format delimited
　　fields terminated by '\t';

load data local inpath linux_fs_path into table tblName partition(dt='2015-12-12');
```

4. bucket: 桶表是对数据进行哈希取值，然后放到不同文件中存储。

```
create table t_bucket(id string) clustered by(id) into 3 buckets; 
insert into table t_bucket select id from test;	

```

## 文件存储格式
1. TextFile
2. RCFile
3. ORCFile
4. Parquet



## HiveQL
1. mapjoin: (大小表)
  - 会把小表全部读入内存中，在map阶段直接拿另外一个表的数据和内存中表数据做匹配，由于在map是进行了join操作，省去了reduce运行的效率也会高很多

2. window function
  - e.g. ROW_NUMBER() OVER(PARTITION BY a ORDER BY b)
  - 类型：
    - 1. FIRST_VALUE(col), LAST_VALUE(col) 可以返回窗口帧中第一条或最后一条记录的指定字段值；
    - 2. LEAD(col, n), LAG(col, n) 返回当前记录的上 n 条或下 n 条记录的字段值；
    - 3. RANK(), ROW_NUMBER() 会为帧内的每一行返回一个序数，区别在于存在字段值相等的记录时，RANK() 会返回相同的序数
    - 4. COUNT(), SUM(col), MIN(col) 和一般的聚合操作相同。
