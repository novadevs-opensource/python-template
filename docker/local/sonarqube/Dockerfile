# Use the official SONARQUBE base image
ARG SONARQUBE_IMAGE
FROM ${SONARQUBE_IMAGE}

# Example
# COPY sonar-custom-plugin-1.0.jar /opt/sonarqube/extensions/

# Expose the port on which the Flask app will run (default is 5000)
ARG SONARQUBE_PORT
EXPOSE ${SONARQUBE_PORT}
