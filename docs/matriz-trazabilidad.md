# Matriz de trazabilidad de Karate

Secuencia obligatoria: PDF → tag `baseline-karate-original` → modificación → prueba → evidencia del mismo commit.

## Evidencia final vigente

- Commit validado: `6d38c64f8ad93344e504c8232fcd2671f7774d51`.
- GitHub Actions: [run 40455709946](https://github.com/RodrigoPradoV/karateNttdataDemo/actions/runs/40455709946), ejecutado con Java 17.0.20.1 y Maven 3.10.0.
- Resultado: 9 escenarios ejecutados, 0 fallos, 0 errores y 0 omitidos.
- Reportes: Karate nativo y Cucumber HTML generados para 2 features.
- Seguridad: 34 archivos revisados, sin contraseñas, tokens ni headers de autenticación expuestos.
- Artifact: `karate-evidence-6d38c64f8ad93344e504c8232fcd2671f7774d51` (ID `12711219868`, SHA-256 `f7c99bfb6eb29ceddcde9c839bcbab571956731e25d10d9581ee99641a69a120`). Copia descargada en `Ejecucion-Karate/Ejecucion-2/`.

| ID | Origen PDF | Clasificación | Estado inicial ZIP | Modificación | Implementación | Prueba y resultado esperado | Estado | Evidencia | Desviación |
|---|---|---|---|---|---|---|---|---|---|
| K-REQ-01 | Estructura `.feature`, config, runner y Maven | Requisito original | Estructura parcial; runner a un solo archivo | Descubrimiento completo y config central | `TestRunner.java`, `karate-config.js` | Ejecutar toda la suite o tags | Implementado y aprobado en GitHub Actions | Reporte Karate del artifact final, SHA `6d38c64` | Ninguna |
| K-REQ-02 | Dependencias del cuadro del PDF | Requisito original | Karate 1.0.0; solo junit5 | Alineación exacta | `pom.xml` | Dependency tree, compilación y test | Implementado y aprobado en Java 17 local y CI | `evidence/dependency-tree.txt` del artifact final | Advertencia transitiva Javassist documentada |
| K-REQ-03 | POST y datos variables con Scenario Outline | Requisito original | Dos nombres fijos sin ID aislado | IDs UUID y dos filas de ejemplo | `petstore.feature` | POST 200 y contrato JSON | Implementado y aprobado en CI | Reporte Karate del artifact final | Ninguna |
| K-REQ-04 | GET y validación de respuesta | Requisito original | No implementado | GET del ID creado y contenido | `petstore.feature` | GET 200, ID/nombre/estado | Implementado y aprobado en CI | Reporte Karate del artifact final | Ninguna |
| K-REQ-05 | GET negativo 404 | Requisito original | No implementado | ID dinámico inexistente | `petstore.feature` | 404 y estructura de error | Implementado y aprobado en CI | Reporte Karate del artifact final | Ninguna |
| K-REQ-06 | PUT/PATCH | Requisito original | No implementado | PUT PetStore y PATCH Booker | Features de ambos servicios | 200 y persistencia posterior | Implementado y aprobado en CI | Reportes Karate y Cucumber del artifact final | PATCH se valida en Booker porque PetStore v2 no ofrece un PATCH documentado; Booker permite además demostrar autenticación por token |
| K-REQ-07 | Generación/uso de token | Requisito original | No implementado | Auth positiva/negativa, cookie token | `restful-booker.feature` | Token presente solo con credenciales válidas | Implementado y aprobado en CI | Reporte Karate y scan de secretos del artifact final | Auth inválida responde 200 por contrato observado |
| K-REQ-08 | Plugin Cucumber para mostrar el reporte | Requisito original | Ausente en el ZIP y en su POM | Plugin Maven sobre JSON Cucumber de Karate | `pom.xml`, `TestRunner.java`, `karate-tests.yml` | Generar HTML desde los JSON de la suite | Implementado y aprobado en CI; 2 features procesadas | `cucumber-html-reports/overview-features.html` del artifact final | El PDF no especifica artefacto ni versión; se seleccionó y documentó 5.11.0 |
| K-DEC-01 | Plan aprobado: PATCH sin auth | Decisión técnica | No implementado | Aserción basada en sonda | `restful-booker.feature` | PATCH anónimo = 403, `text/plain`, cuerpo `Forbidden` | Implementado y aprobado en CI | Caracterización repetida + reporte final | Estado y contenido fijados después de caracterizar |
| K-DEC-02 | Plan aprobado: aislamiento y limpieza | Decisión técnica | IDs compartidos/no limpieza | UUID, ID retornado, DELETE y hook | `ApiCleanup.java`, `afterScenario` | Recurso eliminado o confirmado 404 | Implementado y aprobado en CI | Reporte final y validación controlada del hook | APIs públicas compartidas |
| K-DEC-03 | Plan aprobado: no exponer secretos | Decisión técnica | Sin controles | Log modifier y scan bloqueante | `SensitiveDataLogModifier.java`, script | Scan sin hallazgos | Implementado y aprobado en CI | Resumen final: 34 archivos revisados sin hallazgos | Ninguna |
| K-DEC-04 | Validar estado, tipo y contenido de respuestas negativas | Decisión técnica | GET Booker inexistente validaba solo 404 | Contrato de error basado en tres sondas consecutivas | `restful-booker.feature` | GET inexistente = 404, `text/plain`, cuerpo `Not Found` | Implementado y aprobado en CI | Caracterización + reportes Karate/Cucumber del artifact final | API pública; una variación real permanecerá visible |
| K-RES-01 | Disponibilidad de APIs públicas | Restricción | No documentada | Clasificación explícita | Docs y timeouts | DNS/timeout/5xx mantienen fallo | Aprobado | Log y matriz | No controlable por el proyecto |
| K-CI-01 | Plan aprobado: CI independiente | Decisión técnica | Sin workflow | Job Java 17, artifacts always, exit real y reporte Cucumber | `karate-tests.yml` | Run remoto sobre el SHA final | Aprobado en GitHub Actions: 9/9, Cucumber generado y scan aprobado | Run `40455709946`; artifact ID `12711219868`; SHA `6d38c64` | Ninguna |
