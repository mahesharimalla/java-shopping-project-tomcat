FROM tomcat:9.0
# Copy built WAR from target directory
COPY target/shopping-site-web-app.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
