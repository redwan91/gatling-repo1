package simulations

import io.gatling.core.Predef._
import io.gatling.http.Predef._

class MySimulation extends Simulation {

  val httpConf = http
    .baseUrl("https://jsonplaceholder.typicode.com") // API endpoint for testing
    .header("Accept", "application/json")

  val scn = scenario("Basic API Test")
    .exec(http("Get Posts")
      .get("/posts/1")
      .check(status.is(200)))

  setUp(
    scn.inject(atOnceUsers(10))  // Inject 10 users at once
  ).protocols(httpConf)
}
