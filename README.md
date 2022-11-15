# RPG Maker 2kx to Android

Convert a RPG Maker 2000 or RPG Maker 2003 in a Android game app using [EasyRPG Player](https://github.com/EasyRPG/Player) and [it build scripts](https://github.com/EasyRPG/buildscripts).

## Advice

Because [EasyRPG is under GPL3 license](https://github.com/EasyRPG/Player/blob/master/COPYING), you must publish a copy of modified [EasyRPG Player](https://github.com/EasyRPG/Player) on GPL3 license.

## Dependencies

* git;
* java;
* wget;
* gradle;
* imagemagick;
* autoconf;
* automake;
* libtool;
* cmake;
* curl;
* make;
* perl;
* patch;
* pkg-config.

## Build game app

1. Clone the build scripts repository of EasyRPG;
```sh
git clone https://github.com/EasyRPG/buildscripts.git
```
2. Set environment variables on terminal;
```sh
export BUILD_LIBLCF=1
export ANDROID_SDK_ROOT=$(pwd)/buildscripts/android/android-sdk
```
3. Run the script `0_build_everything.sh`;
```sh
cd buildscripts/android
./0_build_everything.sh
```
4. While the script `0_build_everything.sh` is running, create a keystore (**do not lose or share the `game_certificate.key` file**);
```sh
keytool -genkey -v -keystore game_certificate.key -alias game_cert -keyalg RSA -keysize 4096 -validity 10000
```
5. Change the variables of `convert_script.sh`;
6. Fork the [EasyRPG Player](https://github.com/EasyRPG/Player) repository (see [Advice](#advice));
7. After script `0_build_everything.sh` ended successfully, edit the variables in `4_build_android_port.sh` to set your keystore path (made in step 3) and password;
- Set ``KEYSTORE_PATH`` to ``$(pwd)/game_certificate.key``
- Set ``KEYSTORE_PASSWORD`` to the password you entered when creating the key
- Set ``KEYSTORE_NAME`` to ``game_cert`` (the alias)
8. Change the remote origin of Player repository and set your forked repo as origin;
```sh
cd buildscripts/android/Player
git remote remove origin
git remote add origin https://github.com/myaccount/Player
```
9. Run the script `convert_script.sh`;
```sh
./convert_script.sh
```
10. Run the scripts `4_build_android_port.sh`;
```sh
cd buildscripts/android
./4_build_android_port.sh
```
11. Commit and push it;
```sh
cd buildscripts/android/Player
git add .
git commit -m "Commit message"
git push -u origin master
```
12. Publish your game on Google Play.
