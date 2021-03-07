## Docker
1. 功能
  - 通过对系统的关键资源的隔离，实现了主机抽象。多个容器能够在同一台物理机器上运行。

2. 架构
- 镜像（Image）
- 容器（Container）
- 仓库（Repository）



## Kubernetes
1. 功能
  - 微服务不同模块的软件依赖、网络配置、资源需求等各不相同，Docker CLI不能管理大规模的容器系统，需要容器编排系统来管理一个集群上运行的宿主机和容器。集群抽象。


2. 架构
- Master
  - API Server
  - Scheduler: 监视没有分配节点的新创建的 Pod，选择一个节点供他们运行。
  - Controller manager
  - etcd: 后端存储，所有的集群数据存放在此处。
  
- Node
  - kubelet：主要的节点代理，管理其host上Pod的生命周期。
  - kube-proxy：管理节点上的网络规则并执行连接转发。
  - Container Runtime：提取容器运行的服务，包括docker、rkt等
  - supervisord：来提供进程监控，保证kubelet和docker运行
  - fluentd：守护进程，有助于提供集群日志
  - pod:k8s的最小计算单元，包括了一个容器或者多个容器，所有容器共享同样的独立IP，同样的hostname，同样的存储资源。
    - ConfigMap：一个 kv 的配置格式，可以用来配置 pods，实现 image 重用，支持在线修改
    - Secret：功能和 ConfigMap 相同，但是以 base64 加密存储
    - Label：可以挂载到任意对象的标签，提供分组的基础

- [概念](https://zhuanlan.zhihu.com/p/100644716)
  - Service 定义了一个 Pod的逻辑组，这些Pod提供相同的功能服务
  - 网络通信
  - 工作模型
  - 更新部署
  - 数据持久化



  


