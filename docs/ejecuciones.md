# Registro de ejecuciones de Karate

Solo se aceptan resultados generados por el código actual. Los archivos heredados del ZIP se encuentran excluidos y no son evidencia.

Las filas marcadas como cambio aún no confirmado o evidencia temporal conservan la cronología de diagnóstico previa a los commits; no representan tareas abiertas. El estado de cierre lo determina la última ejecución sobre el SHA final.

| Fecha UTC | Commit SHA | Entorno | Comando | Resultado real | Evidencia |
|---|---|---|---|---|---|
| 2026-10-27T02:48Z | cambio aún no confirmado | Sonda HTTP controlada | Caracterización PetStore/Booker | Contrato observado y recursos eliminados | `docs/decisiones-tecnicas.md` |
| 2026-10-27T02:54Z | cambio aún no confirmado | Java 21.0.2 / Maven 3.9.9 | `mvn -B -ntp clean test` | Fallido: IDs de PetStore en notación científica; 5/9 escenarios aprobados | Reporte local temporal, no evidencia final |
| 2026-10-27T02:55Z | cambio aún no confirmado | Java 21.0.2 / Maven 3.9.9 | `mvn -B -ntp clean test` | Aprobado: 9/9 escenarios | Reporte local temporal, no evidencia final |
| 2026-10-27T03:08Z | cambio aún no confirmado | Temurin 17.0.20.1 / Maven 3.9.9 | `mvn -B -ntp dependency:tree -Dscope=test` | Aprobado; versiones del PDF resueltas | Salida local temporal |
| 2026-10-27T03:09Z | cambio aún no confirmado | Temurin 17.0.20.1 / Maven 3.9.9 | `mvn -B -ntp clean test` | Aprobado: 9/9 escenarios | Reporte local temporal, scan final pendiente |
| 2026-10-27T03:12Z | cambio aún no confirmado | Temurin 17.0.20.1 | Probe temporal de `afterScenario` | Primer intento fallido antes de crear: Booker respondió 418 sin `Accept` | Diagnóstico de dependencia pública |
| 2026-10-27T03:12Z | cambio aún no confirmado | Temurin 17.0.20.1 | Probe temporal con fallo intencional | Suite roja por aserción; GET independiente del ID residual = 404 | Hook de limpieza validado; probe eliminado |
| 2026-10-27T04:49Z | cambio de reporte aún no confirmado | Temurin 17.0.20.1 / Maven 3.9.9 | Probe aislado `maven-cucumber-reporting:5.11.0:generate` | Aprobado; 2 JSON Karate procesados y HTML generado | `tmp/cucumber-plugin-probe-output`, evidencia temporal no final |
| 2026-10-27T04:51Z | cambio de reporte aún no confirmado | Temurin 17.0.20.1 / Maven 3.9.9 | `mvn -B -ntp clean verify` | Aprobado: 9/9 escenarios y reporte Cucumber; scan 31 archivos aprobado | `target/`, evidencia temporal no final |
| 2026-10-27T05:10Z | cambio de contrato aún no confirmado | Sonda HTTP controlada | 3 PATCH anónimos + 3 GET sobre ID inexistente | Respuestas consistentes: `403/Forbidden` y `404/Not Found`, ambas `text/plain` | Caracterización previa; no se crearon recursos |
| 2026-10-27T05:12Z | cambio de contrato aún no confirmado | Temurin 17.0.20.1 / Maven 3.9.9 | Suite focalizada `@restfulbooker` | Aprobado: 5/5 escenarios; nuevas aserciones aprobadas | Reporte local temporal, secretos enmascarados |
| 2026-10-27T05:13Z | cambio de contrato aún no confirmado | Temurin 17.0.20.1 / Maven 3.9.9 | `mvn -B -ntp clean verify` + scan | Aprobado: 9/9 escenarios, reporte Cucumber y scan de 31 archivos | `target/`, evidencia precommit no final |
| 2026-10-27T05:30Z | `6d38c64f8ad93344e504c8232fcd2671f7774d51` | GitHub Actions, Ubuntu 24.04 / Java 17.0.20.1 / Maven 3.10.0 | `mvn -B -ntp clean test` + generación Cucumber + scan | Aprobado: 9/9 escenarios, 2 features en Cucumber y 34 archivos revisados sin secretos expuestos | [Run `40455709946`](https://github.com/RodrigoPradoV/karateNttdataDemo/actions/runs/40455709946); artifact `karate-evidence-6d38c64f8ad93344e504c8232fcd2671f7774d51`, ID `12711219868`; copia en `Ejecucion-Karate/Ejecucion-2/` |

Las ejecuciones limpias se registran en el resumen generado y en la nota Git `qa-validation` sin alterar el SHA probado. El workflow base fue el run `40448399804`; el cierre final con reporte Cucumber y contratos negativos reforzados corresponde al run `40455709946` sobre `6d38c64`. El artifact incluye el SHA completo, el resultado real del comando, los reportes y el resumen de seguridad.

## Regresión de 404 deterministas

El 2026-10-27 se reemplazaron las precondiciones negativas basadas en IDs supuestamente libres por recursos controlados por cada escenario:

- PetStore: POST del ID único, DELETE 200 y GET 404 con contrato JSON aprobado.
- Restful Booker: autenticación, POST de reserva, DELETE 201 y GET 404 con `text/plain` y cuerpo `Not Found` aprobados.
- El indicador de cleanup permanece activo hasta completar la comprobación 404; si una aserción intermedia falla, el hook conserva su recuperación idempotente.
- Regresión local focalizada: PetStore 4/4 y Restful Booker 5/5 escenarios aprobados.

El workflow conserva 9 escenarios y publicará la evidencia del mismo SHA con una retención de 90 días. El run, IDs y hashes se relacionan mediante la nota Git `refs/notes/qa-validation` después de la validación remota.
