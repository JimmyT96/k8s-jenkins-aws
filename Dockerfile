FROM eclipse-temurin:11-jre-focal

LABEL org.opencontainers.image.authors="JimmyT96"
LABEL architecture="hybrid-legacy-bridge"

RUN groupadd -r spring && useradd -r -g spring spring
WORKDIR /app

ARG JAR_FILE=build/libs/*[!plain].jar
COPY ${JAR_FILE} app.jar

RUN chown spring:spring app.jar
USER spring:spring

ENTRYPOINT ["java", "-XX:+UseContainerSupport", "-Xmx512m", "-Xms256m", "-jar", "app.jar"]

EXPOSE 8080
