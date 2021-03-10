## Streaming + Kafka Integration

- [~~spark-streaming-kafka-0-8 (deprecate)~~](https://blog.csdn.net/qq_17310871/article/details/104899853)
  - ~~Receiver DStream~~
    ```bash
    spark.streaming.receiver.writeAheadLog.enable=true
    StorageLevel.MEMORY_AND_DISK  // disable in-memory DStreams replication  
    ```  
    - Kafka high-level API，offset存在zookeeper中，用户不用关心offset。
    - WAL (fault-tolerance, **at least once**)
       - each received event is first written to Spark's **checkpoint directory** in fault-tolerant storage
       - 数据延迟，减少吞吐量。
  
  
- spark-streaming-kafka-0-10_2.12 (spark streaming)
  - [Direct DStream](https://spark.apache.org/docs/latest/streaming-kafka-0-10-integration.html)
    ```
    val kafkaParams = Map[String, Object](
      "bootstrap.servers" -> "localhost:9092,anotherhost:9092",
      "key.deserializer" -> classOf[StringDeserializer],
      "value.deserializer" -> classOf[StringDeserializer],
      "group.id" -> "use_a_separate_group_id_for_each_stream",
      "auto.offset.reset" -> "latest",
      "enable.auto.commit" -> (false: java.lang.Boolean)
    )

    val topics = Array("topicA", "topicB")
    val stream = KafkaUtils.createDirectStream[String, String](
      streamingContext,
      PreferConsistent,                                 // distribute partitions evenly across available executors
      Subscribe[String, String](topics, kafkaParams)    // subscribe to a fixed collection of topics
    )

    stream.map(record => (record.key, record.value))    
    
    ```
    - uses Kafka as a replicated log (fault-tolerance, **at least once**, rather than using receivers), Spark RDD partition与Kafka topic partition一一对应。
    - **exactly-once**: foreachRDD()默认at-least-once的(如果输出过程中出错，会重复执行直到写入成功), to achieve exactly-once，可以施加两种限制之一：幂等性和事务性写入。
        - idempotent output（then store offsets）
            - 消息中包含唯一主键，那么多次写入相同的数据也不会在产生重复记录。 
            - 适用于 map-only（没有 shuffle、reduce、repartition 等操作）的计算流程（这种流程下Kafka分区和RDD分区是一一对应）。
            - e.g. Kafka, HBase(uniqe row-key)
        - transaction output (store offsets alongside)
            - 在一个transaction中写入result和写入offset，如果重复处理数据或者offset写入失败，事务就会回滚。
            - 引入一个唯一id（topic, partition, timestamp, offset共同组成）标识当前处理逻辑。
            - 同时适用于map-only和aggregation的计算流程。
            - [代码示例](https://spark.apache.org/docs/latest/streaming-kafka-0-10-integration.html#your-own-data-store)

    - [offset management](https://spark.apache.org/docs/latest/streaming-kafka-0-10-integration.html#storing-offsets)
      - checkpoint: 
        - code change issue
    
      - kafka
        - sets```enable.auto.commit```to false (messages successfully polled by the ***consumer*** may not yet have resulted in a Spark ***output operation***)
          commit offsets to Kafka after you know your output has been stored, using the **[commitAsync](https://stackoverflow.com/questions/46546174/kafka-consumer-commitsync-vs-commitasync/48264461)** API.
        - compared to checkpoints, code change acceptable
        - outputs must still be idempotent (Kafka is not transactional)
        
      - own data store
        - store offsets in an atomic transaction alongside output
        - store offsets after an idempotent output
        
 
- spark-sql-kafka-0-10_2.12 (structure streaming)
    - 对比 DStream: 
        - DStream 只能保证自己的一致性语义是 exactly-once 的，而 input 接入 Spark Streaming 和 Spark Straming 输出到外部存储的语义往往需要用户自己来保证。比如为了保证 output 的语义是 exactly-once 语义需要 output 的存储系统具有幂等的特性，或者支持事务性写入。
        - Structured Streaming 和内置的 connector 使的 end-to-end 程序写起来非常的简单，而且 "correct by default"。数据源和 sink 满足 "exactly-once" 语义，这样我们就可以在此基础上更好地和外部系统集成。性能方面，通过复用 Spark SQL Engine 来保证高性能。
    - exactly-once
        - streaming source: offset to track the read position in the stream, replayable
        - execution engine: checkpointing and WAL to record the offset range of the data being processed in each trigger
        - streaming sinks: idempotent 

     
## Fault-tolerance
- yarn configuration: set up automatic restart for drivers
```bash
spark.yarn.maxAppAttempts = 4   
spark.yarn.am.attemptFailuresValidityInterval=1h    

```
- meta checkpointing
- WAL


## [checkpoint](http://spark.apache.org/docs/2.0.2/streaming-programming-guide.html#checkpointing)
```scala
def functionToCreateContext(): StreamingContext = {
    val ssc = new StreamingContext(...)   
    val lines = KafkaUtils.createStream(...)
    ssc.checkpoint(checkpointDirectory)   // set checkpoint directory
}
 
// Get StreamingContext from checkpoint data or create a new one
val context = StreamingContext.getOrCreate(checkpointDirectory, functionToCreateContext _)

context.start()
context.awaitTermination()
```

- metadata checkpoint: used to recover from **failure of driver node**
  - metadata
    - Configuration 
    - DStream operations
    - Incomplete batches 

- data checkpointing: 
  - batch: 基于lineage的计算浪费性能（DAG过长或宽依赖），checkpoint到hdfs上。
  - stream: necessary for stateful transformations (maintain state between micro batches, achieved by checkpoints on streaming applications): e.g. updateStateByKey, reduceByKeyAndWindow 

- **code changes**
  - impractical to deploy **code changes**(trying to deserialize objects with modified classes may lead to errors, either start the upgraded app with a different checkpoint directory, or delete the previous checkpoint directory)



## shutdown and upgrading application code
- use a **marker file** that is created on HDFS when starting the application, then removed when you want to stop
```scala
streamingContext.stop(stopSparkContext = true, stopGracefully = true) // use a separate thread 

```







