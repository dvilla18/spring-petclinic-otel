FROM eclipse-temurin:21-jdk-jammy AS base
WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:resolve
COPY src ./src

FROM base AS build
RUN ./mvnw package


FROM eclipse-temurin:21-jre-jammy AS production
EXPOSE 8080
ENV JAVA_OPTS=" -Xmx512m -Xms256m"
COPY --from=build /app/target/spring-petclinic-*.jar /spring-petclinic.jar
ENTRYPOINT ["sh", "-c", "exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /spring-petclinic.jar"]