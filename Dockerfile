FROM mobiledevops/android-sdk-image:33.0.2

# Create a group and add both users to it
RUN groupadd fluttergroup \
    && usermod -aG fluttergroup mobiledevops \
    && usermod -aG fluttergroup atmost

ENV FLUTTER_VERSION="3.24.3"
ENV CHANNEL="stable"
ENV FLUTTER_HOME="/home/mobiledevops/.flutter-sdk"
ENV PATH=$PATH:$FLUTTER_HOME/bin

# Download and extract Flutter SDK
RUN mkdir -p $FLUTTER_HOME \
    && cd $FLUTTER_HOME \
    && curl --fail --remote-time --silent --location -O https://storage.googleapis.com/flutter_infra_release/releases/${CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${CHANNEL}.tar.xz \
    && tar xf flutter_linux_${FLUTTER_VERSION}-${CHANNEL}.tar.xz --strip-components=1 \
    && rm flutter_linux_${FLUTTER_VERSION}-${CHANNEL}.tar.xz

# Set the group ownership and permissions
RUN chown -R mobiledevops:fluttergroup $FLUTTER_HOME \
    && chmod -R 775 $FLUTTER_HOME

# Precache Flutter SDK
RUN flutter precache

# Switch back to atmost user for Jenkins agent to run
USER atmost




# FROM mobiledevops/android-sdk-image:33.0.2

# ENV FLUTTER_VERSION="3.24.3"
# ENV CHANNEL="stable"
# ENV FLUTTER_HOME "/home/mobiledevops/.flutter-sdk"
# ENV PATH $PATH:$FLUTTER_HOME/bin

# # Download and extract Flutter SDK
# RUN mkdir $FLUTTER_HOME \
#     && cd $FLUTTER_HOME \
#     && curl --fail --remote-time --silent --location -O https://storage.googleapis.com/flutter_infra_release/releases/${CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${CHANNEL}.tar.xz \
#     && tar xf flutter_linux_${FLUTTER_VERSION}-${CHANNEL}.tar.xz --strip-components=1 \
#     && rm flutter_linux_${FLUTTER_VERSION}-${CHANNEL}.tar.xz

# RUN flutter precache



# # Use OpenJDK 8 as the base image
# FROM openjdk:8

# # Set working directory
# WORKDIR /project

# # Install essential tools and dependencies
# RUN apt-get update && apt-get install -y \
#     build-essential \
#     curl \
#     unzip \
#     git \
#     wget \
#     lib32stdc++6 \
#     lib32z1 \
#     python3 \
#     && rm -rf /var/lib/apt/lists/*

# # Set environment variables for Android SDK
# ENV ANDROID_HOME /usr/local/android-sdk
# ENV PATH $ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH

# # Define Android SDK version and Flutter installation URL
# ENV ANDROID_VERSION=29
# ENV SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip"
# ENV FLUTTER_VERSION="3.10.0"
# ENV FLUTTER_HOME="/usr/local/flutter"
# ENV PATH="$PATH:$FLUTTER_HOME/bin"

# # Download and install Android SDK
# RUN mkdir -p "$ANDROID_HOME" .android \
#     && curl -o sdk-tools.zip $SDK_URL \
#     && unzip sdk-tools.zip -d $ANDROID_HOME/cmdline-tools \
#     && rm sdk-tools.zip \
#     && mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/tools \
#     && mkdir -p "$ANDROID_HOME/licenses" \
#     && echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "$ANDROID_HOME/licenses/android-sdk-license" \
#     && yes | $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager --licenses

# # Install required Android SDK components
# RUN $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager --update \
#     && $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager \
#     "platform-tools" \
#     "platforms;android-${ANDROID_VERSION}" \
#     "build-tools;29.0.2"

# # Download and install Flutter
# RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 $FLUTTER_HOME

# # Enable Flutter and Dart PATH for future commands
# RUN flutter config --no-analytics \
#     && flutter doctor --android-licenses \
#     && flutter doctor

# # Set up Gradle properties for the Android build
# COPY gradle.properties /root/.gradle/gradle.properties

# # Run Bash as the default command
# CMD ["/bin/bash"]
