FROM maven:3-jdk-8-onbuild
ENTRYPOINT ["mvn -U", "tomcat7:run"]