```
Producer ------------------- Broker  ------------------- Consumer
HA                           topic                       consumer group
                             partitions                  API
                       
                  
## Message queue

## Structured streaming read from kafka

                                                      

```

## producer
1. producer在发送消息的时候，
  - 必须指定topic和data
  - 可以选择指定key，相同key去往同一partition，不指定就round-robin
  - 每条消息都被append到patition中，属于顺序写磁盘（顺序写磁盘效率比随机写内存要高，保障kafka吞吐率）。
  
2. HA
  - ack=0, producer won't wait for acknowledgement(possible data loss)
  - ack=1, leader acknowledgement (limited data loss)
  - ack=all, leader+replica acknowledgement (no data loss)
  
   
 

## broker
1. controller：Kafka集群中的其中一个Broker会被选举为Controller，主要负责Partition管理和副本状态管理。
  - 客户端创建一个topic时，只需要和zookeeper通信，设置partitions、replication-factor。
  - controller在ZooKeeper注册 watcher，当topic被创建，则controller会得到该topic的partition/replica分配。
  - 分配topic的partition，还要选出partition的leader，以及ISR等这些工作，都是由controller完成。

2. 多个partition可以并行处理数据
  - partition的leader才会进行读写操作，folower仅进行复制
  - broker宕掉之后，从ISR(in-sync replica)列表中重新选举partition的leader
  
  


## consumer
1. consumer group
  - consumer
    - 各个consumer控制和设置其在该partition下消费到offset位置，这样下次可以以该offset位置开始进行消费。
    - 各个consumer的offset位置默认是在某一个broker当中的topic中保存的。
    
  - consumer instance个数和partition个数
    - consumer比partition少，一个consumer会对应于多个partitions
    - consumer比partition多，浪费，因为一个partition上是不允许并发的
    
  - consumer group
    - 多个consumer instances从多个partition读到数据，kafka对多个partition间不保证数据间的顺序性，只保证在一个partition上数据是有序的。
    - rebalance
      - 增减consumer，partition会导致rebalance，所以rebalance后consumer instance对应的partition会发生变化
      - Group Coordinator负责发起Consumer Rebalance, Group Leader（第一个加入consumer group的consumer）负责执行。
      - 策略：
        - range
        - round robin


2. Delivery semantics - consumers choose when to commit offsets
  - at most once, 收到消息就commit，处理错误也不会重读
  - at least once(preferred), 处理完才commit, 处理错误会重读。需要保证幂等性（两次处理不会影响系统）
  - exactly once, kafka->kafka workflows using Stream API
  

3. Consumer API
  - High Level API: 
    - 它屏蔽了Topic的每个Partition的Offset管理(意味着，1.消费过的数据无法再次消费，如果想要再次消费数据，要么换另一个group 2.必须记录每次消费的位置，提交                                     TopicAndPartition的offset),
    - Broker失败转移, 
    - 以及增减Partition、Consumer时的rebalance.
  - Low Level API:
    - 对消费Kafka Message更大的控制（可重复读，跳读）



## message queue对比
1. 相同：解耦、异步
2. 不同：mq message once consumed, it get removed, can't be read by other consumer group
  


## structured streaming read from kafka
```scala
val df = spark
  .readStream
  .format("kafka")
  .option("kafka.bootstrap.servers", "host1:port1,host2:port2")
  .option("subscribe", "topic1,topic2")           // multiple topics
  .option("startingOffsets", """{"topic1":{"0":23,"1":-2},"topic2":{"0":-2}}""")
  .option("endingOffsets", """{"topic1":{"0":50,"1":-1},"topic2":{"0":-1}}""")
  .load()                                         // default #of consumer instances = #of partition number = #of topic partitions

  
df.selectExpr("CAST(key AS STRING)", "CAST(value AS STRING)")
  .as[(String, String)

```


