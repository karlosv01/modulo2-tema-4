# Project skeleton - Practica guiada con Docker Compose

Este directorio debe mantenerse como plantilla de trabajo y material guiado. La solucion final de la practica debe quedar fuera de `project-skeleton`, en otro directorio o en otra rama, para no romper el enfoque incremental del laboratorio.

Aqui no se entrega una solucion cerrada. Aqui tienes un punto de partida para construir, paso a paso, un entorno de desarrollo basado en contenedores usando `docker compose`.

El objetivo de la practica es aprender a:
- Entender la estructura de un `docker-compose.yml`.
- Levantar un entorno DEV por capas.
- Relacionar frontend, backend, base de datos y herramientas DevOps.
- Validar el estado del entorno con comandos simples.
- Gestionar el ciclo de vida del laboratorio: arrancar, observar, parar, destruir y recrear.

## Objetivo funcional del entorno

Al finalizar los ejercicios tendras desplegados estos servicios:
- `db`: base de datos PostgreSQL para el backend Python.
- `ddl_job`: job de inicializacion que crea la estructura minima de base de datos.
- `backend-java`: API Java sencilla y sin persistencia.
- `backend-python`: API Python conectada a PostgreSQL.
- `webui`: interfaz web servida con Nginx que invoca ambos backends.
- `registry`: registry Docker privado para pruebas locales.
- `sonardb` y `sonarqube`: servicios de analisis de calidad.
- `artifactory`: repositorio de artefactos para binarios e imagenes auxiliares del laboratorio.

La idea no es solo "levantar contenedores". La idea es aprender a usar Docker Compose como herramienta diaria de desarrollo para validar una arquitectura de microservicios en local antes de llevarla a CI/CD o a un orquestador como Kubernetes.

## Estructura del directorio

- `webui/`: frontend web sencillo con su `Dockerfile`.
- `backend-java/`: backend Java sin persistencia, pensado para practicar empaquetado y despliegue.
- `backend-python/`: backend Python con acceso real a PostgreSQL.
- `ddl/`: scripts SQL para inicializar la base de datos.
- `docker-compose.yml`: plantilla guiada que debes completar y activar progresivamente.

## Regla del directorio

`project-skeleton` es solo para:
- Plantillas.
- Codigo base.
- Ejercicios guiados.
- Ficheros incompletos o parcialmente preparados para la practica.

`project-skeleton` no es el lugar para:
- Publicar la solucion final completa.
- Dejar todos los servicios ya cerrados y resueltos.
- Convertir la practica en un simple "levantar y copiar".

## Prerrequisitos

- Docker instalado y operativo.
- Docker Compose disponible con `docker compose version`.
- Terminal basica: ejecutar comandos, leer logs y repetir pruebas.

## Como plantear la practica

No intentes levantar todo a la vez desde el principio. Ese enfoque genera mucho ruido y dificulta el aprendizaje. El criterio correcto es construir el entorno por capas:

1. Infraestructura de datos.
2. Backend Java sin persistencia.
3. Backend Python con persistencia.
4. Frontend.
5. Herramientas auxiliares del ecosistema DevOps.

Cada vez que completes una capa:
- Arranca solo los servicios de esa capa.
- Verifica que funcionan.
- Revisa logs.
- Corrige problemas.
- Solo entonces pasa al siguiente bloque.

## Antes de empezar: que es cada pieza del laboratorio

Este laboratorio esta pensado para que puedas seguirlo incluso si no vienes del mundo Java ni del desarrollo web. Por eso conviene entender las piezas desde una perspectiva funcional y no desde una perspectiva de programacion.

- `db` es la base de datos donde la aplicacion guarda informacion.
- `ddl_job` es un contenedor tecnico que prepara la base de datos antes de usarla.
- `backend-java` es un servicio sencillo para practicar empaquetado, puertos y ejecucion de una API stateless.
- `backend-python` es un servicio que si usa la base de datos y permite ver una integracion real entre aplicacion y persistencia.
- `webui` es la interfaz que ve el usuario en el navegador y desde la que se pueden probar ambos backends.
- `registry` es un almacen local de imagenes Docker.
- `sonarqube` es una herramienta que analiza la calidad del codigo.
- `artifactory` es un repositorio donde guardar artefactos binarios del proyecto.

No hace falta ser desarrollador Java ni Python para esta practica. Lo importante es entender que cada servicio cumple una responsabilidad y que Docker Compose los coordina como un unico entorno.

## Como leer el docker-compose.yml de forma didactica

En esta practica, el `docker-compose.yml` no es solo un fichero tecnico. Debes leerlo como si fuera el plano del entorno.

