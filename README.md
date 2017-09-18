# streamlining-genomics-spark

## Local deployment
1. Download [Apache Ignite 2.1.0 binary](https://ignite.apache.org/download.cgi#binaries)
    1. Download Apache Ignite as ZIP archive from https://ignite.apache.org/
    1. Unzip ZIP archive into the installation folder in your system
    1. Set IGNITE_HOME environment variable to point to the installation folder and make sure there is no trailing / in the path (this step is optional)
1. Start a local Spark 2.1 master and slave  
    1. `sbin/start-master.sh  `
    1. `sbin/start-slave.sh <spark-master-url>`  
1. Start up ignite on master and worker
    1. On master machine, go to ignite binary dir and `bin/ignite.sh`
    1. ssh into local worker (see Spark UI at <spark-master-url>:8080 for IP)
        1. e.g. ssh 153.9.224.87
    1. On worker machine, go to ignite binary dir and `bin/ignite.sh`
1. Run demo
    1. `cd streamlining-genomics-spark`
    1. `mkdir Pipes`
    1. `mvn clean package`
    1. `mvn exec:java`
