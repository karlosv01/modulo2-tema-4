# Practica 4 - GitOps con Argo CD: operar el stack desde Git

## Descripcion de la practica

En esta practica vas a instalar Argo CD en el cluster local de k3s y vas a usarlo para gestionar el mismo stack que ya desplegaste manualmente en la practica anterior. El objetivo no es cambiar la aplicacion, sino cambiar el modelo operativo: pasar de `kubectl apply` manual a un flujo GitOps donde Git define el estado deseado del cluster.

Como material de trabajo dispondras de un archivo `.zip` que incluira:
- Este documento, que actua como guia paso a paso y enunciado de la practica.
- El directorio `project-skeleton`, que contiene la estructura base de plantillas GitOps dentro de `project-skeleton/gitops/`.

La dinamica de trabajo consiste en avanzar leyendo en paralelo dos elementos:
- Este documento, donde se explica el objetivo de cada ejercicio, el orden recomendado y las validaciones que debes realizar.
- La estructura de `project-skeleton/gitops/`, donde encontraras las plantillas de Argo CD y Helm que tendras que revisar, completar o ajustar en cada ejercicio.

Esta practica depende de la practica 3. Se asume que ya tienes un cluster k3s operativo, que sabes usar `kubectl` y que ya entiendes el despliegue manual del stack con Kubernetes. GitOps no sustituye ese conocimiento: lo automatiza y lo hace mas trazable.

## Objetivo

Al finalizar, deberias ser capaz de:
- desplegar Argo CD en un cluster local de k3s,
- acceder a su interfaz y validar su instalacion,
- conectar Argo CD con un repositorio GitHub,
- crear una `Application` por componente del stack,
- desplegar PostgreSQL usando un chart Helm oficial gestionado por Argo CD,
- entender el ciclo `commit -> sync -> health`,
- y, opcionalmente, agrupar `webui`, `backend-java` y `backend-python` en un chart Helm reutilizable.

## Estructura que vas a usar

Trabajaras sobre esta estructura:
- `project-skeleton/gitops/README.md`
- `project-skeleton/gitops/argocd/00-projects/`
- `project-skeleton/gitops/argocd/01-applications/`
- `project-skeleton/gitops/helm/training-stack/`

Cada fichero contiene comentarios indicando:
- en que ejercicio se usa,
- que campos debes revisar,
- y que partes son placeholders o decisiones tecnicas.

## Ejercicio 1 - Desplegar Argo CD en k3s

### Objetivo

Instalar Argo CD en el cluster local y validar que todos sus componentes estan operativos.

### Por que se usa Argo CD

- Argo CD es un controlador GitOps para Kubernetes.
- Su funcion es comparar lo que esta definido en Git con el estado real del cluster.
- Permite sincronizar, visualizar y operar aplicaciones sin depender de cambios manuales en el clúster.

### Instalacion

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### Validacion

```bash
kubectl get ns
kubectl get all -n argocd
kubectl get pods -n argocd
kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s
kubectl wait --for=condition=available deployment/argocd-repo-server -n argocd --timeout=300s
kubectl wait --for=condition=available deployment/argocd-application-controller -n argocd --timeout=300s
kubectl logs -n argocd deploy/argocd-server
```

### Que deberias comprobar

- Que el namespace `argocd` existe.
- Que los Pods principales de Argo CD estan en estado `Running`.
- Que `argocd-server` y `argocd-repo-server` quedan disponibles.

## Ejercicio 2 - Configurar Argo CD y GitHub

### Objetivo

Acceder a la interfaz de Argo CD, obtener la contraseña inicial y registrar el repositorio Git que actuara como fuente de verdad.

### Por que este paso es importante

- GitOps solo tiene sentido si Argo CD puede leer el repositorio donde vive la configuracion.
- Esta conexion convierte GitHub en la fuente de verdad del despliegue.

### Acceso a la UI

```bash
kubectl -n argocd port-forward svc/argocd-server 8089:443
```

Accede a:
- https://localhost:8088

### Password inicial

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Usuario:
- `admin`

### Registrar el repositorio en Argo CD

Puedes hacerlo desde la UI o usando CLI. Como minimo, revisa:
- URL del repositorio.
- Tipo de autenticacion.
- Rama o revision a seguir.

