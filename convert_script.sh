set -e

# Standalone game variables
GAME_FOLDER=$(pwd)/your_game
GAME_APK_NAME=com.your.game
GAME_NAME='Your game'
GAME_BUG_REPORT_EMAIL=email_of_game@mail.com
GAME_SITE='http://example.com/'
GAME_VERSION_CODE=100
GAME_VERSION_NAME=1.0.0
GAME_METADATA=$(pwd)/metadata
GAME_ICON_PATH=$GAME_METADATA/en-US/images/icon.png
GAME_ICON_PROMOGRAPHIC=$GAME_METADATA/en-US/images/promoGraphic.png
##############################

EASYRPG_BUILD_ANDROID=$(pwd)/buildscripts/android
EASYRPG_PLAYER_FOLDER=$EASYRPG_BUILD_ANDROID/Player
ANDROID_FOLDER=$EASYRPG_PLAYER_FOLDER/builds/android
#GAME_APK_FOLDER_NAME=$(echo "$GAME_APK_NAME" | sed 's/\./\//g')
GAME_APK_FOLDER_NAME="org/easyrpg/player"
GAME_APK_NATIVE=$(echo "$GAME_APK_NAME" | sed 's/\./_/g')

cd $EASYRPG_PLAYER_FOLDER

# Ignore game folder on commit
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
#if [ ! -d java/$GAME_APK_FOLDER_NAME ]; then
#  mkdir -p java/$GAME_APK_FOLDER_NAME
#  git mv java/org/easyrpg/player/* java/$GAME_APK_FOLDER_NAME
#fi

cd ..

# Change jni filenames
#if [ ! -f 'gamebrowser/'$GAME_APK_NATIVE'_game_browser_GameScanner.cpp' ]; then
  #git mv 'gamebrowser/org_easyrpg_player_game_browser_GameScanner.cpp' 'gamebrowser/'$GAME_APK_NATIVE'_game_browser_GameScanner.cpp'
  #git mv 'gamebrowser/org_easyrpg_player_game_browser_GameScanner.h' 'gamebrowser/'$GAME_APK_NATIVE'_game_browser_GameScanner.h'
  #git mv 'src/org_easyrpg_player_player_EasyRpgPlayerActivity.cpp' 'jni/src/'$GAME_APK_NATIVE'_player_EasyRpgPlayerActivity.cpp'
  #git mv 'jni/src/org_easyrpg_player_player_EasyRpgPlayerActivity.h' 'jni/src/'$GAME_APK_NATIVE'_player_EasyRpgPlayerActivity.h'
#fi

# Change jni references
#find . -type f -name "*.cpp" -exec sed -i "s|org_easyrpg_player|$GAME_APK_NATIVE|g" {} \;
#find . -type f -name "*.h" -exec sed -i "s|org_easyrpg_player|$GAME_APK_NATIVE|g" {} \;
#find . -type f -name "*.mk" -exec sed -i "s|org_easyrpg_player|$GAME_APK_NATIVE|g" {} \;
#find . -type f -name "CMakeLists.txt" -exec sed -i "s|org_easyrpg_player|$GAME_APK_NATIVE|g" {} \;

cd main

# Change APK name
#find . -type f -name "*.java" -exec sed -i "s|org\.easyrpg\.player|$GAME_APK_NAME|g" {} \;
#find . -type f -name "*.xml" -exec sed -i "s|org\.easyrpg\.player|$GAME_APK_NAME|g" {} \;
#sed -i "s|org\.easyrpg\.player|$GAME_APK_NAME|g" $ANDROID_FOLDER/app/build.gradle
#sed -i "s|org\.easyrpg\.player|$GAME_APK_NAME|g" $ANDROID_FOLDER/fastlane/Appfile
#sed -i "s|org\.easyrpg\.player|$GAME_APK_NAME|g" AndroidManifest.xml

# Change game name
sed -i "s|EasyRPG Player|$GAME_NAME|g" res/values/strings.xml

# Change game email
sed -i "s|easyrpg@easyrpg\.org|$GAME_BUG_REPORT_EMAIL|g" java/$GAME_APK_FOLDER_NAME/player/EasyRpgPlayerActivity.java

# Change game site
sed -i "s|https://easyrpg\.org/|$GAME_SITE|g" res/layout/browser_nav_header.xml

# Change version code
sed -i 's/android\:versionCode="[0-9]\+"/android:versionCode="'$GAME_VERSION_CODE'"/g' AndroidManifest.xml

# Change version name
sed -i 's/android\:versionName="[0-9A-Za-z\-\.]\+"/android:versionName="'$GAME_VERSION_NAME'"/g' AndroidManifest.xml

# Convert icon to HDPI: 72x72
convert $GAME_ICON_PATH -resize 72x72 res/drawable-hdpi/ic_launcher.png

# Convert icon to MDPI: 48x48
convert $GAME_ICON_PATH -resize 48x48 res/drawable-mdpi/ic_launcher.png

# Convert icon to XHDPI: 96x96
convert $GAME_ICON_PATH -resize 96x96 res/drawable-xhdpi/ic_launcher.png

# Convert icon to XXHPDI: 144x144
convert $GAME_ICON_PATH -resize 144x144 res/drawable-xxhdpi/ic_launcher.png

# Convert icon to XXXHDPI: 192x192
convert $GAME_ICON_PATH -resize 192x192 res/drawable-xxxhdpi/ic_launcher.png

# Convert icon to promoGraphic.png: 180x120
convert $GAME_ICON_PATH -resize 120x120 $GAME_ICON_PROMOGRAPHIC
convert $GAME_ICON_PROMOGRAPHIC -resize 180x120 -size 180x120 xc:none +swap -gravity center -composite $GAME_ICON_PROMOGRAPHIC

# Change metadata
rm -r $ANDROID_FOLDER/metadata
cp -r $GAME_METADATA $ANDROID_FOLDER/metadata
