## CuraEngine

Docker container for building the latest curaengine from source. The CuraEngine is a C++ console application for 3D printing GCode generation.

## Dependencies
 
 For important parts that can be used for other purposes, the build is split accros multiple parts. All images are based on the Alpine distro.
 * 1/3 - Protobuf;
 * 2/3 - libArcus;
 * 3/3 - curaengine;
