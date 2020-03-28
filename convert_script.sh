set -e

# Standalone game variables
GAME_FOLDER=$(pwd)/your_game
##############################

EASYRPG_PLAYER_FOLDER=$(pwd)/buildscripts/android/Player

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
