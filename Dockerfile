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

# Change ownership and permissions for access by the atmost user
RUN chown -R mobiledevops:mobiledevops $FLUTTER_HOME \
    && chmod -R 755 $FLUTTER_HOME

# Ensure the atmost user can access the required directories
RUN mkdir -p /home/mobiledevops/.config/flutter \
    && chown -R mobiledevops:mobiledevops /home/mobiledevops

# Precache Flutter SDK as the mobiledevops user
USER mobiledevops
RUN flutter precache

# Switch to atmost user
RUN groupadd -g 1002 atmost && useradd -m -u 1001 -g 1002 atmost

# Set the working directory for the Jenkins agent
USER atmost
WORKDIR /home/atmost

# End with the command to keep the container running
CMD ["bash"]


# FROM mobiledevops/android-sdk-image:33.0.2

# # Set environment variables
# ENV FLUTTER_VERSION="3.24.3"
# ENV CHANNEL="stable"
# ENV FLUTTER_HOME="/home/mobiledevops/.flutter-sdk"
# ENV PATH=$PATH:$FLUTTER_HOME/bin

# # Ensure we are running as root to modify system files
# USER root

# # Create the 'atmost' user with UID:GID matching the Jenkins agent
# RUN groupadd -g 1002 atmost \
#     && useradd -m -u 1001 -g 1002 atmost

# # Download and extract Flutter SDK
# RUN mkdir -p $FLUTTER_HOME \
#     && cd $FLUTTER_HOME \
#     && curl --fail --remote-time --silent --location -O https://storage.googleapis.com/flutter_infra_release/releases/${CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${CHANNEL}.tar.xz \
#     && tar xf flutter_linux_${FLUTTER_VERSION}-${CHANNEL}.tar.xz --strip-components=1 \
#     && rm flutter_linux_${FLUTTER_VERSION}-${CHANNEL}.tar.xz

# # Change ownership and permissions for access by the 'atmost' user
# RUN chown -R atmost:atmost $FLUTTER_HOME \
#     && chmod -R 755 $FLUTTER_HOME

# # Precache Flutter SDK as the 'atmost' user
# USER atmost
# RUN flutter precache

# # Set the working directory for the Jenkins agent
# WORKDIR /home/atmost

# # End with the command to keep the container running
# CMD ["bash"]

