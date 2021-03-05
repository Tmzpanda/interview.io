```
- Batch

  HDFS          -->        Spark             -->         Hive
  RDB                      RDD
  FINEOS                   DataFrame
  static files


- Stream

  Kafka         -->        Structured Streaming          -->          HBase
  FINEOS
 
 





```


- 代码dev

- Debug



## Deploy CI/CD
  - CI: GitLab + Jenkins + Job Server RestAPI(返回execution summary)
  - CI + CD


- Manage多条??: Nexus repository?? CI/CD看同时运行的pipeline？Docker?


## Monitor: 
  - 目的
    - cluster performance stats
    - failures alert
    
  - 手段
    - Ambari/Yarn/Spark UI
      - metrics
      - 
    - RestAPI
    - Metric Sink + Graphite Gafana
      - metrics


- Alert: SparkListener 记录log 报警jira 和email


- Fault-tolerance
  - HA
    - MasterNode + ZooKeeper
    - Worker
  - 代码层面
  




- 集群物理资源：
  - Kafka partition
  - HBase 
    - cluster
    - table个数
        
  - 