### Validacion

```bash
kubectl get secret -n argocd
kubectl get cm -n argocd
kubectl get svc -n argocd
```

### Que deberias comprobar

- Que puedes acceder a la UI.
- Que la contraseña inicial funciona.
- Que el repositorio queda registrado correctamente y Argo CD puede leerlo.

## Ejercicio 3 - Crear una Application por componente desplegado manualmente

### Objetivo

Crear una `Application` de Argo CD para cada componente del stack que antes desplegaste manualmente con `kubectl`.

### Por que separar por componente

- Permite entender mejor que despliega cada parte del sistema.
- Facilita aislar errores y revisar el estado por componente.
- Ayuda a aplicar ownership y responsabilidades por parte del equipo.

### Componentes recomendados

- `database`
- `ddl-job`
- `backend-java`
- `backend-python`
- `webui`

### Por que se usa `Application`

- `Application` es el objeto central de Argo CD.
- Define repo, ruta, revision, destino y politica de sync.
- Es la unidad con la que Argo CD observa y sincroniza una parte concreta del sistema.

### Plantillas a revisar

- `project-skeleton/gitops/argocd/00-projects/training-project.yaml`
- `project-skeleton/gitops/argocd/01-applications/database-application.yaml`
- `project-skeleton/gitops/argocd/01-applications/ddl-job-application.yaml`
- `project-skeleton/gitops/argocd/01-applications/backend-java-application.yaml`
- `project-skeleton/gitops/argocd/01-applications/backend-python-application.yaml`
- `project-skeleton/gitops/argocd/01-applications/webui-application.yaml`

### Orden recomendado

```bash
kubectl apply -f project-skeleton/gitops/argocd/00-projects/training-project.yaml
kubectl apply -f project-skeleton/gitops/argocd/01-applications/database-application.yaml
kubectl apply -f project-skeleton/gitops/argocd/01-applications/ddl-job-application.yaml
kubectl apply -f project-skeleton/gitops/argocd/01-applications/backend-java-application.yaml
kubectl apply -f project-skeleton/gitops/argocd/01-applications/backend-python-application.yaml
kubectl apply -f project-skeleton/gitops/argocd/01-applications/webui-application.yaml
```

### Validacion

```bash
kubectl get appprojects -n argocd
kubectl get applications -n argocd
kubectl describe application -n argocd database
kubectl describe application -n argocd backend-java
kubectl describe application -n argocd backend-python
kubectl describe application -n argocd webui
```

### Que deberias comprobar

- Que las `Application` existen en el namespace `argocd`.
- Que apuntan al repo, path y namespace correctos.
- Que su estado pasa a `Synced` y `Healthy`, o que al menos muestran claramente el error si algo falla.

## Ejercicio 4 - Validar el flujo GitOps

### Objetivo

Entender el ciclo real de GitOps modificando una configuracion en Git y observando como Argo CD detecta y sincroniza el cambio.

### Que debes hacer

1. Modificar un manifiesto del stack en el repositorio Git.
2. Hacer commit y push.
3. Observar en Argo CD si aparece `OutOfSync`.
4. Ejecutar sincronizacion manual o dejar que sincronice automaticamente, segun la politica configurada.

### Validacion

```bash
kubectl get applications -n argocd
kubectl describe application -n argocd webui
kubectl describe application -n argocd backend-python
```

### Que deberias comprobar

- Que Argo CD detecta la diferencia entre Git y el cluster.
- Que la sincronizacion aplica el cambio esperado.
- Que el estado final vuelve a `Synced` y `Healthy`.

## Ejercicio 5 - Desplegar PostgreSQL usando un chart Helm oficial

### Objetivo

Desplegar PostgreSQL desde un chart Helm oficial, pero gestionado por Argo CD como parte de la estrategia GitOps.

### Por que hacer este ejercicio

- Permite ver que Argo CD no solo despliega manifiestos planos, tambien puede trabajar con charts Helm externos.
- Ayuda a entender una ventaja clara de Helm: reutilizar software empaquetado por terceros sin tener que escribir todos los YAML a mano.
- Introduce un caso muy realista: usar charts Helm oficiales para componentes de infraestructura y manifiestos propios para las aplicaciones.

### Plantilla a revisar

