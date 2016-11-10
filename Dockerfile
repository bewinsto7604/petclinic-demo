RUN apt-get update
RUN apt-get install -y maven 
ADD settings.xml /root/.m2/settings.xml