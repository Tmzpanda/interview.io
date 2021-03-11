# Architecture
```
- Application (Pipeline)
- Platform (DevOps)
- Infra (K8s)


```



# Application
```
- Batch

  HDFS          -->        Spark             -->         Hive (BI)
  RDB                      RDD
  FINEOS                   DataFrame
  static files


- Stream

  Kafka         -->        Structured Streaming          -->          HBase (DB)
  FINEOS
 
 
```


# Platform

![devops-platform](img/devops-platform.jpg)
Platform图







## Deploy CI/CD
  - CI: GitLab + Jenkins + Job Server RestAPI(返回execution summary)
  - CI + CD (dev, QA, prod 依次部署？？) -> docker kubernetes
  - 没有版本更新 单纯run一遍job
  - 新数据trigger某个job如何设置？？



## batch job automation
- Manage多条??: 
  - Nexus repository??
  - CI/CD看同时运行的pipeline？Docker? Monitor??
  - Airflow schedule ?？？ 应用场景：新数据trigger某个job？？
  - Job server???



job server
- execution summary
- recover machinism
- log hdfs path



- scheduling spark jobs on a timely basis  
- trigger

autosys - define, schedule, monitor
used for controlling the unattended execution of a batch processing instructions which includes series of a program being executed at once.
crontab - running scheduled sparrk job periodically # cron
azkaban

Recovery mechanism and error management
monitor the executions and analyze the results



Job history and configuration logged to a database


Job history and configuration logged to a database
logs (specify a location to deliver Spark driver, worker, and event logs)


## Monitor: 
- 目的
  - design optimizaiton
  - failures alert
  - troubleshoot failures

- 手段
  - Ambari/Yarn/Spark UI
  - RestAPI
  - [Metric Sink + Graphite Gafana](https://spark.apache.org/docs/latest/monitoring.html#metrics)
  - SparkListener/StreamingQueryListener
  - Log
  
- metrics
  - core infrastructure metrics
  - app performance metrics

- 
e.g. 
1. [Spark执行卡住或过慢时](http://jason4zhu.blogspot.com/2018/05/spark-slow-debug-on-yarn-webpage.html)
2. [数据倾斜](https://tech.meituan.com/2016/05/12/spark-tuning-pro.html)
3. [性能调优](https://www.cnblogs.com/xinfang520/p/8033958.html)



    

## Dev
- 代码dev
  - 连接kafka
  - 连接mysql
  - 连接FINOS

- Debug
  - connection between IDE and data environment

- test
  - unit test, regression test
  - ist
  - uat

- spark/streaming job挂了 ？ 看log？monitor？




## data quality
[deequ](https://github.com/awslabs/deequ)
- explicitly state assumptions on data, add checks that define constriants on attributes.
- constraints verification, anomaly detection, validation rules




# Infra：
  - Kafka partition
  - HBase 
    - 10TB/week
    - 3 major table: case, claim, repeal
    - 3 column families with maximum 200 columns
    - automatic major compaction disabled

