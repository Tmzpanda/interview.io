# Spark
```
spark-submit 
  -- class
  -- master
  -- deploy-mode 
  <application-jar>
  [appliccation-arguments]
  
  -- num-executors
  -- totoal-executor-cores
  -- executor-memory
    

Application --------------------- Cluster Manager --------------------- Worker Node
Driver                            Standalone                            Executor
SparkContext                      Yarn                                  Task

DAGScheduler 
TaskScheduler
Job -> Stage -> Task




# DAGScheduler 
  - RDD
  - DAG
  - stage

# TaskScheduler
  - executor
  

# 接口
  - transformation
  - action
  
# 广播变量

# DataFrame DataSet

# 对比MR


# 应用
  - topK
```

## RDD partition个数 = task个数
1. 理论上最好是k * (#of executors * #of cores for each executor)，充分利用集群资源
2. 实际上
  - 在map端，比如读取HDFS数据，sc.textFile(path, minPartitions)，partition个数默认block数，如果指定minPartitions则为该值
  - reduce端，task个数 = stage第一个rdd(shuffledRDD)partition数，该值又取决于Partitioner，默认参数spark.defalut.parallelism, spark.sql.shuffle.partitions，
    可以显示指定，比如reduceByKey(partitioner, func), reduceByKey(func, numPartitions)
  
  
## shuffle
1. partitioner
  - HashPartitioner(default), 算法hash(key)% reduce tasks, 数据倾斜
  - RangePartioner(采样，均衡分割点）
  
2. shuffle算子
  - 聚合 reduceByKey, distinct, groupByKey, aggregateByKey
  - 排序 sortByKey, sortBy
  - 重分区 coalesce, repartition
  - 表操作 join, cogroup intersection, subtractByKey
  
3. 数据倾斜
  - 弊端：无法充分并行，oom
  - 解决方案
    - 预聚合 reduceByKey(combiner)代替groupByKey(没有combiner)
    - join
      - co-partition [(id, score, email)](https://cloud.tencent.com/developer/article/1390312)
      - broadcast + map
      - 

4. shuffle机制


## API
1. transformation(lazy)
  - map, flatmap, mapPartitions
  - reduceByKey, distinct, groupByKey, aggregateByKey, sortByKey, sortBy, coalesce, repartition, join, cogroup, intersection, subtractByKey
  - cache, persist 
2. action
  - reduce, count, take, collect, foreach
  - saveAsTextFile




## 性能调优
1. 重复使用rdd持久化（重新计算RDD的时间资源与缓存RDD的内存资源之间进行权衡）
2. 高性能算子
  - 使用mapPartitions替代普通map，特别是在写DB的时候，避免每条写记录都new一个connection
  - 使用filter之后进行coalesce操作，减少小文件数量
3. 解决数据倾斜



## topK全局有序
sortByKey + partitioner
partitioner根据数据范围来分区，使得p1所有数据小于p2，p2所有数据小于p3, sortByKey保证partition内部有序


## Streaming
累加器一个比较经典的应用场景是用来在Spark Streaming应用中记录某些事件的数量。


