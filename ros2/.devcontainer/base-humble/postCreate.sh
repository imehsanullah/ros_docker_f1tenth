#!/bin/bash
cd ws
mkdir -p src

cd src
git clone https://github.com/imehsanullah/f1tenth_ws.git

sudo rosdep update
sudo rosdep install --from-paths /home/$(whoami)/ws/src --ignore-src -y
sudo chown -R $(whoami) /home/$(whoami)/ws/
sudo apt install ros-humble-asio-cmake-module
colcon build #--cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
