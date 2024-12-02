# Use the official Python image from the Docker Hub
FROM python:3.13

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Expose port 5000 to the outside world
EXPOSE 8080

# Run helloworld.py when the container launches
ENTRYPOINT ["python3", "helloworld.py"]
