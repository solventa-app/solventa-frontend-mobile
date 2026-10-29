# Imagen única de desarrollo y CI: la misma en todas las máquinas (Windows, Mac, Linux) y en GitHub Actions.
# Ver docs/entorno-local.md. Para subir de Flutter: cambiar FLUTTER_VERSION y FLUTTER_SHA256 (de
# releases_linux.json), `environment.flutter` en pubspec.yaml y regenerar goldens, en un PR propio.
#
# Siempre amd64 (lo fija devcontainer.json): el Android SDK no publica binarios para Linux ARM. En Mac con chip M corre con Rosetta.
FROM ubuntu:24.04@sha256:68ee22004a9109b44973313b02ff7b1de250f1de0f5ecb628d73f579aaff33ac

ARG FLUTTER_VERSION=3.47.8
ARG FLUTTER_SHA256=baf7dcc5a3dbba60fe863bf493a6cf203195621f7786eaa5a1bba02cd0d87dd2
# Lo que pide Flutter 3.47.8 (compileSdk, ndkVersion de flutter.* en android/app/build.gradle.kts).
ARG ANDROID_PLATFORM=android-36
ARG ANDROID_BUILD_TOOLS=36.0.0
ARG ANDROID_NDK=28.2.13676358
ARG ANDROID_CMDLINE_TOOLS=13114758
ARG LEFTHOOK_VERSION=2.2.2

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 \
    ANDROID_HOME=/opt/android-sdk \
    ANDROID_SDK_ROOT=/opt/android-sdk \
    FLUTTER_ROOT=/opt/flutter \
    PUB_CACHE=/home/dev/.pub-cache
ENV PATH=/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:/home/dev/.pub-cache/bin:$PATH

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates curl git unzip xz-utils zip less openssh-client sudo \
      openjdk-17-jdk-headless libglu1-mesa \
 && rm -rf /var/lib/apt/lists/*

# Usuario sin privilegios. La imagen base trae `ubuntu` (uid 1000): se reemplaza por `dev` con el mismo uid.
# El devcontainer ajusta el uid al de tu usuario en Linux para que los archivos del repo no queden de root.
RUN userdel -r ubuntu 2>/dev/null || true \
 && useradd -m -u 1000 -s /bin/bash dev \
 && echo 'dev ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/dev \
 && mkdir -p /opt/flutter /opt/android-sdk \
 && chown dev:dev /opt/flutter /opt/android-sdk \
 && git config --system --add safe.directory '*'

RUN curl -fsSL -o /usr/local/bin/lefthook \
      "https://github.com/evilmartians/lefthook/releases/download/v${LEFTHOOK_VERSION}/lefthook_${LEFTHOOK_VERSION}_Linux_x86_64" \
 && chmod +x /usr/local/bin/lefthook

USER dev

# /opt/android-sdk y /opt/flutter quedan escribibles para todos: en Linux y en CI el devcontainer cambia el uid
# de `dev` al del host, y Flutter y Gradle escriben en sus cachés.

# Android SDK: solo línea de comandos, sin Android Studio ni emulador (el emulador corre en tu máquina).
RUN curl -fsSL -o /tmp/cmdline-tools.zip \
      "https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMDLINE_TOOLS}_latest.zip" \
 && unzip -q /tmp/cmdline-tools.zip -d /tmp/cmdline-tools \
 && mkdir -p /opt/android-sdk/cmdline-tools \
 && mv /tmp/cmdline-tools/cmdline-tools /opt/android-sdk/cmdline-tools/latest \
 && rm -rf /tmp/cmdline-tools /tmp/cmdline-tools.zip \
 && yes | sdkmanager --licenses > /dev/null \
 && sdkmanager --install \
      "platform-tools" \
      "platforms;${ANDROID_PLATFORM}" \
      "build-tools;${ANDROID_BUILD_TOOLS}" \
      "ndk;${ANDROID_NDK}" > /dev/null \
 && chmod -R a+rwX /opt/android-sdk

# Flutter fijo, verificado con el sha256 publicado por Google.
RUN curl -fsSL -o /tmp/flutter.tar.xz \
      "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
 && echo "${FLUTTER_SHA256}  /tmp/flutter.tar.xz" | sha256sum -c - \
 && tar -xJf /tmp/flutter.tar.xz -C /opt \
 && rm /tmp/flutter.tar.xz \
 && flutter config --no-analytics --no-cli-animations --android-sdk /opt/android-sdk \
 && dart --disable-analytics \
 && flutter precache --android --no-ios --no-web --no-linux --no-windows --no-macos --no-fuchsia \
 && yes | flutter doctor --android-licenses > /dev/null \
 && flutter --version \
 && chmod -R a+rwX /opt/flutter

# Cachés que el devcontainer monta como volúmenes (se conservan al reconstruir el contenedor).
RUN mkdir -p /home/dev/.gradle /home/dev/.pub-cache

WORKDIR /workspaces
