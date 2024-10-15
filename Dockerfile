FROM mobiledevops/android-sdk-image:33.0.2

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

# Change ownership and permissions for access by the mobiledevops user
RUN chown -R mobiledevops:mobiledevops $FLUTTER_HOME \
    && chmod -R 755 $FLUTTER_HOME

# Ensure the mobiledevops user can access the required directories
RUN mkdir -p /home/mobiledevops/.config/flutter \
    && chown -R mobiledevops:mobiledevops /home/mobiledevops

# Precache Flutter SDK as the mobiledevops user
USER mobiledevops
RUN flutter precache

# Switch back to root to create the atmost user
USER root

# Create the atmost user and group
RUN groupadd -g 1002 atmost && useradd -m -u 1001 -g 1002 atmost

# Switch to the atmost user
USER atmost

# Set the working directory for the Jenkins agent
WORKDIR /home/atmost

# End with the command to keep the container running
CMD ["bash"]
