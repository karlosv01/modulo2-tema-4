# Plantillas Kubernetes - practica guiada

Este directorio contiene la estructura base de manifiestos para desplegar en Kubernetes el mismo stack trabajado antes con Docker Compose.

No es una solucion final. Es una plantilla guiada organizada por ejercicios.

## Estructura

- `00-namespaces/`: namespaces base del laboratorio.
- `00-storage/`: almacenamiento persistente local del laboratorio.
- `01-configmaps/`: configuracion y DDL que se inyectan como ConfigMap.
- `02-database/`: manifiestos de PostgreSQL y almacenamiento persistente.
- `03-jobs/`: Job para inicializar el modelo de datos.
- `04-apps/`: manifiestos de `webui`, `backend-java` y `backend-python`.

## Criterio de trabajo

La dinamica recomendada es:

1. Leer el ejercicio en la practica guiada.
2. Abrir el manifiesto YAML correspondiente.
3. Completar o ajustar los bloques marcados con comentarios.
4. Aplicar solo la parte que estes trabajando.
5. Validar con `kubectl get`, `kubectl describe`, `kubectl logs` y `kubectl exec`.

## Importante

- Algunos manifiestos usan valores de ejemplo o placeholders.
- Los comentarios dentro de cada YAML indican que revisar en cada ejercicio.
- El objetivo es aprender la estructura de los objetos de Kubernetes, no copiar una solucion cerrada.
