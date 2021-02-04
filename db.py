"""

# 索引
![alt text](images/index_structure.png)
============


## 利弊

优: 提升检索效率
缺: 索引文件占用磁盘空间
    降低了增删改的执行效率



## 数据结构

B树: 多路平衡查找树
     内部节点有record pointer
     
B+树: 内部节点无record pointer，只有叶子节点有record pointer -> 磁盘IO次数少，查询效率高              
      叶子节点LinkedList -> b+范围扫描简单，b则需要在叶子节点和内部节点往返移动
      
      
      
## 类型

普通索引 - 直接创建/修改表结构的方式添加索引/创建表的时候同时创建索引
唯一索引 - 索引列的值必须唯一，但允许有空值。如果是组合索引，则列值的组合必须唯一。
全文索引 - 主要用来查找文本中的关键字，而不是直接与索引中的值相比较。

主键索引 - 一种特殊的唯一索引，一个表只能有一个主键，不允许有空值。一般是在建表的时候同时创建主键索引。
组合索引 - 只有在查询条件中使用了创建索引时的第一个字段，索引才会被使用
          最左匹配(col1, col2, col3) -> (col1), (col1, col2), (col1, col2, col3)
          
ju
          


## SELECT语句
1. w


## Lock




"""


all the keys are preseented in the leaf nodes, record pointer will bee frrom only leaf nodes, leaf nodes form a linkedlist
in non-leaf nodees there are duplicates




