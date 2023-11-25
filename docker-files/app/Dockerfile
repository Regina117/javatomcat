FROM openjdk:11 as build
RUN apt update && apt install maven -y
RUN git clone https://github.com/MuhanedYahya/JavaStack.git
# to switch to specific branch we can use -> git checkout docker
RUN cd JavaStack && git checkout docker && mvn install

FROM tomcat:9-jre11
LABEL "Project"="JavaStack"
LABEL "Author"="Muhaned"
# remove the default ROOT.war file
RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=build JavaStack/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD [ "catalina.sh","run"]