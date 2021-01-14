FROM openjdk:8-jdk-alpine
EXPOSE 8080
ADD *jarName*.jar myapp.jar
EXPOSE 50000-55500
ENTRYPOINT ["java","-jar","/myapp.jar"]