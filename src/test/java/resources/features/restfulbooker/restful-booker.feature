@restfulbooker
Feature: Autenticación y actualización parcial de Restful Booker

  Background:
    * url bookerBaseUrl
    * if (!bookerUsername || !bookerPassword) karate.fail('Defina BOOKER_USERNAME y BOOKER_PASSWORD mediante entorno o propiedades Maven')
    * def uniqueSuffix = (java.util.UUID.randomUUID() + '').substring(0, 8)
    * def booking =
      """
      {
        "firstname": "#('QA' + uniqueSuffix)",
        "lastname": "Automation",
        "totalprice": 321,
        "depositpaid": true,
        "bookingdates": { "checkin": "2030-01-10", "checkout": "2030-01-12" },
        "additionalneeds": "Traceability"
      }
      """

  @auth @positive
  Scenario: autenticar con credenciales válidas entrega un token utilizable
    Given path 'auth'
    And request { username: '#(bookerUsername)', password: '#(bookerPassword)' }
    When method post
    Then status 200
    And match response == { token: '#string' }
    And match response.token != ''

  @auth @negative
  Scenario: autenticar con credenciales inválidas no entrega token
    Given path 'auth'
    And request { username: '#("invalid-" + uniqueSuffix)', password: '#("invalid-" + uniqueSuffix)' }
    When method post
    Then status 200
    And match response == { reason: '#string' }

  @patch @negative
  Scenario: rechazar PATCH sin autenticación y limpiar la reserva aislada
    Given path 'auth'
    And request { username: '#(bookerUsername)', password: '#(bookerPassword)' }
    When method post
    Then status 200
    * def authToken = response.token

    Given path 'booking'
    And header Accept = 'application/json'
    And request booking
    When method post
    Then status 200
    * def bookingId = response.bookingid
    * def bookingCleanupRequired = true

    Given path 'booking', bookingId
    And header Accept = 'application/json'
    And request { firstname: 'Unauthenticated' }
    When method patch
    Then status 403
    And match header Content-Type contains 'text/plain'
    And match response == 'Forbidden'

    Given path 'booking', bookingId
    And header Cookie = 'token=' + authToken
    When method delete
    Then status 201
    * def bookingCleanupRequired = false

  @patch @positive @smoke
  Scenario: crear, autenticar, actualizar, consultar y eliminar una reserva
    Given path 'auth'
    And request { username: '#(bookerUsername)', password: '#(bookerPassword)' }
    When method post
    Then status 200
    * def authToken = response.token

    Given path 'booking'
    And header Accept = 'application/json'
    And request booking
    When method post
    Then status 200
    And match response == { bookingid: '#number', booking: '#object' }
    * def bookingId = response.bookingid
    * def bookingCleanupRequired = true

    * def newFirstName = 'Updated' + uniqueSuffix
    Given path 'booking', bookingId
    And header Accept = 'application/json'
    And header Cookie = 'token=' + authToken
    And request { firstname: '#(newFirstName)', additionalneeds: 'Late checkout' }
    When method patch
    Then status 200
    And match response.firstname == newFirstName
    And match response.additionalneeds == 'Late checkout'

    Given path 'booking', bookingId
    And header Accept = 'application/json'
    When method get
    Then status 200
    And match response contains { firstname: '#(newFirstName)', lastname: 'Automation', additionalneeds: 'Late checkout' }

    Given path 'booking', bookingId
    And header Cookie = 'token=' + authToken
    When method delete
    Then status 201
    * def bookingCleanupRequired = false

    Given path 'booking', bookingId
    And header Accept = 'application/json'
    When method get
    Then status 404

  @get @negative
  Scenario: consultar una reserva eliminada por el escenario devuelve 404
    Given path 'auth'
    And request { username: '#(bookerUsername)', password: '#(bookerPassword)' }
    When method post
    Then status 200
    * def authToken = response.token

    Given path 'booking'
    And header Accept = 'application/json'
    And request booking
    When method post
    Then status 200
    * def bookingId = response.bookingid
    * def bookingCleanupRequired = true

    Given path 'booking', bookingId
    And header Cookie = 'token=' + authToken
    When method delete
    Then status 201

    Given path 'booking', bookingId
    And header Accept = 'application/json'
    When method get
    Then status 404
    And match header Content-Type contains 'text/plain'
    And match response == 'Not Found'
    * def bookingCleanupRequired = false
