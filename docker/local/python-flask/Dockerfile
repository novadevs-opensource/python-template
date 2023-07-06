# Use the official Python base image
ARG FLASK_IMAGE
FROM ${FLASK_IMAGE}

# Set the working directory inside the container
WORKDIR /app

# Copy the application files to the container's working directory
ARG SRC
COPY ${SRC} /app
COPY config.py /app
COPY requirements.txt /app

# Set the file permissions for the copied files
RUN chmod -R 755 /app

# Install the required dependencies
RUN pip install -r requirements.txt

# Expose the port on which the Flask app will run (default is 5000)
EXPOSE ${FLASK_PORT}

# Set the entry point command to run the Flask app
CMD ["python", "__init__.py"]
