#!/bin/env bash
set -e
# tools_version=26.0.1
BUILD_TOOLS_VERSION=current
BUILD_TOOLS=$ANDROID_SDK/build-tools/$BUILD_TOOLS_VERSION
ANDROID_JAR=$ANDROID_SDK/platforms/android-33/android.jar
# androidx=~/.gradle/caches/transforms-3/27d576167a170fa332f195a5e220334e/transformed/appcompat-1.6.1-api.jar
jar=obj:$ANDROID_JAR:$androidx
res=app/src/main/res
src=app/src/main/java
manifest=app/src/main/AndroidManifest.xml
# $BUILD_TOOLS/aapt package -f -m -S $res -J $src -M $manifest -I $ANDROID_JAR
$BUILD_TOOLS/aapt package -f -m -J $src -M $manifest -I $ANDROID_JAR
# javac -d ./obj -source 1.7 -target 1.7 -bootclasspath $JAVA_HOME/jre/lib/rt.jar -classpath $ANDROID_JAR:obj -sourcepath src src/org/linaro/glmark2/*.java
find app/src -name "*.java" | xargs javac -Xmaxerrs 1 -d ./obj -source 1.7 -target 1.7 -bootclasspath $JAVA_HOME/jre/lib/rt.jar -classpath $jar -sourcepath
# javac -Xmaxerrs 1 -d ./obj -classpath $jar  -sourcepath $src $src/open/app/*.java
# $BUILD_TOOLS/dx --dex --output=bin/classes.dex ./obj
# $BUILD_TOOLS/aapt package -f -M $manifest -S $res -I $ANDROID_JAR -F unaligned.apk bin
$BUILD_TOOLS/aapt package -f -M $manifest -I $ANDROID_JAR -F unaligned.apk bin
# rm app/src/main/java/open/app/R.java
CLASSPATH=unaligned.apk app_process -Xnoimage-dex2oat / open.app -help
