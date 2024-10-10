# Use OpenJDK 8 as the base image
FROM openjdk:8

# Set working directory
WORKDIR /project

# Install essential tools and dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    unzip \
    git \
    wget \
    lib32stdc++6 \
    lib32z1 \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for Android SDK
ENV ANDROID_HOME /usr/local/android-sdk
ENV PATH $ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH

# Define Android SDK version and Flutter installation URL
ENV ANDROID_VERSION=29
ENV SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip"
ENV FLUTTER_VERSION="3.10.0"
ENV FLUTTER_HOME="/usr/local/flutter"
ENV PATH="$PATH:$FLUTTER_HOME/bin"

# Download and install Android SDK
RUN mkdir -p "$ANDROID_HOME" .android \
    && curl -o sdk-tools.zip $SDK_URL \
    && unzip sdk-tools.zip -d $ANDROID_HOME/cmdline-tools \
    && rm sdk-tools.zip \
    && mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/tools \
    && mkdir -p "$ANDROID_HOME/licenses" \
    && echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "$ANDROID_HOME/licenses/android-sdk-license" \
    && yes | $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager --licenses

# Install required Android SDK components
RUN $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager --update \
    && $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager \
    "platform-tools" \
    "platforms;android-${ANDROID_VERSION}" \
    "build-tools;29.0.2"

# Download and install Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 $FLUTTER_HOME

# Enable Flutter and Dart PATH for future commands
RUN flutter config --no-analytics \
    && flutter doctor --android-licenses \
    && flutter doctor

# Set up Gradle properties for the Android build
COPY gradle.properties /root/.gradle/gradle.properties

# Run Bash as the default command
CMD ["/bin/bash"]