Las secciones principales que necesitas entender son estas:

- `services`: define que contenedores forman el laboratorio y que papel cumple cada uno.
- `image`: indica que imagen se va a ejecutar cuando no hace falta construirla desde codigo fuente.
- `build`: indica como construir una imagen localmente a partir de un contexto y un Dockerfile.
- `environment`: inyecta configuracion dentro del contenedor sin modificar el codigo fuente.
- `volumes`: mantiene datos persistentes o monta contenido del host dentro del contenedor.
- `networks`: conecta los servicios entre si a traves de una red interna.
- `depends_on`: ordena el arranque basico entre servicios relacionados.
- `ports`: publica un puerto del contenedor hacia la maquina host.

## Por que son importantes `environment`, `volumes`, `networks`, `depends_on` y `ports`

### `environment`

Se usa para pasar configuracion al contenedor en tiempo de ejecucion.

Ejemplos del laboratorio:
- En `db`, las variables `POSTGRES_USER`, `POSTGRES_PASSWORD` y `POSTGRES_DB` permiten que la imagen oficial de PostgreSQL cree la base de datos inicial.
- En `ddl_job`, `PGPASSWORD` evita tener que escribir la contraseña manualmente al ejecutar `psql`.
- En `backend-python`, las variables `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER` y `DB_PASSWORD` permiten conectar con la base de datos sin hardcodear esa configuracion en el codigo.

La idea didactica es simple: la imagen no cambia, lo que cambia es la configuracion del entorno.

### `volumes`

Se usan para dos cosas distintas:
- persistir datos,
- o montar contenido del host dentro del contenedor.

Ejemplos del laboratorio:
- `db_data` guarda los datos de PostgreSQL fuera del contenedor para no perderlos al destruirlo.
- `./ddl:/ddl:ro` monta los scripts SQL del directorio local dentro del `ddl_job` en modo solo lectura.
- Los volumenes de `sonarqube`, `sonardb`, `registry` y `artifactory` hacen lo mismo para los servicios auxiliares.

La idea didactica es que, si hay datos importantes, no deben vivir solo dentro del contenedor.

### `networks`

Se usan para que los servicios puedan comunicarse entre si de forma privada.

Ejemplo del laboratorio:
- `ddl_job` puede conectarse a PostgreSQL usando simplemente `db` como hostname.
- `backend-python` tambien puede usar `db` como host de base de datos.

La idea didactica es evitar IPs manuales. En Compose, los servicios se hablan por nombre.

### `depends_on`

Se usa para expresar que un servicio necesita que otro se arranque antes.

Ejemplo del laboratorio:
- `ddl_job` depende de `db`.
- `backend-python` deberia depender de `db` y `ddl_job`.
- `webui` deberia depender de `backend-java` y `backend-python`.

Importante a nivel tecnico:
- `depends_on` ordena el arranque.
- `depends_on` no garantiza que el servicio dependiente ya este listo para aceptar conexiones.

Por eso `ddl_job` no se apoya solo en `depends_on`: tambien ejecuta `pg_isready` antes de lanzar el script SQL.

### `ports`

Se usan para publicar servicios hacia la maquina host y poder validarlos desde fuera de Docker.

Ejemplos del laboratorio:
- `5432:5432` permite conectar a PostgreSQL desde el host.
- `8084:8080` permite acceder al backend Java desde navegador o `curl`.
- `5001:5000` permite acceder al backend Python desde el host.
- `8080:80` publica la web.

La idea didactica es distinguir entre:
- el puerto interno del contenedor,
- y el puerto externo por el que accedes desde tu maquina.

## Por que se necesita SonarQube

SonarQube no es una aplicacion de negocio. Es una herramienta de apoyo para el equipo.

Su funcion principal es analizar codigo fuente y detectar problemas como:
- Errores potenciales.
- Codigo duplicado.
- Problemas de mantenibilidad.
- Riesgos de seguridad basicos.

Explicado de forma simple:
- Si el compilador te dice si el codigo "rompe",
- SonarQube te ayuda a ver si el codigo "esta bien construido".

En un entorno DevOps, SonarQube se usa porque:
- Da informacion objetiva sobre la calidad tecnica.
- Ayuda a revisar cambios antes de desplegar.
- Se integra bien con pipelines de CI/CD.

Aunque en esta practica no entres a programar en detalle, interesa verlo porque forma parte del ecosistema real de plataformas de desarrollo.

## Por que se necesita Artifactory

Artifactory tampoco es una aplicacion de negocio. Es un almacen de artefactos.

