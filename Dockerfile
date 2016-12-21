FROM maven:3-jdk-8
ADD settings.xml /root/.m2/settings.xml
WORKDIR /codees
ADD pom.xml /codees/pom.xml
CMD mvn "help:effective-settings"
CMD mvn "dependency:resolve"
ADD src /codees/src
CMD mvn "tomcat7:run"
