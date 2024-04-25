#!/bin/bash
#rm -Rf ./FooBar/build
#rm -Rf ./FooBarUser/build
rm ./FooBar/build/CMakeCache.txt
rm ./FooBarUser/build/CMakeCache.txt
cmake -B./FooBar/build -H./FooBar -DBUILD_SHARED_LIBS=ON
cmake --build ./FooBar/build

cmake -B./FooBarUser/build -H./FooBarUser -DBUILD_SHARED_LIBS=ON
cmake --build ./FooBarUser/build
