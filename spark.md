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
  
  
# Shared variables
  - broadcast
  - accumulator
  
  
# API
  - transformation
  - action
  
# DataFrame 
# DataSet


# Streaming

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
    - join避免shuffle
      - co-partition (如果join之前，rdd1进行reduceByKey, 将此partitioner设置为另外一个rdd2的partitioner)
      - broadcast + map (大小表)
      - hot key  
        - 几个数据量过大的key：采样倾斜key并分拆join操作，最后union。
        - 大量倾斜key：两阶段聚合（局部聚合+全局聚合），将原本相同的key通过附加随机前缀的方式，变成多个不同的key，就可以让原本被一个task处理的数据分散到多个task上去做局部聚合，进而解决单个                        task处理数据量过多的问题。接着去除掉随机前缀，再次进行全局聚合，就可以得到最终的结果。
                
4. [shuffle机制（序列化，磁盘io，网络io）](https://zhuanlan.zhihu.com/p/70331869)
  - HashShuffleManager
    - consolidate机制
  - SortShuffleManager
    - 普通
    - bypass机制

## 共享变量
1. broadcast：
  - 在每台计算机上保留一个只读变量，而不是将其副本与任务一起发送。
  - 应用场景：broadcast+map代替join
2. 累加器
  - 变量副本传到远程集群执行，这些变量更新不会传回driver（计算移动)。driver可以读取累加器的值。
  - 一个比较经典的应用场景是用来在Spark Streaming应用中记录某些事件的数量
  

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
1. sortByKey + partitioner
  - partitioner根据数据范围来分区，使得p1所有数据小于p2，p2所有数据小于p3, sortByKey保证partition内部有序
2. heap


## [RDD, DF, DS](https://blog.csdn.net/muyingmiao/article/details/102963103)



