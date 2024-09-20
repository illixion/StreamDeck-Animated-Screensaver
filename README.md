# Stream Deck Animated Screensaver

This project allows you to create an animated wallpaper that you can set up on your Elgato Stream Deck as a preset, and switch to it using a button. This is the same as the screensavers that you can get on the [Elgato Marketplace](https://marketplace.elgato.com/stream-deck/screensavers), but you can use your own videos with this project.

Any video format that ffmpeg understands is supported.

## How this works

This script generates a fully compatible Stream Deck preset file where each key is a "Switch Preset" action that's set to switch to the next preset, and each key's icon is an animated `.webp` file that's taken from the source video. `.webp` is used as that's what the Elgato app converts `.gif` files to, meaning we can achieve a much higher quality for the resulting video and remove unnecessary conversions.

**Please note** that pressing any buttons while the screensaver is active will automatically switch to the next preset, so you'll want to ensure that the screensaver is last in the preset list.

If this isn't desired, you can manually change which preset is used for each key in the Stream Deck app. Advanced users can also modify all `ProfileUUID` values in `template/91EBCF7F-C727-43EF-BE2F-58EE5B617867.sdProfile/Profiles/CS3KF237953I337M0QTB32DD3KZ/manifest.json` to contain the ProfileUUID of your preferred preset, which you can find by exporting a preset that contains a "Switch Profile" button with your desired preset. The presets that the Elgato app saves are just ZIP archives with JSON files inside.

## Usage

### Windows (and Linux)

[Set up WSL and install Ubuntu from the Windows Store](https://ubuntu.com/tutorials/install-ubuntu-on-wsl2-on-windows-11-with-gui-support#1-overview), then once that's done, run these commands:

```sh
sudo apt update
sudo apt install --no-install-recommends wslu
sudo apt install ffmpeg p7zip-full git
git clone https://github.com/illixion/StreamDeck-Animated-Screensaver.git
cd StreamDeck-Animated-Screensaver

# Put the video on your desktop and change video.mp4 to the correct file name
./elgatoscreensaver.sh "$(wslpath "$(wslvar USERPROFILE)")/Desktop/video.mp4"

# To move the resulting file back to your Desktop:
mv *.streamDeckProfile $(wslpath "$(wslvar USERPROFILE)")/Desktop/
```

If you want to generate a screensaver for un Stream Deck XL add XL at the end of the cli:
```sh
./elgatoscreensaver.sh "$(wslpath "$(wslvar USERPROFILE)")/Desktop/video.mp4" XL
```

### macOS

Install [Homebrew](https://brew.sh), then run these commands:

```sh
brew install ffmpeg 7z git
git clone https://github.com/illixion/StreamDeck-Animated-Screensaver.git
cd StreamDeck-Animated-Screensaver

./elgatoscreensaver.sh /path/to/video.mp4

# You can also drag the file into the terminal window to paste the path

# To open the resulting file:
open *.streamDeckProfile
```

The resulting preset file will be saved in the **same folder as the script**, which you can then open using the Elgato Stream Deck software, and assign a "Switch Profile" action to switch to the preset containing the screensaver.

## Licensing

This project is licensed under [Affero GPL](https://github.com/illixion/StreamDeck-Animated-Screensaver/blob/main/LICENSE.txt). We also offer to provide this software under an MIT license upon request.
