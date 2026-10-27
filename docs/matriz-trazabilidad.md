# Matriz de trazabilidad de Karate

Secuencia obligatoria: PDF → tag `baseline-karate-original` → modificación → prueba → evidencia del mismo commit.

| ID | Origen PDF | Clasificación | Estado inicial ZIP | Modificación | Implementación | Prueba y resultado esperado | Estado | Evidencia | Desviación |
|---|---|---|---|---|---|---|---|---|---|
| K-REQ-01 | Estructura `.feature`, config, runner y Maven | Requisito original | Estructura parcial; runner a un solo archivo | Descubrimiento completo y config central | `TestRunner.java`, `karate-config.js` | Ejecutar toda la suite o tags | Implementado; evidencia final pendiente | `target/karate-reports` del SHA ejecutado | Ninguna |
| K-REQ-02 | Dependencias del cuadro del PDF | Requisito original | Karate 1.0.0; solo junit5 | Alineación exacta | `pom.xml` | Dependency tree, compilación y test | Implementado y aprobado localmente en Java 17 | Dependency tree artifact | Advertencia transitiva Javassist documentada |
| K-REQ-03 | POST y datos variables con Scenario Outline | Requisito original | Dos nombres fijos sin ID aislado | IDs UUID y dos filas de ejemplo | `petstore.feature` | POST 200 y contrato JSON | Implementado | Reporte Karate vigente | Ninguna |
| K-REQ-04 | GET y validación de respuesta | Requisito original | No implementado | GET del ID creado y contenido | `petstore.feature` | GET 200, ID/nombre/estado | Implementado | Reporte Karate vigente | Ninguna |
| K-REQ-05 | GET negativo 404 | Requisito original | No implementado | ID dinámico inexistente | `petstore.feature` | 404 y estructura de error | Implementado | Reporte Karate vigente | Ninguna |
| K-REQ-06 | PUT/PATCH | Requisito original | No implementado | PUT PetStore y PATCH Booker | Features de ambos servicios | 200 y persistencia posterior | Implementado | Reporte Karate vigente | PATCH se valida en Booker por requerir autenticación |
| K-REQ-07 | Generación/uso de token | Requisito original | No implementado | Auth positiva/negativa, cookie token | `restful-booker.feature` | Token presente solo con credenciales válidas | Implementado | Reporte Karate y scan de secretos | Auth inválida responde 200 por contrato observado |
| K-DEC-01 | Plan aprobado: PATCH sin auth | Decisión técnica | No implementado | Aserción basada en sonda | `restful-booker.feature` | PATCH anónimo = 403 | Implementado | Caracterización + reporte | Estado fijado después de caracterizar |
| K-DEC-02 | Plan aprobado: aislamiento y limpieza | Decisión técnica | IDs compartidos/no limpieza | UUID, ID retornado, DELETE y hook | `ApiCleanup.java`, `afterScenario` | Recurso eliminado o confirmado 404 | Implementado | Reporte y resultado del hook | APIs públicas compartidas |
| K-DEC-03 | Plan aprobado: no exponer secretos | Decisión técnica | Sin controles | Log modifier y scan bloqueante | `SensitiveDataLogModifier.java`, script | Scan sin hallazgos | Implementado; scan final pendiente | Resumen de seguridad | Ninguna |
| K-RES-01 | Disponibilidad de APIs públicas | Restricción | No documentada | Clasificación explícita | Docs y timeouts | DNS/timeout/5xx mantienen fallo | Aprobado | Log y matriz | No controlable por el proyecto |
| K-CI-01 | Plan aprobado: CI independiente | Decisión técnica | Sin workflow | Job Java 17, artifacts always, exit real | `karate-tests.yml` | Run remoto sobre SHA | Implementado; no ejecutado | URL/artifact de GitHub pendiente | Requiere publicar repositorio y secretos |
