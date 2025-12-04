# Stage 1: Build the application
FROM eclipse-temurin:17-jdk AS builder

# Install Ant
RUN apt-get update && apt-get install -y ant && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Create lib directory for dependencies
RUN mkdir -p lib

# Download dependencies
# mysql-connector-java
RUN curl -o lib/mysql-connector-java-8.0.28.jar https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar

# rs2xml.jar - Attempting to download from a public GitHub repository
RUN curl -L -o lib/rs2xml.jar https://github.com/patrickwang1/rs2xml/raw/master/rs2xml.jar

# Copy project files
COPY . .

# Create build.properties to override paths
RUN echo "file.reference.mysql-connector-java-8.0.28.jar=lib/mysql-connector-java-8.0.28.jar" > build.properties && \
    echo "file.reference.rs2xml.jar=lib/rs2xml.jar" >> build.properties && \
    echo "libs.CopyLibs.classpath=lib/org-netbeans-modules-java-j2seproject-copylibstask.jar" >> build.properties

# Build the project
RUN ant -Dlibs.CopyLibs.classpath="" clean jar

# Stage 2: Runtime with NoVNC
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Java, X11, VNC, Window Manager, and Supervisor
RUN apt-get update && apt-get install -y \
    openjdk-17-jre \
    xvfb \
    x11vnc \
    fluxbox \
    supervisor \
    net-tools \
    git \
    python3 \
    python3-numpy \
    && rm -rf /var/lib/apt/lists/*

# Install NoVNC
WORKDIR /opt
RUN git clone https://github.com/novnc/noVNC.git && \
    git clone https://github.com/novnc/websockify noVNC/utils/websockify && \
    ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

WORKDIR /app

# Copy the built jar and dependencies
COPY --from=builder /app/dist/Electricity_Billing_System.jar app.jar
COPY --from=builder /app/lib /app/lib
COPY --from=builder /app/src/icon /app/src/icon
COPY --from=builder /app/dist /app/dist

# Copy supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set environment variables for display
ENV DISPLAY=:0
ENV RESOLUTION=1280x800

# Expose port 8080 for NoVNC
ENV PORT=8080
EXPOSE 8080

# Start Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
