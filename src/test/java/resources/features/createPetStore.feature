Feature: Ejemplo de karate

  Background:
    * url urlBase

  @createPet
  Scenario Outline: valida la creación de una mascota
    Given path '/pet'
    * def json = read('classpath:resources/request/createPet.json')
    * set json.name = '<petName>'
    And request json
    When method post
    Then status 200
    And match response.name == '<petName>'
    And print 'Mascota creada: ', response.name

    Examples:
    | petName   |
    | Vaguito |
    | Firulais |
