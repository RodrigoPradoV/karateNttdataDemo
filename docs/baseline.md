# Baseline original de Karate

## Alcance

Este documento acompaña al tag `baseline-karate-original`. El código fuente del ZIP se conserva sin cambios en ese tag. Solo se añadieron la referencia PDF, su hash, este inventario y exclusiones Git para impedir que dependencias, reportes, cachés, archivos de IDE o secretos entren al baseline.

## Referencia principal

- PDF: `docs/reference/Informe_Automatizacion_Karate.pdf`
- SHA-256: `CA67070B2E916A2CC776FDE3D3BFD822D87B6F6780DC4B1A2E108C4B2B84FC7B`
- Páginas: 1
- La copia fue verificada contra el PDF ubicado en la raíz del material recibido.

## Estado inicial del código

- Proyecto Maven con Java objetivo 1.8.
- `pom.xml` declara `karate-junit5` 1.0.0 y Surefire 2.22.2; no declara todavía todas las versiones solicitadas por el PDF.
- Existe un runner JUnit que ejecuta únicamente `createPetStore.feature`.
- La única cobertura fuente activa crea mascotas mediante POST con dos ejemplos.
- La URL está fijada a PetStore en `karate-config.js`.
- No existe cobertura fuente para GET, GET 404, PUT, Restful Booker, autenticación, PATCH ni limpieza.

## Inventario excluido

- `target/`: 380 archivos detectados al preparar el baseline.
- 23 directorios `karate-reports*` heredados, con nombres de features que ya no están en el código fuente actual.
- `.idea/` y demás metadatos de IDE.
- Los reportes heredados no se versionan ni se aceptan como evidencia de esta implementación.
- Una comprobación diagnóstica previa al baseline pudo actualizar archivos dentro de `target/`; todo el directorio permanece excluido y no forma parte de la evidencia.

## Entorno observado al crear el baseline

- Sistema: Windows.
- Java local: Temurin 21.0.2.
- Maven local: 3.9.9.
- Java 17 no estaba disponible en el PATH y deberá validarse de forma independiente como entorno objetivo.

## Recuperación

El estado se recupera con `git switch --detach baseline-karate-original`. No deben copiarse reportes desde `target/` al trabajar desde el tag.
