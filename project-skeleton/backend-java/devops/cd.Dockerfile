FROM eclipse-temurin:11-jre-jammy
ARG VERSION=1.0.4-SNAPSHOT

COPY ./target/spring-boot-2-hello-world-${VERSION}.jar /usr/local/lib/app.jar
ENTRYPOINT ["java","-jar","/usr/local/lib/app.jar"]
