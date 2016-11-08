FROM maven:3-jdk-8-onbuild
ENTRYPOINT ["mvn", "tomcat7:run"]