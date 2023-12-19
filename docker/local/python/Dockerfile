# Use the official Python base image
ARG PYTHON_IMAGE
FROM ${PYTHON_IMAGE}

# Set the working directory inside the container
WORKDIR /app

# Copy the application files to the container's working directory so the dependencies can be installed
ARG SOURCE_DIR
COPY ${SOURCE_DIR}/*-requirements.txt /app/

# Install the required dependencies
ARG PYTHON_BUILD
RUN pip install --upgrade pip && \
    if [ "${PYTHON_BUILD}" == "false" ]; then pip install --no-cache-dir -r flask-requirements.txt; else pip install --no-cache-dir -r python-requirements.txt; fi

# Expose the port on which the Flask app will run (default is 5000)
ARG PYTHON_PORT
EXPOSE ${PYTHON_PORT}

# Set the entry point command to run the Python app
CMD ["python", "__init__.py"]
