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

## 1. RDD partition个数 = task个数
1. 理论上最好是k * (#of executors * #of cores for each executor)，充分利用集群资源
2. 实际上
  - 在map端，比如读取HDFS数据，sc.textFile(path, minPartitions)，partition个数默认block数，如果指定minPartitions则为该值
  - reduce端，task个数 = stage第一个rdd(shuffledRDD)partition数，该值又取决于Partitioner，默认参数spark.defalut.parallelism, spark.sql.shuffle.partitions，
    可以显示指定，比如reduceByKey(partitioner, func), reduceByKey(func, numPartitions)
  
  
## 2. shuffle
1. partitioner
  - HashPartitioner(default), 算法hash(key)% reduce tasks, 数据倾斜
  - RangePartioner(抽样，均衡分割点）
2. shuffle算子
  - 聚合 reduceByKey, distinct, groupByKey, aggregateByKey
  - 排序 sortByKey, sortBy
  - 重分区 coalesce, repartition
  - 表操作 join, intersection, subtractByKey
  
3. 数据倾斜
  1. 
  2. 解决方案
    - 预聚合

