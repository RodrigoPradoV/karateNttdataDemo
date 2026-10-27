# Compatibilidad de Karate

## Versiones fijadas por el PDF

| Componente | Versión objetivo | Estado |
|---|---:|---|
| `karate-core` | 1.2.0 | Declarada explícitamente |
| `karate-junit5` | 1.2.0 | Declarada explícitamente |
| `junit-jupiter-api` | 5.10.0 | Declarada explícitamente |
| `junit-jupiter-engine` | 5.10.0 | Declarada explícitamente |
| `maven-surefire-plugin` | 2.22.2 | Declarada explícitamente |

## Plugin de reporte Cucumber

El PDF exige un "plugin cucumber" para visualizar la ejecución, pero no identifica artefacto ni versión. El baseline `baseline-karate-original` tampoco contenía un plugin de reporte. Se seleccionó `net.masterthought:maven-cucumber-reporting:5.11.0` como decisión de implementación, sin modificar ninguna de las cinco versiones fijadas por el PDF.

La versión 5.11.0 se validó primero de forma aislada con Java 17 y Maven 3.9.9. Consumió correctamente los dos JSON Cucumber producidos por Karate 1.2.0 y generó un reporte HTML navegable con 2 features y 9 escenarios. No se utilizó la versión beta publicada en el metadata de Maven Central.

El plugin está ligado a la fase `verify`, por lo que `mvn -B -ntp clean verify` ejecuta la suite y genera `target/cucumber-html-reports/overview-features.html`. El comando `mvn -B -ntp clean test` y las versiones de prueba originales permanecen sin cambios.

`mvn dependency:tree -Dscope=test` resolvió JUnit Platform 1.10.0 por las dependencias explícitas de JUnit 5.10.0. Maven mostró además una advertencia del modelo efectivo de `org.javassist:javassist:3.20.0-GA`, dependencia transitiva de Karate 1.2.0; no se cambió ninguna versión para ocultarla.

## Java 21 local

- Temurin 21.0.2 y Maven 3.9.9.
- `mvn -B -ntp clean test-compile`: aprobado.
- `mvn -B -ntp clean test`: ejecución preliminar aprobada con 9 escenarios después de corregir la representación del ID dinámico.
- El compilador avisa que `ApiCleanup` usa una API marcada como deprecated en Java 21 (`URL(String)`); no impide la ejecución y no se presenta como incompatibilidad de Java 17.

## Java 17 objetivo

Java 17 es el runtime obligatorio del workflow. Con Temurin 17.0.20.1 se ejecutaron `mvn dependency:tree -Dscope=test` y `mvn -B -ntp clean test`: ambos aprobaron, con 9/9 escenarios. La advertencia de API deprecated observada al compilar con Java 21 no apareció con Java 17. La advertencia transitiva de Javassist sí se mantuvo.

El workflow base se validó en GitHub Actions en el run `40448399804` sobre el SHA `7694556498a78380223e3351419914f865b3032b`. La incorporación posterior del reporte Cucumber requiere una nueva ejecución sobre su SHA final; ese resultado se registrará en la nota Git `qa-validation` y en el artifact del workflow.
