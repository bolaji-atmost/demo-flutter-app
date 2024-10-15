FROM mobiledevops/android-sdk-image:33.0.2

# Define variables
ENV FLUTTER_VERSION="3.24.3"
ENV CHANNEL="stable"
ENV FLUTTER_HOME="/home/atmost/.flutter-sdk"
ENV PATH=$PATH:$FLUTTER_HOME/bin

# Create the 'atmost' user with UID:GID matching the Jenkins agent
RUN groupadd -g 1002 atmost \
    && useradd -m -u 1001 -g 1002 atmost

# Switch to 'atmost' user for the rest of the Dockerfile
USER atmost

# Create Flutter SDK directory
RUN mkdir -p $FLUTTER_HOME

# Download and extract Flutter SDK
RUN cd $FLUTTER_HOME \
    && curl --fail --remote-time --silent --location -O https://storage.googleapis.com/flutter_infra_release/releases/${CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${CHANNEL}.tar.xz \
    && tar xf flutter_linux_${FLUTTER_VERSION}-${CHANNEL}.tar.xz --strip-components=1 \
    && rm flutter_linux_${FLUTTER_VERSION}-${CHANNEL}.tar.xz

# Precache Flutter SDK
RUN flutter precache

# Configure Git to recognize the Flutter SDK directory as safe
RUN git config --global --add safe.directory $FLUTTER_HOME

# Set working directory
WORKDIR /home/atmost/app

# Ensure the PATH is updated
ENV PATH="$PATH:$FLUTTER_HOME/bin"

# Set the default command
CMD ["/bin/bash"]
