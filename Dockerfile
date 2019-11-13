FROM ubuntu:latest

RUN useradd -ms /bin/bash nativescript

# Utilities
RUN apt-get update && \
    apt-get -y install g++ apt-transport-https unzip curl usbutils --no-install-recommends && \
    rm -r /var/lib/apt/lists/*

# JAVA
RUN apt-get update && \
    apt-get -y install openjdk-8-jdk --no-install-recommends && \
    rm -r /var/lib/apt/lists/*

# NodeJS
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get update && \
    apt-get -y install nodejs --no-install-recommends && \
    rm -r /var/lib/apt/lists/*

# NativeScript
RUN npm install -g nativescript && \
    tns error-reporting disable

# Android build requirements
RUN apt-get update && \
    apt-get -y install lib32z1 lib32ncurses5 lib32stdc++6 --no-install-recommends && \
    rm -r /var/lib/apt/lists/*

# Android SDK
ARG ANDROID_SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
ADD $ANDROID_SDK_URL /tmp/android-sdk.zip
RUN mkdir -p /usr/lib/android/sdk /app /dist && \
    chown root:root /tmp/android-sdk.zip /usr/lib/android/sdk /app /dist
ENV ANDROID_HOME /usr/lib/android/sdk
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
RUN export JAVA_HOME=$(update-alternatives --query javac | sed -n -e 's/Best: *\(.*\)\/bin\/javac/\1/p')
RUN tns error-reporting disable && \
    unzip -q /tmp/android-sdk.zip -d /usr/lib/android/sdk && \
    rm /tmp/android-sdk.zip && \
    echo "y" | $ANDROID_HOME/tools/bin/sdkmanager "tools" "emulator" "platform-tools" "platforms;android-28" \
     "build-tools;28.0.3" "extras;android;m2repository" "extras;google;m2repository"

#Create emulator
RUN .$ANDROID_HOME/tools/bin/sdkmanager "system-images;android-25;google_apis;x86"
RUN echo no | .$ANDROID_HOME/tools/bin/avdmanager create avd -n test_emulator -k "system-images;android-25;google_apis;x86"

VOLUME ["/app"]

#Set arguments for new project creation
ENV project_name default_project
ENV project_type vue

WORKDIR /app

CMD tns device;\
    tns create $project_name --$project_type;\
    chown -R nativescript:nativescript $project_name;\
    cd $project_name;\
    tail -f /dev/null;
