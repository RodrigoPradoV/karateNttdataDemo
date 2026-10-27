# Automatización API con Karate

La referencia funcional principal se conserva en `docs/reference/Informe_Automatizacion_Karate.pdf`. El estado original es recuperable mediante el tag `baseline-karate-original`.

## Requisitos

- Java 17 para el entorno objetivo.
- Maven.
- Variables `BOOKER_USERNAME` y `BOOKER_PASSWORD`; consultar `.env.example` sin versionar valores reales.

## Ejecución

Suite completa:

```bash
mvn -B -ntp clean test
```

Suite completa y reporte HTML Cucumber:

```bash
mvn -B -ntp clean verify
```

El reporte Cucumber se genera en `target/cucumber-html-reports/overview-features.html`. El reporte nativo de Karate permanece en `target/karate-reports/karate-summary.html`.

Los casos GET 404 crean y eliminan su propio recurso antes de comprobar la ausencia. Así la precondición negativa no depende de asumir que un ID aleatorio o fijo esté libre en una API pública compartida.

Por tag:

```bash
mvn -B -ntp test -Dkarate.options="--tags @petstore"
mvn -B -ntp test -Dkarate.options="--tags @restfulbooker"
```

Comprobar reportes antes de publicarlos:

```powershell
./scripts/verify-no-secrets.ps1 -Paths target
```

Los resultados generados bajo `target/` no se versionan. GitHub Actions publica los reportes sanitizados y su identidad de ejecución con una retención de 90 días. Consulte `docs/matriz-trazabilidad.md` y `docs/ejecuciones.md` para distinguir requisitos, decisiones, restricciones y evidencia vigente.
