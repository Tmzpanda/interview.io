```
# 








```





## 表结构
1. 逻辑上：row-key, column family, column qualifier, version(timestamp)
2. 物理上：HFile按CF存储，按照Row-key将相关CF中的列关联起来
 

## HBase集群
1. Zookeeper
  - HBase Master的HA解决方案
  - Region Server和Region的注册

2. HMaster
  - 协调多个Region Server, 侦测各个Region Server之间的状态，并平衡Region Server之间的负载。
  - 给Region Server分配Region 
  - failover: 一个Master提供服务，其他Master待命。当正在工作的Master节点宕机时，其他的Master接管。

3. HRegionServer
  - HRegionServer: 响应用户IO请求,实现读写操作。
  - HRegion
    - 真实存放数据的地方，HBase分布式的基本单位。每个Region都只存储一个Column Family的数据，并且是该CF中的一段（按Row的区间分成多个Region）
    - Region达到存储数据上限时（Threshold），Region会进行分裂，数据也会分裂到多个Region 中，这样便可以提高数据的并行化，以及提高数据的容量。
    - 每个Region包含着多个Store对象。每个Store包含一个MemStore，和一个或多个HFile。
    - 数据写入Region过程：
      - 先写入 MemStore
      - 当 MemStore 中的数据需要向底层文件系统倾倒（Dump）时，Store便会创建StoreFile（对HFile一层封装），MemStore中的数据会最终写入到HFile中，也就是磁盘 IO。
      - 由于HBase底层依靠HDFS，因此HFile都存储在HDFS 之中。
  - HLog: 数据可靠性, WAL(write-ahead-log)
    - 每个Region Server都有一个HLog的实例。Region Server将更新操作（如Put，Delete）先记录到 WAL（HLog），然后将其写入Store的MemStore，最终MemStore会将数据写入到持久化的HFile。
  


## 读写流程

## compaction


## Row-key设计

## Spark load to HBase


Hbase
NoSQL/distributed scalable/column oriented/random access/schema-less/HDFS

CAP/Consistency/Availability/Partition tolerance

Zookeeper/HMaster HA/service registry 
HMaster/assign regions load balancing/failover
Region servers/regions management/read write requests

HLog/recover not-yet-persisted data
MemStore
HFile/Row-key:CF:Column-key:Value/HDFS
BlockCache

Phoenix/OLTP ACID/SQL schema-on-read/JDBC 
ACID transaction/Atomicity/Consistency/Isolation/Durability



然后当用户按照 Row-key 查询数据的时候，HBase 会遍历两个 HFile，通过相同的 Row-Key 标识，将相关的单元格组织成行返回，这样便有了逻辑上的行数据
