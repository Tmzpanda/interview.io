## HDFS
1. 优劣
  - 优点：
    - 1. 存储大文件
    - 2. 高吞吐量。一次写多次读，读取整个数据集的时间延迟比读取第一条记录的时间延迟更重要，流式读取只需要寻址一次。
        （与之相对是随机数据访问，要求定位查询修改延迟小，RDB多次读写很符合）
  - 缺点：
    - 1. 高延迟（不支持文件随机修改，只支持追加写入。）
    - 2. 小文件：
      - metadata比例大，namenode内存消耗严重。
      - 解决方案：merge: [Hadoop Archive，Sequence file和CombineFileInputFormat](https://developer.aliyun.com/article/373605).

2. 节点
  - name node/metadata/memory
     - SPOF
        - 1.x secondary namenode/checkpoint/fsimage and edits
        - 2.x HA standby namenode
     - HDFS Federation/multiple independent namenodes

  - data node/store data as blocks/disk
    - SPOF/replicas
    
3. 读写流程
  - 读：
    - 1. client端发送读文件请求给namenode，如果文件不存在，返回错误信息，否则，将该文件对应的block及其所在datanode位置发送给client。
    - 2. client收到文件位置信息后，与不同datanode建立socket连接并行获取数据。
  - 写：
    - 1. client端发送写文件请求，namenode检查文件是否存在，如果已存在，直接返回错误信息，否则，发送给client一些可用datanode节点。
    - 2. client将文件分块，并行存储到不同节点上datanode上，发送完成后，client同时发送信息给namenode和datanode。
    - 3. namenode收到的client信息后，发送确信信息给datanode。
    - 4. datanode同时收到namenode和datanode的确认信息后，提交写操作。   


4. 文件格式
  - 结构化 vs 半结构化 vs 非结构化
    - 结构化: 查询修改容易，但字段扩展性不好。如csv
    - 半结构化：扩展性很好，不同数据的属性的个数不同，属性顺序不重要。如json
    - 非结构化
    
  - 行式 vs 列式：
    - 行式：OLTP
      - 随机的增删改查
      - 查询只涉及少数属性也必须读取完整行记录，读取效率低 -> 索引优化
      - Avro
      
    - 列式：OLAP
      - 查询某列属性的数据记录，只需返回与列属性相关的值，避免全表扫描，减少IO消耗。
      - 各列独立存储，且数据类型已知，可以针对该列的数据类型、数据量大小等因素动态选择压缩算法。
      - HBase
      - Hive
      - Parquet
      - ORC
      -
    
    
  
  
    



## MapReduce
1. 资源管理
  - 1.x/JobTracker/TaskTacker
  - 2.x/Yarn/resource manager/node manager/application master daemons

2.阶段
  - mapper/extract info into k-v pairs/local disk输出数据在本地磁盘，等待reducer拉取
  - combiner/local aggregation/save bandwidth
  
  - partitioner/decide
  - shuffle/transfer
  - sort/merge
  - reducer/aggregate/HDFS


## Yarn
1. 功能
  - job scheduling
  - cluster resource management

2. 节点
  - resource manager
  - node manager -> application master  
 
3. [资源调度过程](https://www.jianshu.com/p/2c2a1c79add9)


```