Un artefacto es cualquier resultado empaquetado de un proceso de build, por ejemplo:
- Un `.jar` de Java.
- Una libreria descargada por el proyecto.
- Un paquete binario.
- En algunos escenarios, tambien imagenes o componentes relacionados.

Explicado de forma simple:
- Git guarda codigo fuente.
- Artifactory guarda "productos construidos" a partir de ese codigo.

Esto es importante porque:
- Permite reutilizar artefactos sin reconstruirlos siempre.
- Da trazabilidad sobre que version se ha generado.
- Facilita que distintos entornos usen el mismo binario validado.
- Es una pieza habitual en pipelines de integracion y despliegue.

En esta practica se incluye para que veas que un entorno de desarrollo moderno no solo ejecuta apps, tambien necesita servicios para gestionar calidad y artefactos.

## Ejercicio 1 - Leer la plantilla antes de ejecutar nada

Abre [`docker-compose.yml`](./docker-compose.yml) y localiza estas secciones:
- `networks`
- `volumes`
- `services`

Que necesitas entender antes de seguir:
- La red `training_net` se usa para comunicar todos los servicios entre si.
- Los volumenes se usan para guardar datos persistentes fuera del contenedor.
- Los servicios comentados representan bloques que iras completando o activando durante la practica.
- Solo `db` y `ddl_job` estan operativos desde el inicio para que puedas arrancar la primera capa sin recibir la solucion final.

Objetivo del ejercicio:
- Ser capaz de explicar con tus palabras para que sirve cada servicio del archivo.
- Identificar que servicios forman el minimo viable del entorno.

## Ejercicio 2 - Levantar la capa de base de datos

Empieza solo con:
- `db`
- `ddl_job`

Comando recomendado:

```bash
docker compose up -d db ddl_job
```

Que revisar:
- Que `db` quede en estado `running`.
- Que `ddl_job` arranque, ejecute el script SQL y termine correctamente.

Comandos utiles:

```bash
docker compose ps
docker compose logs -f db
docker compose logs -f ddl_job
```

Validacion esperada:
- La base de datos escucha en `localhost:5432`.
- El script `ddl/init.sql` se ha ejecutado sin error.

Validacion SQL:

```bash
docker compose exec db psql -U training -d trainingdb -c "\\dt"
docker compose exec db psql -U training -d trainingdb -c "select count(*) from healthcheck;"
docker compose exec db psql -U training -d trainingdb -c "select * from favorite_colors;"
```

Que aprendes aqui:
- Que un entorno no siempre empieza por la app.
- Que Compose permite levantar solo una parte del stack.
- Que los jobs tecnicos tambien se modelan como servicios.

## Ejercicio 3 - Completar y levantar el backend Java

Ahora trabaja con el servicio `backend-java`. En el `docker-compose.yml` no esta resuelto: aparece como un bloque comentado con pistas que debes rellenar.

Revisa dentro del compose:
- `build.context`
- `build.dockerfile`
- `depends_on`
- `environment`
- `ports`

Preguntas a resolver:
- Desde que carpeta debe construirse la imagen del backend Java.
- Que Dockerfile debe usarse.
- En que puerto expone la aplicacion dentro del contenedor.

Cuando lo tengas claro, levanta la siguiente capa:

```bash
docker compose up -d --build backend-java
```

Comandos de validacion:

```bash
docker compose ps
docker compose logs -f backend-java
curl http://localhost:8084/hello
```

Que aprendes aqui:
- Que no todos los servicios de un stack necesitan persistencia.
- Que la configuracion de puertos y build tambien es parte de la definicion del entorno.
- Que Compose facilita reconstruir solo el servicio que estas desarrollando.

## Ejercicio 4 - Completar y levantar el backend Python

Ahora trabaja con el servicio `backend-python`. Este servicio si depende de PostgreSQL y es el que da sentido tecnico a la base de datos dentro del laboratorio.

Revisa:
- Su contexto de build.
- El `Dockerfile` del backend Python.
- Las variables `DB_*`.
- Su dependencia con `db` y `ddl_job`.
- El puerto interno del contenedor y el puerto publicado hacia el host.

Arranque recomendado:

```bash
docker compose up -d --build backend-python
```

Validacion:

```bash
docker compose ps
docker compose logs -f backend-python
curl http://localhost:5001/
```

Resultado esperado:
- El backend Python responde con un JSON obtenido desde PostgreSQL.
- El entorno ya tiene una integracion real entre aplicacion y base de datos.

Que aprendes aqui:
- Que una base de datos en Docker Compose tiene sentido cuando una aplicacion la consume de verdad.
- Que `environment`, `depends_on`, `networks` y `volumes` no son teoria: resuelven conectividad y persistencia reales.

