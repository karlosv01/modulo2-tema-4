# Plantillas GitOps - practica guiada

Este directorio contiene la estructura base para trabajar la practica 4 de GitOps con Argo CD.

No es una solucion final. Es una plantilla guiada organizada por ejercicios.

## Estructura

- `argocd/00-projects/`: definicion de `AppProject` base.
- `argocd/01-applications/`: una `Application` por componente del stack.
- `argocd/01-applications/postgres-helm-application.yaml`: ejemplo de `Application` usando un chart Helm oficial.
- `helm/training-stack/`: chart Helm opcional para `webui`, `backend-java` y `backend-python`.

## Criterio de trabajo

La dinamica recomendada es:

1. Leer el ejercicio correspondiente en la practica 4.
2. Abrir la plantilla YAML o el chart Helm indicado.
3. Completar los campos marcados con comentarios.
4. Aplicar o validar solo la parte que estes trabajando.
5. Comprobar el resultado con `kubectl`, Argo CD y, si aplica, `helm`.

## Importante

- Algunos ficheros usan placeholders que debes sustituir.
- Los comentarios dentro de cada archivo indican que revisar en cada ejercicio.
- El objetivo es aprender GitOps y Argo CD de forma incremental, no copiar una solucion cerrada.
