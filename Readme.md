# Signpost Demo Applications

This repository contains demo applications for measuring
goodput, latency and jitter between two hosts for a demo
of Signpost.

For more information about signpost, please visit http://www.signpost.io


# Components

The demo (as it stands) has 3 components, the android measurement application, the OCaml measurement server and the Web interface

# Android Application

The code in /SigcommDemoAndroid can be compiled into a .adk file as follows, (before hand you need to add /platform-tools and /tools to PATH)

$ cd SigcommDemoAndroid
$ ant debug
$ adb install bin/IntroView-debug.apk

The android application depends on http://code.google.com/p/google-gson/downloads. This can be added to /lib after generating build.xml