## Ejercicio 5 - Completar y levantar la web

Una vez validados ambos backends, trabaja el servicio `webui`. Igual que en los casos anteriores, debes completar el bloque comentado dentro del `docker-compose.yml`.

Revisa:
- Su contexto de build.
- El `Dockerfile` del frontend.
- El puerto interno del contenedor.
- Su dependencia con `backend-java` y `backend-python`.
- El puerto del host donde quieres publicarlo.

Arranque recomendado:

```bash
docker compose up -d --build webui
```

Validacion:

```bash
docker compose ps
docker compose logs -f webui
curl http://localhost:8080
```

Resultado esperado:
- La interfaz web queda accesible desde navegador.
- La pagina permite invocar tanto el backend Java como el backend Python.
- El entorno ya tiene cuatro capas activas: datos, backend Java, backend Python y frontend.

Que aprendes aqui:
- Que un stack de microservicios puede combinar servicios con persistencia y servicios stateless.
- Que el frontend tambien puede empaquetarse, versionarse y validarse como contenedor.

## Ejercicio 6 - Activar un registry Docker privado

El siguiente paso es descomentar el servicio `registry`.

Objetivo:
- Tener un servicio local donde poder publicar imagenes del laboratorio.
- Entender el papel del registry dentro de una cadena CI/CD.

Arranque:

```bash
docker compose up -d registry
```

Validacion:

```bash
docker compose ps
docker compose logs -f registry
curl http://localhost:5000/v2/_catalog
```

Que aprendes aqui:
- Que un registry no ejecuta aplicaciones, almacena artefactos.
- Que una arquitectura DevOps real necesita tambien servicios de soporte.

## Ejercicio 7 - Activar SonarQube y su base de datos

Ahora descomenta:
- `sonardb`
- `sonarqube`

Importante:
- Hazlo en ese orden conceptual: primero la base de datos, despues la aplicacion.
- Revisa bien las variables `SONAR_JDBC_*`.

Arranque:

```bash
docker compose up -d sonardb sonarqube
```

Validacion:

```bash
docker compose ps
docker compose logs -f sonardb
docker compose logs -f sonarqube
curl http://localhost:9009
```

Que aprendes aqui:
- Que muchos productos de plataforma necesitan su propia persistencia.
- Que un stack completo de desarrollo suele incluir herramientas que no forman parte directa del negocio.

## Ejercicio 8 - Activar Artifactory

El siguiente bloque opcional es `artifactory`.

Objetivo:
- Entender que una cadena de desarrollo no solo ejecuta aplicaciones, tambien almacena artefactos.
- Ver como una herramienta de plataforma se integra como un servicio mas dentro del laboratorio.

Arranque:

```bash
docker compose up -d artifactory
```

Validacion:

```bash
docker compose ps
docker compose logs -f artifactory
curl http://localhost:8081
```

Que aprendes aqui:
- Que Git no sustituye a un repositorio de artefactos.
- Que un entorno de desarrollo profesional necesita piezas para compilar, validar, almacenar y desplegar.

## Ejercicio 9 - Ver el entorno completo y entender dependencias

Cuando tengas todos los bloques activos, revisa el estado global:

```bash
docker compose ps
docker compose logs --tail=100
docker network inspect project-skeleton_training_net
```

Analiza:
- Que servicios estan activos.
- Que servicios exponen puertos al host.
- Que servicios solo viven en red interna.
- Que volumenes existen y a que servicio pertenecen.

Objetivo didactico:
- Aprender a leer el entorno como un sistema y no como contenedores aislados.

## Ejercicio 10 - Gestion del entorno en el dia a dia

Un desarrollador no solo levanta entornos. Tambien los observa, los corrige y los reinicia.

Comandos clave:

```bash
docker compose ps
docker compose logs -f backend-java
docker compose logs -f backend-python
docker compose logs -f webui
docker compose exec db psql -U training -d trainingdb
docker compose restart backend-java
docker compose restart backend-python
docker compose up -d --build backend-python
```

Explicacion:
- `logs` te ayuda a entender si un servicio falla por configuracion, conectividad o arranque.
- `exec` te deja entrar a un contenedor o ejecutar comandos dentro.
- `restart` reinicia el servicio sin cambiar imagen.
- `up -d --build <servicio>` reconstruye y vuelve a arrancar solo una parte del stack.

## Ejercicio 11 - Parar y destruir por capas

No siempre interesa destruir todo. A veces solo quieres apagar una capa o rehacer una parte concreta.

Parar solo frontend y backend:

