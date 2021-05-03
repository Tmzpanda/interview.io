/**************************************************** scala collection ********************************************************/
// Array
val arr = Array("a", "b", "b", "b", "c", "c")
arr.groupBy(identity).mapValues(_.size).toSeq.sortBy(_._2).reverse.map(_._1).take(3)


// Seq
val seq = Seq(("DEPT1", 1000), ("DEPT1", 500), ("DEPT1", 700), ("DEPT2", 400), ("DEPT2", 200),  ("DEPT3", 500), ("DEPT3", 200))
seq.map(e => (e._1, e._2 + 100))
seq.toMap
seq(2).getClass

val seq2 = ("DEPT0", 400) +: seq :+ ("DEPT4", 300)
val seq3 = seq ++ seq2


// ArrayBuffer
import scala.collection.mutable.ArrayBuffer
val arr = ArrayBuffer(1, 2, 3)
arr += 4


// Set 
import scala.collection.mutable.Set
val set = Set(1, 2, 3, 4)
set -= 4
set --= List(2, 3)

// Map
import scala.collection.mutable.Map
val map = Map("AL" -> "Alabama")
map += ("AR" -> "Arkansas")
map -= "AL"
map.get("AR")    // Option[T]
map.getOrElse("IL", "Not Found")



// function
def topKFrequent(nums: Array[String], k: Int): Array[String] = {
  nums
  .groupBy(identity)
  .mapValues(_.size)
  .toArray
  .sortBy(_._2)
  .reverse
  .map(_._1)
  .take(k)
}
topKFrequent(nums, k)


// recursion and tail recursion
def factorial(n: Int): Int = {
  if (n <= 1) 1
  else n * factorial(n - 1)
}

import scala.annotation.tailrec
def tailRecFactorial(n: Int): BigInt = {
    @tailrec
    def factorialHelper(x: Int, accumulator: BigInt): BigInt = {
      if (x <= 1) accumulator
      else factorialHelper(x - 1, x * accumulator)
    }
    factorialHelper(n, 1)
  }

// level order traversal
object Solution {
  def levelOrder(root: TreeNode): List[List[Int]] = levelOrder(Option(root).toList)

  @scala.annotation.tailrec
  private def levelOrder(nodes: List[TreeNode], traversal: List[List[Int]] = List()): List[List[Int]] = {
    if (nodes.nonEmpty) {
      levelOrder(nodes.flatMap(node => Seq(Option(node.left), Option(node.right)).flatten), traversal :+ nodes.map(_.value))
    } else {
      traversal
    }
  }
}



/**************************************************** create dataframe ********************************************************/
// Seq
import spark.implicits._
val df = Seq(("DEPT1", 1000), ("DEPT1", 500), ("DEPT1", 700), ("DEPT2", 400), ("DEPT2", 200),  ("DEPT3", 500), ("DEPT3", 200))
         .toDF("department", "salary")

// csv
import spark.implicits._
val df = spark
        .read
        .option("header", "true")
        .csv("src/main/resources/questions_10K.csv") // json, text, parquet
        .toDF("id", "creation_date", "closed_date", "deletion_date", "score", "owner_user_id", "answer_count")

df.write
  .parquet("file.parquet")

df.write
  .format("csv")
  .save("file_path")


// hive
val spark = SparkSession
  .builder()
  .appName("Spark-Hive")
  .config("spark.sql.warehouse.dir", warehouseLocation)
  .enableHiveSupport()
  .getOrCreate()

import spark.implicits._
import spark.sql
val df = sql("SELECT key, value FROM src WHERE key < 10 ORDER BY key")

df.write.
  mode(SaveMode.Overwrite).
  saveAsTable("hive_records")


// jdbc
val df = spark.read
    .jdbc("jdbc:mysql://localhost:3306", "employees.dept_emp", connectionProperties)
    .toDF("Employee ID", "Department Code", "From Date", "To Date")



// rdd to df
val rdd = sc.parallelize(Seq(("Sales", 101, 30000), ("IT", 203, 40000)))
val rdd = sc.textFile("file.txt")

import spark.implicits._
val df = rdd.toDF("department", "eid", "salary")
val df = spark.createDataFrame(rdd).toDF("department", "eid", "salary")


// Dataset -> type safe 
// Dataframe: Dataset[Row]
case class Record (department: String, eid: Double, salary: Double)
import spark.implicits._
val ds = df.as[Record]  // implicit conversion

val data = Seq(Person("Bob", 21), Person("Mandy", 22), Person("Julia", 19))
val ds = spark.createDataset(data)




/**************************************************** dataframe SQL ********************************************************/
// window function
import sparkSession.implicits._
val df = Seq(("DEPT1", 1000), ("DEPT1", 500), ("DEPT1", 700), ("DEPT2", 400), ("DEPT2", 200),  ("DEPT3", 500), ("DEPT3", 200))
         .toDF("department", "salary")

df.withColumn("rank", dense_rank().over(Window.partitionBy($"department").orderBy($"assetValue".desc))).filter("rank = 1").show


// aggregation function
df.groupBy($"department").count.orderBy($"count".desc).limit(2)   // return a df
df.groupBy($"department").agg(count($"eid"), mean($"salary")).show


// filter
val items = List("a", "b", "c")
val items = df1.select("department").distinct.map(x=>x.getString(0)).collect.toList
df.filter(!$"department".isin(items:_*))   // unpack the list into arguments with the :_* operator


// join
df.join(df1, df("department") === df1("department"), "left_anti").show














