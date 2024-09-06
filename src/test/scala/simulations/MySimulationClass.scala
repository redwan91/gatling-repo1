package simulations

import io.gatling.core.Predef._
import io.gatling.http.Predef._

class MySimulationClass extends Simulation {
  val httpProtocol = http.baseUrl("https://example.com")
  val scn = scenario("My Scenario").exec(http("request_1").get("/"))
  setUp(scn.inject(atOnceUsers(10))).protocols(httpProtocol)
}
