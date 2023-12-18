# Use the official PostgreSQL base image
ARG POSTGRES_IMAGE
FROM ${POSTGRES_IMAGE}

# Copy initialization SQL scripts
# COPY init.sql /docker-entrypoint-initdb.d/

# Expose the PostgreSQL port (default is 5432)
EXPOSE ${POSTGRES_PORT}
