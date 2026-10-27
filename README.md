# Ejecución por Tags
mvn test -Dkarate.options="--tags @createPet"

# Ejecución por entornos
mvn test -Dkarate.options="--tags @createPet" -Dkarate.env="dev"