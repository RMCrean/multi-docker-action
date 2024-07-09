# Basic image with Ubuntu that can be used to make fake data as volume
FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    && rm -rf /var/lib/apt/lists/*
