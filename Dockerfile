# Use Tomcat 10.1 with JDK 17
FROM tomcat:10.1-jdk17-temurin

# Remove default webapps
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

# Expose port 8080
EXPOSE 8080

# Set Railway PORT environment variable just in case
ENV PORT=8080

# Start Tomcat
CMD ["catalina.sh", "run"]
