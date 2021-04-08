### Azure Data Lake Storage (ADLS) Gen2

### Azure HDInsight 

### Azure Synapse Analytics
- [Synapse: SQL, Spark, Pipeline](https://docs.microsoft.com/en-us/azure/synapse-analytics/overview-what-is)

- [Dedicated SQL pool, DWU, Distributions](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/massively-parallel-processing-mpp-architecture)

- [DWU status](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/what-is-a-data-warehouse-unit-dwu-cdwu)

- [COPY statement](https://docs.microsoft.com/en-us/sql/t-sql/statements/copy-into-transact-sql?view=azure-sqldw-latest&preserve-view=true)

- [PolyBase](https://docs.microsoft.com/en-us/sql/relational-databases/polybase/polybase-guide?view=sql-server-ver15)

- Connect:
  - Visual Studio and SSDT
  - SSMS
  - Sqlcmd
  - Azure portal
  
  

### Azure Stream Analytics

### Azure Cosmos DB



### Azure Data Factory
### Azure Databricks


```

———————————————————— Ingestion ——————————————————————

AWS Data Pipeline
automate data movement, launches and manages EMR clusters and EC2 instances to execute jobs

AWS Glue
serverless spark environment ETL service

Azure Data Factory
serverless data integration service to orchestrate and automate ETL workflows



Azure HDInsight Kafka
stream ingestion

Azure Event Hub
scalable auto-inflate throughput units


———————————————————— Persistence ——————————————————————

Azure Blob Storage
general purpose object store

Azure Data Lake Storage (ADLS) Gen2
additional hierarchical namespace to blob storage

Hierarchical FS vs Object Store
retrieve subset data/partition scan
relocate 10,000 files one directory to another//10,000 rename operations + 10,000 delete operations
//metadata operation/atomic operation/data consistency


AWS Athena
serverless interactive SQL on S3 

Azure Data Lake Analytics (ADLA)
serverless analytics service in U-SQL


———————————————————— Analytics ———————————————————————

Azure HDInsight 
cloud distribution of Hadoop components

Azure Databricks
spark-based analytics platform

Azure Stream Analytics
serverless streaming pipeline using SQL
streaming units (SU)




—————————————————Data Warehouse and DB————————————————————
AWS RDS
AWS Aurora
Azure SQL Database (SQL Server)
OLTP vertical scale



Azure Database for MySQL
Azure Database for PostgreSQL


AWS Redshift
Azure Synapse Analytics 
data warehousing and big data analytics
serverless on-demand or provisioned resources
OLAP horizontal scale




AWS DynamoDB
Azure Cosmos DB
NoSQL supports different models, including k-v, document, wide column and graph
request units (RU)



—————————————————— Monitoring ——————————————————————————

Azure Monitor
collect performance metrics Azure services





——————————————————— Pipeline ———————————————————————————

raw data is ingested through Azure Data Factory in batches, or streamed using Kafka or Azure Event Hub, 
lands in long-term persistence Azure Blob Storage or Azure Data Lake Storage (ADLS) Gen2
analytics workflow - Azure Databricks read from multiple data sources then deliver insights to Cosmos DB


ingested through Kafka, 
then processed by Stream Analytics, HDInsight Spark
loaded to Cosmos DB document as JSON document




Azure Active Directory
AWS IAM






```

