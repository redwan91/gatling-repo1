
package simulations

import io.gatling.core.Predef._
import io.gatling.http.Predef._

class MySimulation extends Simulation {
  val httpProtocol = http.baseUrl("http://example.com")
  val scn = scenario("Example Scenario").exec(http("request_1").get("/"))
  setUp(scn.inject(atOnceUsers(1))).protocols(httpProtocol)
}
