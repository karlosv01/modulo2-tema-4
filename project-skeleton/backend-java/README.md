# Backend Java (Spring Boot) - skeleton

Este backend esta basado en el ejemplo Java del curso y se incluye aqui como codigo base para la practica guiada.

Su papel dentro del laboratorio es deliberadamente simple:
- exponer una API minima,
- practicar empaquetado con Docker,
- y servir como ejemplo de servicio stateless dentro de un stack mas amplio.

Importante:
- Este directorio forma parte del `project-skeleton`.
- Debe mantenerse como material de partida para la practica.
- La solucion final completa de la practica no debe publicarse dentro de este directorio.

## Endpoint de prueba
- `GET /hello`

## Ejecutar con Docker
Desde `project-skeleton/`:
```bash
docker build -t training-java-api:0.1 --build-arg VERSION=1.0.4-SNAPSHOT -f backend-java/devops/Dockerfile backend-java

docker run --rm -p 8084:8080 training-java-api:0.1
```

Probar:
```bash
curl -f http://localhost:8084/hello
```
