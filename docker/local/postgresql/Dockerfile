# Use the official PostgreSQL base image
ARG POSTGRESQL_IMAGE
FROM ${POSTGRESQL_IMAGE}

# Set environment variables
ENV POSTGRES_USER=myuser
ENV POSTGRES_PASSWORD=mypassword
ENV POSTGRES_DB=mydatabase

# Copy initialization script
COPY init.sql /docker-entrypoint-initdb.d/

# Expose the PostgreSQL port (default is 5432)
EXPOSE ${POSTGRESQL_HOST_PORT}

