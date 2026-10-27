# Compatibilidad de Karate

## Versiones fijadas por el PDF

| Componente | Versión objetivo | Estado |
|---|---:|---|
| `karate-core` | 1.2.0 | Declarada explícitamente |
| `karate-junit5` | 1.2.0 | Declarada explícitamente |
| `junit-jupiter-api` | 5.10.0 | Declarada explícitamente |
| `junit-jupiter-engine` | 5.10.0 | Declarada explícitamente |
| `maven-surefire-plugin` | 2.22.2 | Declarada explícitamente |

`mvn dependency:tree -Dscope=test` resolvió JUnit Platform 1.10.0 por las dependencias explícitas de JUnit 5.10.0. Maven mostró además una advertencia del modelo efectivo de `org.javassist:javassist:3.20.0-GA`, dependencia transitiva de Karate 1.2.0; no se cambió ninguna versión para ocultarla.

## Java 21 local

- Temurin 21.0.2 y Maven 3.9.9.
- `mvn -B -ntp clean test-compile`: aprobado.
- `mvn -B -ntp clean test`: ejecución preliminar aprobada con 9 escenarios después de corregir la representación del ID dinámico.
- El compilador avisa que `ApiCleanup` usa una API marcada como deprecated en Java 21 (`URL(String)`); no impide la ejecución y no se presenta como incompatibilidad de Java 17.

## Java 17 objetivo

Java 17 es el runtime obligatorio del workflow. Con Temurin 17.0.20.1 se ejecutaron `mvn dependency:tree -Dscope=test` y `mvn -B -ntp clean test`: ambos aprobaron, con 9/9 escenarios. La advertencia de API deprecated observada al compilar con Java 21 no apareció con Java 17. La advertencia transitiva de Javassist sí se mantuvo.

El workflow no se considerará validado hasta ejecutarse en GitHub Actions. Si el runner remoto produce una diferencia, se conservarán comando, dependency tree, error e impacto antes de proponer cualquier desviación.
