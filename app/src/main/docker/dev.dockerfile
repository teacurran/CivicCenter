FROM maven:3.9-amazoncorretto-21-debian

# RUN apk add --update maven make protobuf-dev

#RUN yum -y update
#RUN yum -y install wget
#
#RUN wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
#RUN sed -i s/\$releasever/7/g /etc/yum.repos.d/epel-apache-maven.repo
#RUN yum install -y apache-maven

#RUN yum -y install protobuf.x86_64

# Create a group and user
# RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Tell docker that all future commands should run as the appuser user

RUN apt-get update && apt-get install -y docker

RUN mkdir -p /app
# RUN chown appuser /app

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en'

RUN echo \
    "<settings xmlns='http://maven.apache.org/SETTINGS/1.0.0\' \
    xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' \
    xsi:schemaLocation='http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd'> \
        <localRepository>/app/.m2/repository</localRepository> \
        <interactiveMode>true</interactiveMode> \
        <usePluginRegistry>false</usePluginRegistry> \
        <offline>false</offline> \
    </settings>" \
    > /usr/share/maven/conf/settings.xml

# USER appuser
WORKDIR /app

# COPY ./pom.xml /app/
# # COPY ./.env /usr/src/app/
# COPY ./src /app/src/

#
#RUN chown 1001 /app \
#    && chmod "g+rwX" /app \
#    && chown 1001:root /app
#USER 1001
#
#
#RUN mkdir target

# We make four distinct layers so if there are application changes the library layers can be re-used
# COPY --chown=185 target/quarkus-app/lib/ /deployments/lib/
# COPY --chown=185 target/quarkus-app/*.jar /deployments/
# COPY --chown=185 target/quarkus-app/app/ /deployments/app/
# COPY --chown=185 target/quarkus-app/quarkus/ /deployments/quarkus/

# ENTRYPOINT "mvn-entrypoint.sh"

EXPOSE 8080
# USER 185

ENV AB_JOLOKIA_OFF=""
ENV JAVA_OPTS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"
# ENV JAVA_APP_JAR="/deployments/quarkus-run.jar"

CMD ["mvn", "-Dquarkus.http.host=0.0.0.0", "quarkus:dev"]

