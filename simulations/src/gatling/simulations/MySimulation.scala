package simulations

import io.gatling.core.Predef._
import io.gatling.http.Predef._

class MySimulation extends Simulation {

  val baseUrl = sys.env.getOrElse("BASE_URL", "https://jsonplaceholder.typicode.com")  // Using an environment variable
  val users = sys.env.getOrElse("USERS", "10").toInt  // Number of users from environment

  val httpConf = http
    .baseUrl(baseUrl)  // API endpoint for testing
    .header("Accept", "application/json")

  val scn = scenario("Basic API Test")
    .exec(http("Get Posts")
      .get("/posts/1")
      .check(status.is(200)))

  setUp(
    scn.inject(atOnceUsers(users))  // Injecting users based on environment variable
  ).protocols(httpConf)
}
