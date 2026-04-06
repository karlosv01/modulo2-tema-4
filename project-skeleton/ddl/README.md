# DDL scripts

Este directorio contiene scripts SQL para inicializar la base de datos del laboratorio.

## Contenido
- `init.sql`: crea una tabla minima de control (`healthcheck`) y una tabla de ejemplo (`favorite_colors`) usada por el backend Python.

## Cómo se ejecuta en la práctica
En `project-skeleton/docker-compose.yml` existe el servicio `ddl_job` que:
- espera a que PostgreSQL esté listo (`pg_isready`),
- ejecuta `psql` contra `db`,
- y termina.

Validación rápida:
```bash
docker compose exec db psql -U training -d trainingdb -c "select count(*) from healthcheck;"
docker compose exec db psql -U training -d trainingdb -c "select * from favorite_colors;"
```
