@petstore
Feature: Contrato de mascotas de PetStore

  Background:
    * url petStoreUrl

  @post @outline
  Scenario Outline: crear una mascota con datos variables y validar su contrato
    * def petId = java.lang.Math.abs(java.util.UUID.randomUUID().hashCode())
    * def petCleanupRequired = true
    * def pet =
      """
      {
        "id": "#(petId)",
        "category": { "id": 1, "name": "qa-traceability" },
        "name": "#('<petName>-' + petId)",
        "photoUrls": ["https://example.invalid/pet.png"],
        "tags": [{ "id": 1, "name": "automated" }],
        "status": "<petStatus>"
      }
      """
    Given path 'pet'
    And request pet
    When method post
    Then status 200
    And match response contains { id: '#number', name: '#(pet.name)', status: '#(pet.status)', photoUrls: '#[]' }
    And match response.category == { id: 1, name: 'qa-traceability' }
    And match each response.photoUrls == '#string'
    Given path 'pet', petId
    When method delete
    Then status 200
    * def petCleanupRequired = false

    Examples:
      | petName | petStatus |
      | Vaguito | available |
      | Firulais | pending |

  @get @put @smoke
  Scenario: consultar y actualizar una mascota creada por el escenario
    * def petId = java.lang.Math.abs(java.util.UUID.randomUUID().hashCode())
    * def petCleanupRequired = true
    * def pet = { id: '#(petId)', name: '#("Original-" + petId)', photoUrls: [], status: 'available' }
    Given path 'pet'
    And request pet
    When method post
    Then status 200

    Given path 'pet', petId
    When method get
    Then status 200
    And match response contains { id: '#(petId)', name: '#(pet.name)', status: 'available' }

    * set pet.name = 'Actualizada-' + petId
    * set pet.status = 'sold'
    Given path 'pet'
    And request pet
    When method put
    Then status 200
    And match response contains { id: '#(petId)', name: '#(pet.name)', status: 'sold' }

    Given path 'pet', petId
    When method get
    Then status 200
    And match response contains { id: '#(petId)', name: '#(pet.name)', status: 'sold' }

    Given path 'pet', petId
    When method delete
    Then status 200
    * def petCleanupRequired = false

  @get @negative
  Scenario: consultar una mascota inexistente devuelve 404
    * def missingPetId = java.lang.Math.abs(java.util.UUID.randomUUID().hashCode())
    Given path 'pet', missingPetId
    When method get
    Then status 404
    And match response == { code: 1, type: 'error', message: 'Pet not found' }
