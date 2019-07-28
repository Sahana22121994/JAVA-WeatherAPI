Feature: Weather API Automation

  #1--------------------------------------------------------------------------------------------------------------------------------------
 
  Scenario Outline: Register staion with valid API key
    Given a valid "register station" URL with "POST" method
    And with the below <requestbody> for each station
    When request is sent to weather API server
    Then response status code should be "201"

    Examples: 
      | requestbody                                                                                                                 |
      | {"external_id": "DEMO_TEST001","name": "Team Demo Test Station 001","latitude": 33.33,"longitude": -122.43,"altitude": 222} |
      | {"external_id": "DEMO_TEST002","name": "Team Demo Test Station 002","latitude": 44.44,"longitude": -122.44,"altitude": 111} |

  #2--------------------------------------------------------------------------------------------------------------------------------------
  Scenario Outline: Register station without API key
    Given a valid "register station without API key" URL with "POST" method
    And with the below <requestbody> for each station
    When request is sent to weather API server
    Then response status code should be "401"
    And response should contain <response>

    Examples: 
      | requestbody                                                                                                                 | response                                                                                                    |
      | {"external_id": "DEMO_TEST001","name": "Team Demo Test Station 001","latitude": 33.33,"longitude": -122.43,"altitude": 222} | {"cod":401, "message": "Invalid API key. Please see http://openweathermap.org/faq#error401 for more info."} |

  #3--------------------------------------------------------------------------------------------------------------------------------------
  Scenario Outline: Fetch the details of registered stations
    Given a valid "register station" URL with "GET" method
    When request is sent to weather API server
    Then response status code should be "200"
    And response should contain <response>

    Examples: 
      | response                                                                                                             |
      | "external_id":"DEMO_TEST001","name":"Team Demo Test Station 001","longitude":-122.43,"latitude":33.33,"altitude":222 |
      | "external_id":"DEMO_TEST002","name":"Team Demo Test Station 002","longitude":-122.44,"latitude":44.44,"altitude":111 |

  #4--------------------------------------------------------------------------------------------------------------------------------------
 
  Scenario Outline: Delete the existing stations
    Given a valid "register station" URL with "DELETE" method    
    When request is sent to weather API server with <id>
    Then response status code should be "204"

    Examples: 
      | id           |
      | DEMO_TEST001 |
      | DEMO_TEST002 |
 
   #5--------------------------------------------------------------------------------------------------------------------------------------
  Scenario Outline: Again deleting the same station
    Given a valid "register station" URL with "DELETE" method    
     When request is sent to weather API server with <id>
    Then response status code should be "404"
    And response should contain <response>

    Examples: 
      | id           |response|
      | DEMO_TEST001 |{"code":404001,"message":"Station not found"}|
      | DEMO_TEST002 |{"code":404001,"message":"Station not found"}|     
