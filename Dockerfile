FROM java:8
RUN apt-get update
RUN apt-get install -y maven
WORKDIR /code
ADD pom.xml /code/pom.xml
COPY settings.xml /root/.m2/settings.xml
COPY settings.xml /etc/maven/settings.xml
CMD mvn --settings "/root/.m2/settings.xml" "help:effective-settings"