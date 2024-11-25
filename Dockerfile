# Base image
FROM python:3.10-slim

# Install dependencies for Selenium and Chrome
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    gnupg \
    libnss3 \
    libgconf-2-4 \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
    apt-get update && apt-get install -y google-chrome-stable

# Install Chromedriver
RUN wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/`curl -s https://chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    rm /tmp/chromedriver.zip

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port
EXPOSE 5000

# Run Flask app
CMD ["python", "app.py"]
