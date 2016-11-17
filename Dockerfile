FROM java:8
RUN apt-get update
RUN apt-get install -y maven
WORKDIR /code
ADD pom.xml /code/pom.xml
COPY settings.xml /root/.m2/settings.xml
CMD cat "/root/.m2/settings.xml"