- `project-skeleton/gitops/argocd/01-applications/postgres-helm-application.yaml`

### Que debes revisar

- El repositorio Helm.
- El nombre del chart.
- La version del chart.
- Los valores Helm usados para usuario, password, base de datos y persistencia.
- El namespace de destino.

### Aplicacion

```bash
kubectl apply -f project-skeleton/gitops/argocd/01-applications/postgres-helm-application.yaml
```

### Validacion

```bash
kubectl get applications -n argocd
kubectl describe application -n argocd postgres-helm
kubectl get pods -n database
kubectl get svc -n database
kubectl get pvc -n database
```

### Que deberias comprobar

- Que Argo CD crea una aplicacion basada en chart Helm y no en manifiestos planos.
- Que PostgreSQL queda desplegado en el namespace `database`.
- Que se crean los recursos asociados, incluidos `Service` y persistencia.
- Que la aplicacion aparece en estado `Synced` y `Healthy`, o que al menos muestra de forma clara cualquier problema de valores o acceso.

## Ejercicio 6 - Crear un chart Helm para webui + 2 backends (opcional)

### Objetivo

Crear un chart Helm reutilizable que agrupe `webui`, `backend-java` y `backend-python`, y dejarlo preparado para ser usado por Argo CD.

### Por que se usa Helm aqui

- Helm permite empaquetar varios recursos Kubernetes como una unica unidad reutilizable.
- Reduce duplicacion de manifiestos cuando hay varios entornos con pequeñas diferencias.
- Encaja bien con GitOps porque Git puede almacenar el chart y los valores usados por cada entorno.

### Plantillas a revisar

- `project-skeleton/gitops/helm/training-stack/Chart.yaml`
- `project-skeleton/gitops/helm/training-stack/values.yaml`
- `project-skeleton/gitops/helm/training-stack/templates/backend-java-statefulset.yaml`
- `project-skeleton/gitops/helm/training-stack/templates/backend-python-deployment.yaml`
- `project-skeleton/gitops/helm/training-stack/templates/webui-deployment.yaml`
- `project-skeleton/gitops/helm/training-stack/templates/services.yaml`

### Que debes revisar

- Valores por defecto.
- Imagenes y puertos.
- Variables de entorno del backend Python.
- Separacion entre plantillas y configuracion.

### Validacion

```bash
helm lint project-skeleton/gitops/helm/training-stack
helm template training-stack project-skeleton/gitops/helm/training-stack
```

### Objetivo didactico

No se busca un chart complejo. Se busca entender:
- como Helm empaqueta recursos,
- como parametriza configuracion,
- y por que resulta util cuando GitOps empieza a operar varios entornos.

## Entrega de la practica

La entrega debe hacerse en un archivo `.zip` que incluya, como minimo:
- Este documento de la practica.
- El directorio `project-skeleton/gitops/` con las plantillas completadas o ajustadas.
- Capturas de pantalla o salidas de terminal con evidencias claras de instalacion, configuracion y sincronizacion.

Las evidencias minimas recomendadas son:
- La instalacion correcta de Argo CD en el namespace `argocd`.
- La salida de `kubectl get pods -n argocd`.
- El acceso a la UI de Argo CD.
- Evidencia de configuracion del repositorio Git en Argo CD.
- Una `Application` de Argo CD por componente, o una estructura equivalente claramente separada.
- Evidencia de despliegue de PostgreSQL usando el chart Helm oficial.
- Evidencia de estado `Synced` y `Healthy` en las aplicaciones creadas.
- Un cambio en Git reflejado despues en Argo CD mediante sincronizacion manual o automatica.

Si realizas la parte opcional de Helm, añade tambien:
- El chart Helm creado dentro de `project-skeleton/gitops/helm/`.
- Evidencia de `helm lint`.
- Evidencia de `helm template`.

## Resultado esperado

Al completar la practica, deberias haber entendido:
- como instalar y validar Argo CD,
- como conectar GitHub con el cluster mediante GitOps,
- como modelar aplicaciones con objetos `Application` de Argo CD,
- como usar charts Helm oficiales dentro de Argo CD,
- como observar estados `Synced`, `OutOfSync` y `Healthy`,
- y como Helm puede integrarse como capa de reutilizacion dentro de una estrategia GitOps.
