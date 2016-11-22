FROM maven:3-jdk-8
ADD settings.xml /root/.m2/settings.xml
WORKDIR /code
ADD pom.xml /code/pom.xml
CMD mvn "help:effective-settings"
CMD mvn "dependency:resolve"
ADD src /code/src
CMD mvn "tomcat7:run"