# Hadoop



## HDFS
1. 节点
  - name node/metadata/memory
     - SPOF
        - 1.x secondary namenode/checkpoint/fsimage and edits
        - 2.x HA standby namenode
     - HDFS Federation/multiple independent namenodes

  - data node/store data as blocks/disk
    - SPOF/replicas
    
2. [读写流程](https://www.cnblogs.com/feiyumo/p/12541296.html)

3. 小文件
  - 弊端：
    - metadata比例大
    - 框架消耗时间比例多
  - 解决方案： [merge](https://blog.csdn.net/shudaqi2010/article/details/85237535)




## MapReduce
1.x/JobTracker/TaskTacker
2.x/Yarn/resource manager/node manager/application master daemons

mapper/extract info into k-v pairs/local disk输出数据在本地磁盘，等待reducer拉取
combiner/local aggregation/save bandwidth

partitioner/decide
shuffle/transfer
sort/merge
reducer/aggregate/HDFS


## Yarn
job scheduling
cluster resource management

capacity scheduler/job submitted to specific queue/FIFO
resource manager/node manager/application master

NameNode/ResourceManager/HMaster
DataNode/NodeManager/RegionServer




```

