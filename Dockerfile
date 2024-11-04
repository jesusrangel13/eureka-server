# Usa una imagen base de JDK para construir el proyecto
FROM openjdk:17-jdk-slim AS build
WORKDIR /app
COPY . /app

# Ejecuta el build usando Gradle
RUN ./gradlew clean build -x test

# Usa una imagen de JRE ligera para ejecutar la aplicación
FROM openjdk:17-jdk-slim
WORKDIR /app
# Copia el JAR generado en la fase de build
COPY --from=build /app/build/libs/*.jar eureka-server.jar
EXPOSE 8761

# Configura el perfil de Spring al iniciar la aplicación
ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=production", "eureka-server.jar"]