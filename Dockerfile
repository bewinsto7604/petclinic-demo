FROM maven:3-jdk-8-onbuild
COPY . /usr/src/app
ENTRYPOINT ["mvn", "tomcat7:run"]