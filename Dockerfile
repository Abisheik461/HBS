# Use Tomcat 10.1 with JDK 17
FROM tomcat:10.1-jdk17-temurin

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your JSP project directly into ROOT
COPY . /usr/local/tomcat/webapps/ROOT/

# Ensure WEB-INF/lib exists
RUN mkdir -p /usr/local/tomcat/webapps/ROOT/WEB-INF/lib

# Download MySQL Connector JAR
RUN apt-get update && apt-get install -y curl && \
    curl -L -o /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/mysql-connector-j-8.3.0.jar \
    https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.3.0/mysql-connector-j-8.3.0.jar && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Railway assigns a dynamic PORT value (not always 8080)
ENV PORT=8080
EXPOSE ${PORT}

# Update Tomcat server.xml to listen on the assigned Railway port
RUN sed -i 's/port="8080"/port="${PORT}"/' /usr/local/tomcat/conf/server.xml

# Start Tomcat
CMD ["catalina.sh", "run"]
