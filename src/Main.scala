import org.apache.ignite.cache.affinity.rendezvous.RendezvousAffinityFunction
import org.apache.ignite.{Ignite, IgniteCache, Ignition}
import org.apache.ignite.spark._
import org.apache.spark.sql.{Dataset, Row, SparkSession}
import org.apache.ignite.configuration._
import org.apache.ignite.lang.IgniteUuid
import org.apache.spark.SparkContext
import org.apache.spark.sql.types.{StringType, StructField, StructType}
import org.apache.log4j.Logger
import org.apache.log4j.Level
import org.apache.spark.rdd.RDD
import scala.sys.process._

object Main{

  /**
    * main() builds a SparkSession, reads the input file, and passes them to each experiment
    * First argument is input file
    */
  def main(args: Array[String]) {
    val spark = SparkSession
      .builder()
      .appName("demo")
      .master("local")
      .getOrCreate()
    val sc = spark.sparkContext
    
    val inputFile = "./input/input.txt"
    val script = "./scripts/pipeCreation.sh"

    // Normal RDD
    val inputRDD = sc.textFile(inputFile)
    val pipedRDD1 = inputRDD.pipe(script)
    pipedRDD1.take(20).foreach(println)
    
    // IgniteRDD
    val (ic, cachecfg) = configureIgnite(spark.sparkContext)
    val sharedRDD = ic.fromCache(cachecfg)
    val pipedRDD2 = sharedRDD.pipe(script)
    pipedRDD2.take(20).foreach(println)
    
  }

    def configureIgnite(sc: SparkContext): (IgniteContext, CacheConfiguration[IgniteUuid, String]) = {
      val cachecfg = new CacheConfiguration[IgniteUuid, String]()
        .setName("demoConfig")
        .setAffinity(new RendezvousAffinityFunction(false, 1))
      val ignitecfg = new IgniteConfiguration()
        .setCacheConfiguration(cachecfg)
      val ic = new IgniteContext(sc)
      return (ic, cachecfg)

    }
}
