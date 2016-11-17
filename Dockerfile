FROM maven:3-jdk-8-onbuild
ADD settings.xml /root/.m2/settings.xml
ENTRYPOINT ["mvn", "tomcat7:run"]