# Decisiones técnicas de Karate

## Clasificación

- **Requisito original:** afirmación comprobable del PDF.
- **Decisión técnica:** forma elegida para satisfacer un requisito.
- **Restricción:** condición de una versión, del entorno o de un servicio externo.
- **Mejora opcional:** elemento no exigido para aprobar el caso.

## Decisiones vigentes

| ID | Clasificación | Decisión y justificación |
|---|---|---|
| K-D01 | Decisión técnica | El runner descubre `classpath:resources/features` y respeta `karate.options`, evitando una lista manual incompleta y permitiendo tags. |
| K-D02 | Decisión técnica | Los IDs de PetStore se derivan de UUID y permanecen en rango entero para evitar que Karate 1.2.0 serialice el path en notación científica. |
| K-D03 | Decisión técnica | Restful Booker usa UUID en los datos y siempre conserva el `bookingid` retornado. No existen IDs compartidos. |
| K-D04 | Decisión técnica | Cada flujo elimina explícitamente su recurso. El hook global `afterScenario` invoca `ApiCleanup` cuando una falla deja el indicador de limpieza activo. |
| K-D05 | Decisión técnica | La limpieza es idempotente: acepta el DELETE esperado o confirma mediante GET 404 que el recurso ya no existe; cualquier otro estado o error de red falla el escenario. |
| K-D06 | Decisión técnica | La suite se ejecuta secuencialmente. No se habilita paralelismo contra Restful Booker por ser una API pública compartida. |
| K-D07 | Decisión técnica | `SensitiveDataLogModifier` enmascara headers y campos de password/token en request, response y URI; un script independiente impide publicar artifacts si detecta valores crudos. |
| K-D08 | Restricción | PetStore y Restful Booker son servicios públicos fuera del control del repositorio. DNS, timeout, conexión, 5xx o estado remoto perdido son dependencia externa y mantienen el job fallido. |
| K-D09 | Decisión técnica | Un 4xx/2xx accesible que contradiga el contrato documentado se clasifica como fallo funcional; una excepción de Karate/Maven/configuración es fallo técnico. Ninguna categoría se transforma en aprobada mediante skip. |

El hook se verificó con un feature temporal no versionado: se creó una reserva, se forzó una aserción fallida y el escenario permaneció rojo; después, un GET independiente al `bookingid` creado respondió 404. Una primera ejecución del probe sin header `Accept` recibió 418 de la API pública antes de crear el recurso. El flujo productivo sí envía `Accept: application/json`; ambos resultados se conservaron como diagnóstico, no como evidencia aprobada.

## Caracterización del contrato

Caracterización controlada del 2026-10-27T02:48Z, con datos únicos y limpieza posterior:

| Servicio y operación | Autenticación | Estado | Forma observada |
|---|---|---:|---|
| PetStore POST `/pet` | No aplica | 200 | JSON de mascota |
| PetStore GET existente | No aplica | 200 | JSON de mascota |
| PetStore PUT `/pet` | No aplica | 200 | JSON actualizado |
| PetStore GET inexistente | No aplica | 404 | JSON `code/type/message` |
| PetStore DELETE | No aplica | 200 | JSON de confirmación |
| Booker POST `/auth` válido | Credenciales válidas | 200 | JSON con token no vacío |
| Booker POST `/auth` inválido | Credenciales inválidas | 200 | JSON `reason`, sin token utilizable |
| Booker POST `/booking` | No aplica | 200 | `bookingid` y `booking` |
| Booker PATCH sin auth | Ninguna | 403 | Texto plano |
| Booker PATCH con cookie token | Token válido | 200 | Reserva actualizada |
| Booker DELETE con auth | Token válido | 201 | Texto plano |
| Booker GET inexistente | No aplica | 404 | Texto plano |

La primera sonda autenticada con un cliente HTTP que administraba cookies automáticamente no transmitió el header `Cookie` manual y obtuvo 403. Se repitió con administración automática deshabilitada, se confirmó 200 y se eliminó tanto la reserva de repetición como la reserva residual. Esto se clasifica como limitación del cliente de caracterización, no como defecto de la API.

## Mejoras fuera de alcance

No se incorporan pruebas de carga, seguridad, Docker ni integraciones corporativas antes del cierre de los dos casos principales.
