# Spark



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
  - stream: necessary for stateful transformations: e.g. updateStateByKey, reduceByKeyAndWindow 

- **code changes**
  - impractical to deploy **code changes**(trying to deserialize objects with modified classes may lead to errors, either start the upgraded app with a different checkpoint directory, or delete the previous checkpoint directory)





   
    
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
       

  - ~~Direct DStream~~
  
  
- spark-streaming-kafka-0-10_2.12 (spark streaming)
  - Direct DStream
    - uses Kafka as a replicated log (fault-tolerance, **at least once**, rather than using receivers), Spark RDD partition与Kafka topic partition一一对应。
    - [offset management to achive **exactly-once**](https://spark.apache.org/docs/latest/streaming-kafka-0-10-integration.html#storing-offsets)
      - checkpoint: 
        - code change issue
    
      - kafka
        - sets```enable.auto.commit```to false (messages successfully polled by the ***consumer*** may not yet have resulted in a Spark ***output operation***)
          commit offsets to Kafka after you know your output has been stored, using the ```commitAsync``` API.
        - compared to checkpoints, code change acceptable
        
      - own data store
        - transaction
        - idempotent
  
  




- spark-sql-kafka-0-10_2.12 (structure streaming)


    
    
## Fault-tolerance
- yarn configuration: set up automatic restart for drivers
```bash
spark.yarn.maxAppAttempts = 4   
spark.yarn.am.attemptFailuresValidityInterval=1h    

```
- meta checkpointing
- WAL
- 




## upgrading application code
## shutdown
- use a marker file that is created on HDFS when starting the application, then removed when you want to stop
```scala
streamingContext.stop(stopSparkContext = true, stopGracefully = true)
```







