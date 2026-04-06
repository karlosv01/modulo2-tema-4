# Backend Python (Flask) - skeleton

Este backend Python se incluye como servicio con persistencia real en PostgreSQL.

Su objetivo dentro de la practica es simple:
- mostrar un backend ligero y facil de entender,
- consumir datos desde la base de datos del laboratorio,
- y servir como ejemplo claro de integracion entre aplicacion y persistencia.

Endpoint principal:
- `GET /`

El servicio espera estas variables de entorno:
- `DB_HOST`
- `DB_PORT`
- `DB_NAME`
- `DB_USER`
- `DB_PASSWORD`
