# Basic image with Ubuntu that can be used to make fake data as volume
FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    && rm -rf /var/lib/apt/lists/*

COPY data /app/data

# Default command is to echo content into a file in the app/Data folder
CMD ["sh", "-c", "echo 'Data file created' > /app/Data/datafile.txt"]