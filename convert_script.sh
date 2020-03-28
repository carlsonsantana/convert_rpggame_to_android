set -e

# Standalone game variables
GAME_FOLDER=$(pwd)/your_game
GAME_APK_NAME=com.your.game
GAME_NAME='Your game'
##############################

EASYRPG_PLAYER_FOLDER=$(pwd)/buildscripts/android/Player
ANDROID_FOLDER=$EASYRPG_PLAYER_FOLDER/builds/android
GAME_APK_FOLDER_NAME=$(echo "$GAME_APK_NAME" | sed 's/\./\//g')
GAME_APK_NATIVE=$(echo "$GAME_APK_NAME" | sed 's/\./_/g')

cd $EASYRPG_PLAYER_FOLDER

sed -i ':a;N;$!ba;s|\n\n# Game folder||g' .gitignore
sed -i ':a;N;$!ba;s|\n/builds/android/app/src/main/assets/||g' .gitignore
echo "" >> .gitignore
echo "# Game folder" >> .gitignore
echo "/builds/android/app/src/main/assets/" >> .gitignore

cd builds/android/app/src/main

# Copy game
rm -fr assets/game
cp -r $GAME_FOLDER assets/game

# Change java packages
if [ ! -d java/$GAME_APK_FOLDER_NAME ]; then
  mkdir -p java/$GAME_APK_FOLDER_NAME
  git mv java/org/easyrpg/player/* java/$GAME_APK_FOLDER_NAME
fi

# Change jni filenames
if [ ! -f 'jni/gamebrowser/'$GAME_APK_NATIVE'_game_browser_GameScanner.cpp' ]; then
  git mv 'jni/gamebrowser/org_easyrpg_player_game_browser_GameScanner.cpp' 'jni/gamebrowser/'$GAME_APK_NATIVE'_game_browser_GameScanner.cpp'
  git mv 'jni/gamebrowser/org_easyrpg_player_game_browser_GameScanner.h' 'jni/gamebrowser/'$GAME_APK_NATIVE'_game_browser_GameScanner.h'
  git mv 'jni/src/org_easyrpg_player_player_EasyRpgPlayerActivity.cpp' 'jni/src/'$GAME_APK_NATIVE'_player_EasyRpgPlayerActivity.cpp'
  git mv 'jni/src/org_easyrpg_player_player_EasyRpgPlayerActivity.h' 'jni/src/'$GAME_APK_NATIVE'_player_EasyRpgPlayerActivity.h'
fi

# Change APK name
find . -type f -name "*.java" -exec sed -i "s|org\.easyrpg\.player|$GAME_APK_NAME|g" {} \;
find . -type f -name "*.xml" -exec sed -i "s|org\.easyrpg\.player|$GAME_APK_NAME|g" {} \;
sed -i "s|org\.easyrpg\.player|$GAME_APK_NAME|g" $ANDROID_FOLDER/app/build.gradle
sed -i "s|org\.easyrpg\.player|$GAME_APK_NAME|g" $ANDROID_FOLDER/fastlane/Appfile
sed -i "s|org\.easyrpg\.player|$GAME_APK_NAME|g" AndroidManifest.xml

# Change jni references
find . -type f -name "*.cpp" -exec sed -i "s|org_easyrpg_player|$GAME_APK_NATIVE|g" {} \;
find . -type f -name "*.h" -exec sed -i "s|org_easyrpg_player|$GAME_APK_NATIVE|g" {} \;
find . -type f -name "*.mk" -exec sed -i "s|org_easyrpg_player|$GAME_APK_NATIVE|g" {} \;

# Change game name
sed -i "s/EasyRPG Player/$GAME_NAME/g" res/values/strings.xml
