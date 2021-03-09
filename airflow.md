1. 应用场景
  - built primarily for data batch processing
 
  - schedule 
    - cron on a timely basis
    - sensors checking for a certain file becoming available on S3 
    - custom operators built for running workflows on complex schedules that dynamically update
    
  - workflow orchestration


2. [功能](https://robinhood.engineering/why-robinhood-uses-airflow-aed13a9a90c8)
  - dependencies management
    - Operators
      - sensors
      - transfer
      - action
      
    - DAG

  - failure handling
    - configure retry policies

  - alerting
    - set up alerting in the case of failures, retries, as well as tasks running longer than expected

  - monitoring
    - historical views of the jobs
    - build custom visualizations to monitor the jobs (also acts as a great debugging tool)
    - aggregate certain metrics or add new metrics
    
  - manage
    - tools to control the state of jobs, such as kill a running job or manually re-running a job.
  



3. 架构
  
  
4. 代码示例
  - [Airflow run Spark scala code](https://stackoverflow.com/questions/39827804/how-to-run-spark-code-in-airflow)
