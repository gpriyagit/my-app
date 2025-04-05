# Use official Python image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy code
COPY . /app

# Install dependencies
RUN pip install -r requirements.txt

# Expose the port Flask runs on
EXPOSE 5000

# Start the app
CMD ["python", "app.py"]
