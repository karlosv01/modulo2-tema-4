#
# Build stage
#
FROM maven:3.8.6-openjdk-11-slim as build
ARG VERSION=0.0.1-SNAPSHOT

COPY ./src /home/app/src
COPY ./pom.xml /home/app

WORKDIR /home/app

# RUN mvn test

# RUN mvn sonar:sonar \
#   -Dsonar.projectKey=java-example-manual \
#   -Dsonar.host.url=http://localhost:9009 \
#   -Dsonar.login=0ccaba499738f2b7109139038a3b4fc94ea1c381
RUN mvn versions:set -DnewVersion=${VERSION}
RUN mvn install

#
# Package stage
#
FROM eclipse-temurin:11-jre-jammy
ARG VERSION=0.0.1-SNAPSHOT
COPY --from=build /home/app/target/spring-boot-2-hello-world-${VERSION}.jar /usr/local/lib/app.jar
ENTRYPOINT ["java","-jar","/usr/local/lib/app.jar"]