```bash
docker compose stop webui backend-java backend-python
```

Eliminar solo frontend y backend:

```bash
docker compose rm -f webui backend-java backend-python
```

Destruir todo el stack sin borrar datos persistentes:

```bash
docker compose down
```

Destruir todo el stack borrando tambien volumenes:

```bash
docker compose down --volumes
```

Que conviene entender:
- `stop` apaga, pero mantiene los contenedores.
- `rm` elimina contenedores ya parados.
- `down` desmonta la composicion completa.
- `down --volumes` reinicia el laboratorio desde cero, incluyendo los datos.

## Ejercicio 12 - Recrear el entorno de forma controlada

El objetivo de esta practica no es solo arrancar una vez, sino ser capaz de rehacer el laboratorio cuantas veces haga falta.

Escenarios recomendados:
- Recrear solo backend Java tras cambiar codigo.
- Recrear solo backend Python tras cambiar codigo o configuracion de acceso a la base de datos.
- Recrear webui tras cambiar contenido estatico.
- Destruir solo la capa de aplicacion manteniendo la base de datos.
- Reiniciar todo desde cero borrando volumenes.

Secuencia completa de ejemplo:

```bash
docker compose down --volumes
docker compose up -d db ddl_job
docker compose up -d --build backend-java
docker compose up -d --build backend-python
docker compose up -d --build webui
docker compose up -d registry sonardb sonarqube artifactory
```

Aprendizaje buscado:
- Reproducibilidad.
- Aislamiento por capas.
- Disciplina operativa en desarrollo.

## Verificaciones minimas

Al terminar la practica, deberias poder demostrar:
- Que la base de datos arranca y contiene la estructura creada por `ddl_job`.
- Que el backend Java responde en `http://localhost:8084/hello`.
- Que el backend Python responde en `http://localhost:5001/`.
- Que la web responde en `http://localhost:8080`.
- Que el registry responde en `http://localhost:5000/v2/_catalog`.
- Que SonarQube responde en `http://localhost:9009`.
- Que Artifactory responde en `http://localhost:8081`.
- Que sabes parar, destruir y reconstruir el entorno de varias formas.

## Criterio tecnico importante

No memorices comandos de forma aislada. Lo importante es entender el ciclo:

1. Definir el entorno como codigo.
2. Levantar solo lo necesario.
3. Verificar estado y conectividad.
4. Revisar logs y corregir errores.
5. Destruir y recrear cuando haga falta.

Ese es exactamente el tipo de disciplina que despues se traslada a CI/CD, Kubernetes y automatizacion de despliegues.

## Como entregar la practica

La entrega debe hacerse en un archivo `.zip` que incluya, como minimo, el material necesario para revisar la definicion del entorno y las evidencias de ejecucion.

Contenido recomendado del `.zip`:
- `docker-compose.yml` completado.
- Los cambios realizados en `README.md`, si has documentado decisiones o explicaciones adicionales.
- Capturas de pantalla con las evidencias pedidas.
- Si lo consideras necesario, una nota breve con aclaraciones sobre puertos, problemas encontrados o decisiones tecnicas.

## Evidencias minimas que debes incluir

Incluye capturas de pantalla donde se vea claramente lo siguiente:

- El contenido final del `docker-compose.yml` con los servicios completados.
- La salida de `docker compose ps` con los servicios levantados.
- La salida de `docker compose logs` de `db` y `ddl_job`, mostrando que la base de datos arranca y que el script SQL se ejecuta.
- La validacion SQL desde PostgreSQL, mostrando al menos:
  - la tabla `healthcheck`,
  - y el contenido de `favorite_colors`.
- La llamada con `curl` al backend Java en `http://localhost:8084/hello`.
- La llamada con `curl` al backend Python en `http://localhost:5001/`.
- La web cargada en navegador en `http://localhost:8080`.
- La prueba visual o funcional desde la `webui` llamando a ambos backends.

Si has completado tambien los servicios opcionales, añade ademas:
- El acceso al registry en `http://localhost:5000/v2/_catalog`.
- La pantalla principal de SonarQube en `http://localhost:9009`.
- La pantalla principal de Artifactory en `http://localhost:8081`.

## Criterio de entrega

No se trata solo de mostrar que "arranca". La entrega debe reflejar que el entorno:
- esta definido correctamente en Docker Compose,
- se levanta de forma reproducible,
- expone los servicios esperados,
- y puede validarse con comandos simples y evidencias claras.

Si algun servicio opcional no se ha podido levantar por limitaciones del equipo, indicalo de forma explicita en la entrega y acompana la practica con las evidencias del resto del laboratorio.
