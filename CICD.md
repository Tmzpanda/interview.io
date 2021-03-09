```
                                  -> Nexus
  Dev ->        GitLab -- Jenkins ->        Spark Job Server             -> Yarn
                Jira      Git               RestAPI
                          SBT               spark-submit
                          
                          
```
- 配置Jenkins
  - SCM + Build Trigger vs GitLab webhooks
  - Build -> .jar
  - Post-build Actions -> Nexus & spark-submit

    
- [流程](https://devops.com/using-spark-and-jenkins-to-deploy-code-into-hadoop-clusters/)
  - Dev push code to GitLab, Jenkins trigger a predefined job using webhooks.
  - Git pull, SBT build
  - .jar file deployed into Hadoop cluster
  - 



Jenkins/Travis/Teamcity
















