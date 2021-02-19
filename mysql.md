## 架构
![mysql-architecture](img/mysql-architecture.jpg)




## 读写
1. redo log

## 存储引擎InnoDB vs MyISAM


## 索引
1. 利弊
    - 优: 提升检索效率
    - 缺: 索引文件占用磁盘空间，降低了增删改的执行效率。


2. 数据结构
    - [B树](https://www.youtube.com/watch?v=aZjYr87r1b8&ab_channel=AbdulBari): 
        - 多路平衡查找树
        - 内部节点有record pointer
    - B+树: 
        - 内部节点无record pointer，只有叶子节点有record pointer -> 磁盘IO次数少，查询效率高              
        - 叶子节点LinkedList -> b+范围扫描简单，b则需要在叶子节点和内部节点往返移动

            
3. 类型
    - 普通索引 - 直接创建/修改表结构的方式添加索引/创建表的时候同时创建索引
    - 唯一索引 - 索引列的值必须唯一，但允许有空值。如果是组合索引，则列值的组合必须唯一。
    - 全文索引 - 主要用来查找文本中的关键字，而不是直接与索引中的值相比较。
    - 主键索引 - 一种特殊的唯一索引，一个表只能有一个主键，不允许有空值。一般是在建表的时候同时创建主键索引。
    - 组合索引
        - 只有在查询条件中使用了创建索引时的第一个字段，索引才会被使用。
        - 最左匹配(col1, col2, col3) -> (col1), (col1, col2), (col1, col2, col3)

4. SELECT语句命中情况
          

## Transaction 
[详见](https://www.cnblogs.com/tgycoder/p/5410537.html)


## 锁
1. 死锁：[详见](https://www.cnblogs.com/tgycoder/p/5410537.html)
2. 隔离等级
    - Read uncommitted：一个事务会读到另一个事务更新后但未提交的数据，如果另一个事务回滚，那么当前事务读到的数据就是脏数据，这就是脏读（Dirty Read）。
    - Read committed
        - 在一个事务内，多次读同一数据，在这个事务还没有结束时，如果另一个事务恰好修改了这个数据，那么，在第一个事务中，两次读取的数据就可能不一致。
        - 不可重复读重点在于update和delete，而幻读的重点在于insert。
    - Repeatable read
        - 在一个事务中，第一次查询某条记录，发现没有，但是，当试图更新这条不存在的记录时，竟然能成功，并且，再次读取同一条记录，它就神奇地出现了。(幻读)
        - 在可重复读中，该sql第一次读取到数据后，就将这些数据加锁，其它事务无法修改这些数据，就可以实现可重复读了。
          但这种方法却无法锁住insert的数据，所以当事务A先前读取了数据，或者修改了全部数据，事务B还是可以insert数据提交，这时事务A就会 发现莫名其妙多了一条之前没有的数据，这就是幻读，不能通过行锁来避免。需要Serializable隔离级别 ，读用读锁，写用写锁，读锁和写锁互斥，这么做可以有效的避免幻读、不可重复读、脏读等问题，但会极大的降低数据库的并发能力。
          
    - Serializable：是最严格的隔离级别。在Serializable隔离级别下，所有事务按照次序依次执行，因此，脏读、不可重复读、幻读都不会出现。






3. 锁模式



## Operation
1. operation类型
    - DQL(query)
    - DML(manipulation): 插入，更新，删除
    - DDL(definition): 表，视图，索引
    - DCL(control): commit, rollback

2. 表类型
    - 临时表：临时表是建立在系统临时文件夹中的表，如果使用得当，完全可以像普通表一样进行各种操作。临时表的数据和表结构都储存在内存之中，退出时，其所占的空间会自动被释放。
    - 派生表：派生表是从SELECT语句返回的虚拟表，每次query都重复执行。
    - 视图：
        - 建立视图来简化操作不用每次重复执行一段重复代码，因为视图把查询语句虚拟成一个虚表来供我们操作数据库中只存放视图的定义而不存放视图对应的数据，这些数据仍然存放在之前的表中
        - 视图在概念上与基本表等同，用户可以在基本表那样使用视图，可以在视图上再定义视图。
        - 视图不可以创建索引，索引只能创建在占有存储空间的对象上



3. Query执行顺序：
    - 1. FROM xx JOIN xx ON xx WHERE xx
    - 2. GROUP BY xx SUM(xx) HAVING xx
    - 3. SELECT DISTINCT xx ORDER BY xx

4. 查询很慢



## Partition







