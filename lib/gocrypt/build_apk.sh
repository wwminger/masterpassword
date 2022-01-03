export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/23.0.7599858

export GOARCH=arm
export GOOS=android
export CGO_ENABLED=1
export CC=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/armv7a-linux-androideabi21-clang
go build -buildmode=c-shared -o output/android/armeabi-v7a/libspectre.so .

echo "Build armeabi-v7a success"

export GOARCH=arm64
export GOOS=android
export CGO_ENABLED=1
export CC=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android21-clang
go build -buildmode=c-shared -o output/android/arm64-v8a/libspectre.so .

echo "Build arm64-v8a success"
