FROM maven:3-jdk-8
ADD settings.xml /root/.m2/settings.xml
WORKDIR /codes
ADD pom.xml /codes/pom.xml
CMD mvn "help:effective-settings"
CMD mvn "dependency:resolve"
ADD src /codes/src
CMD mvn "tomcat7:run"