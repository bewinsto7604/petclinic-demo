FROM maven:3-jdk-8
ADD settings.xml /root/.m2/settings.xml
ENTRYPOINT ["mvn", "tomcat:run"]