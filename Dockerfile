# Each instruction in this file generates a new layer that gets pushed to your local image cache

# Lines preceeded by # are regarded as comments and ignored

# The line below states we will base our new image on the Latest Official Ubuntu
FROM ubuntu:latest

# Identify the maintainer of an image
LABEL maintainer="vicente.mataix@polytechnique.edu"

ENV DEBIAN_FRONTEND=noninteractive
ENV LD_LIBRARY_PATH=:/usr/lib/x86_64-linux-gnu:/home/Kratos/src/Kratos/bin/Release/lib/:/builds/Kratos/Kratos/bin/Release/lib/:
RUN apt-get -y clean
RUN apt-get -y update && apt-get -y upgrade -y && apt-get -y install --no-install-recommends \
    nano                  \
    bash                  \
    wget                  \
    curl                  \
    zip                   \
    unzip                 \
    ssh                   \
    git                   \
    build-essential       \
    clang                 \
    gfortran              \
    cmake                 \
    python3               \
    python3-pip           \
    python3-dev           \
    libboost-all-dev   && \
    apt-get autoremove -y
RUN apt-get -y clean
RUN rm -rf /var/lib/apt/lists/*

# Installing code server
ENV DEBIAN_FRONTEND=noninteractive
RUN curl -fsSL https://code-server.dev/install.sh | sh
RUN apt-get -y clean
RUN rm -rf /var/lib/apt/lists/*

# Creation of a "non-root" user
ENV USER "Kratos"
RUN useradd --create-home ${USER}
USER ${USER}

# Installing in the current user the python libraries
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install numpy

# Default working directory is
RUN mkdir /home/${USER}/src
WORKDIR /home/${USER}/src

# Clone Kratos
RUN git clone https://github.com/KratosMultiphysics/Kratos Kratos --single-branch

# Create build directory
WORKDIR /home/${USER}/src/Kratos
RUN mkdir build

# Compile with GCC
RUN export KRATOS_CMAKE_CXX_FLAGS="-Wignored-qualifiers"
RUN echo "export CC=/usr/bin/gcc\nexport CXX=/usr/bin/g++\nexport KRATOS_BUILD_TYPE=\"Release\"\nexport KRATOS_APPLICATIONS=\"${PWD}/applications/LinearSolversApplication;${PWD}/applications/StructuralMechanicsApplication;${PWD}/applications/ContactStructuralMechanicsApplication;${PWD}/applications/ConstitutiveLawsApplication;\"\nexport PYTHON_EXECUTABLE=\"/usr/bin/python3.8\"\nexport KRATOS_INSTALL_PYTHON_USING_LINKS=ON\n\n# Clean\nclear\nrm -rf \"${PWD}/build/${KRATOS_BUILD_TYPE}/cmake_install.cmake\"\nrm -rf \"${PWD}/build/${KRATOS_BUILD_TYPE}/CMakeCache.txt\"\nrm -rf \"${PWD}/build/${KRATOS_BUILD_TYPE}/CMakeFiles\"\n# Configure\ncmake  --no-warn-unused-cli .. -H\"${PWD}\" -B\"${PWD}/build/${KRATOS_BUILD_TYPE}\" -DCMAKE_CXX_FLAGS=${KRATOS_CMAKE_OPTIONS_FLAGS} -DPYBIND11_PYTHON_VERSION=\"3.8\" -DCMAKE_CXX_FLAGS=\"${KRATOS_CMAKE_CXX_FLAGS} -O0 -Wall\" -DCMAKE_UNITY_BUILD=ON \\n\n# Buid\ncmake --build \"${PWD}/build/${KRATOS_BUILD_TYPE}\" --target install -- -j$(nproc)" > build/configure.sh

# Compile with clang (just prepare)
RUN export KRATOS_CMAKE_CXX_FLAGS="-Wignored-qualifiers"
RUN echo "export CC=/usr/bin/clang\nexport CXX=/usr/bin/clang++\nexport KRATOS_BUILD_TYPE=\"Release\"\nexport KRATOS_APPLICATIONS=\"${PWD}/applications/LinearSolversApplication;${PWD}/applications/StructuralMechanicsApplication;${PWD}/applications/ContactStructuralMechanicsApplication;${PWD}/applications/ConstitutiveLawsApplication;\"\nexport PYTHON_EXECUTABLE=\"/usr/bin/python3.8\"\nexport KRATOS_INSTALL_PYTHON_USING_LINKS=ON\n\n# Clean\nclear\nrm -rf \"${PWD}/build/${KRATOS_BUILD_TYPE}/cmake_install.cmake\"\nrm -rf \"${PWD}/build/${KRATOS_BUILD_TYPE}/CMakeCache.txt\"\nrm -rf \"${PWD}/build/${KRATOS_BUILD_TYPE}/CMakeFiles\"\n# Configure\ncmake  --no-warn-unused-cli .. -H\"${PWD}\" -B\"${PWD}/build/${KRATOS_BUILD_TYPE}\" -DCMAKE_CXX_FLAGS=${KRATOS_CMAKE_OPTIONS_FLAGS} -DPYBIND11_PYTHON_VERSION=\"3.8\" -DCMAKE_CXX_FLAGS=\"${KRATOS_CMAKE_CXX_FLAGS} -O0 -Wall\" -DCMAKE_UNITY_BUILD=ON \\n\n# Buid\ncmake --build \"${PWD}/build/${KRATOS_BUILD_TYPE}\" --target install -- -j$(nproc)" > build/configure_clang.sh

# Compile
WORKDIR /home/${USER}/src/Kratos/build
RUN sh configure.sh

# Add to the bashrc the LD_LIBRARY_PATH
RUN echo "export LD_LIBRARY_PATH=:/usr/lib/x86_64-linux-gnu:/home/Kratos/src/Kratos/bin/Release/lib/:/builds/Kratos/Kratos/bin/Release/lib/:" >> ~/.bashrc
RUN echo "export PYTHONPATH=$PYTHONPATH:/home/Kratos/src/Kratos/bin/Release/:" >> ~/.bashrc
RUN echo "alias python=\"python3\"" >> ~/.bashrc

# Launch code server
CMD ["code-server","--auth=none"]
