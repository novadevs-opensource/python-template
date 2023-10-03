# Use the official Python base image
ARG PYTHON_IMAGE
FROM ${PYTHON_IMAGE}

# Set the working directory inside the container
WORKDIR /app

# Argument to specify source directory
ARG SRC_DIR

# Copy the application files to the container's working directory so the dependencies can be installed
COPY ${SRC_DIR}/requirements.txt /app/

# Argument to know if Flask is installed or not
ARG PYTHON_BUILD

# Install the required dependencies
RUN pip install --upgrade pip && \
    if [ "${PYTHON_BUILD}" = "true" ]; then pip install --no-cache-dir -r requirements.txt; fi

# Expose the port on which the Flask app will run (default is 5000)
ARG PYTHON_PORT
EXPOSE ${PYTHON_PORT}

# Set the entry point command to run the Python app
CMD ["python", "__init__.py"]
