# Use ROS2 Jazzy as base image
FROM osrf/ros:jazzy-desktop-full

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=jazzy
ENV ROS_DOMAIN_ID=11

# Install additional development tools, check if further tools are needed
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-setuptools \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-vcstool \
    python3-pytest \
    python3-pytest-cov \
    python3-flake8 \
    git \
    vim \
    nano \
    wget \
    curl \
    build-essential \
    cmake \
    gdb \
    clang-format \
    clang-tidy \
    cppcheck \
    && rm -rf /var/lib/apt/lists/*

RUN apt update && apt install -y \
    ros-$ROS_DISTRO-foxglove-bridge

# Initialize rosdep
RUN rosdep update

# Create workspace directory
RUN mkdir -p /workspace/ros2_ws/src
WORKDIR /workspace/ros2_ws

# Source ROS2 setup in bashrc
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
RUN echo "if [ -f /workspace/ros2_ws/install/setup.bash ]; then source /workspace/ros2_ws/install/setup.bash; fi" >> ~/.bashrc

# Set up colcon defaults
RUN mkdir -p ~/.colcon && \
    echo "{\n  \"build\": {\n    \"symlink-install\": true\n  }\n}" > ~/.colcon/defaults.yaml

# Create entrypoint script
RUN echo '#!/bin/bash\n\
    set -e\n\
    \n\
    # Source ROS2\n\
    source /opt/ros/${ROS_DISTRO}/setup.bash\n\
    \n\
    # Source workspace if it exists\n\
    if [ -f /workspace/ros2_ws/install/setup.bash ]; then\n\
    source /workspace/ros2_ws/install/setup.bash\n\
    fi\n\
    \n\
    exec "$@"' > /entrypoint.sh && \
    chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
