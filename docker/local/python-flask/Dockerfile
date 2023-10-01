# Use the official Python base image
ARG FLASK_IMAGE
FROM ${FLASK_IMAGE}

# Set the working directory inside the container
WORKDIR /app

# Argument to specify source directory
ARG FLASK_SRC_DIR

# Copy the application files to the container's working directory so the dependencies can be installed
COPY $FLASK_SRC_DIR/requirements.txt /app/

# Install the required dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r /app/requirements.txt

# Expose the port on which the Flask app will run (default is 5000)
ARG FLASK_PORT
EXPOSE ${FLASK_PORT}

# Set the entry point command to run the Flask app
CMD ["python", "__init__.py"]
