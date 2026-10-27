# Registro de ejecuciones de Karate

Solo se aceptan resultados generados por el código actual. Los archivos heredados del ZIP se encuentran excluidos y no son evidencia.

| Fecha UTC | Commit SHA | Entorno | Comando | Resultado real | Evidencia |
|---|---|---|---|---|---|
| 2026-10-27T02:48Z | cambio aún no confirmado | Sonda HTTP controlada | Caracterización PetStore/Booker | Contrato observado y recursos eliminados | `docs/decisiones-tecnicas.md` |
| 2026-10-27T02:54Z | cambio aún no confirmado | Java 21.0.2 / Maven 3.9.9 | `mvn -B -ntp clean test` | Fallido: IDs de PetStore en notación científica; 5/9 escenarios aprobados | Reporte local temporal, no evidencia final |
| 2026-10-27T02:55Z | cambio aún no confirmado | Java 21.0.2 / Maven 3.9.9 | `mvn -B -ntp clean test` | Aprobado: 9/9 escenarios | Reporte local temporal, no evidencia final |
| 2026-10-27T03:08Z | cambio aún no confirmado | Temurin 17.0.20.1 / Maven 3.9.9 | `mvn -B -ntp dependency:tree -Dscope=test` | Aprobado; versiones del PDF resueltas | Salida local temporal |
| 2026-10-27T03:09Z | cambio aún no confirmado | Temurin 17.0.20.1 / Maven 3.9.9 | `mvn -B -ntp clean test` | Aprobado: 9/9 escenarios | Reporte local temporal, scan final pendiente |
| 2026-10-27T03:12Z | cambio aún no confirmado | Temurin 17.0.20.1 | Probe temporal de `afterScenario` | Primer intento fallido antes de crear: Booker respondió 418 sin `Accept` | Diagnóstico de dependencia pública |
| 2026-10-27T03:12Z | cambio aún no confirmado | Temurin 17.0.20.1 | Probe temporal con fallo intencional | Suite roja por aserción; GET independiente del ID residual = 404 | Hook de limpieza validado; probe eliminado |

Las dos ejecuciones locales limpias sobre el commit final se registran además en el resumen generado y en una nota Git sin alterar el SHA probado. El run de GitHub Actions se añadirá cuando exista un remoto. Cada artifact generado por CI incluye el SHA completo y el resultado real del comando.
