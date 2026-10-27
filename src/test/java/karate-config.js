function fn() {
  var env = karate.env || 'dev';
  var system = java.lang.System;
  var SensitiveDataLogModifier = Java.type('karate.support.SensitiveDataLogModifier');
  var ApiCleanup = Java.type('karate.support.ApiCleanup');

  function setting(name, defaultValue) {
    return karate.properties[name] || system.getenv(name) || defaultValue;
  }

  var config = {
    env: env,
    petStoreUrl: setting('PETSTORE_BASE_URL', 'https://petstore.swagger.io/v2'),
    bookerBaseUrl: setting('BOOKER_BASE_URL', 'https://restful-booker.herokuapp.com'),
    bookerUsername: setting('BOOKER_USERNAME', null),
    bookerPassword: setting('BOOKER_PASSWORD', null)
  };

  karate.configure('connectTimeout', 15000);
  karate.configure('readTimeout', 30000);
  karate.configure('logModifier', new SensitiveDataLogModifier());

  karate.configure('afterScenario', function () {
    var failures = [];

    if (karate.get('bookingCleanupRequired', false)) {
      var bookingResult = ApiCleanup.restfulBooker(
        config.bookerBaseUrl,
        karate.get('bookingId'),
        karate.get('authToken')
      );
      karate.set('bookingCleanupResult', bookingResult);
      if (!bookingResult.success) {
        failures.push('Restful Booker: ' + bookingResult.message);
      }
    }

    if (karate.get('petCleanupRequired', false)) {
      var petResult = ApiCleanup.petStore(
        config.petStoreUrl,
        karate.get('petId')
      );
      karate.set('petCleanupResult', petResult);
      if (!petResult.success) {
        failures.push('PetStore: ' + petResult.message);
      }
    }

    if (failures.length) {
      karate.fail('Limpieza incompleta. ' + failures.join(' | '));
    }
  });

  return config;
}
