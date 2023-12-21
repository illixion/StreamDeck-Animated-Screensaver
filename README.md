# Stream Deck Animated Screensaver

This project allows you to create an animated wallpaper that you can set up on your Elgato Stream Deck as a preset, and switch to it using a button. This is the same as the paid screensavers that you can get on the Elgato marketplace, but you can use your own videos with this project.

Any video format that ffmpeg understands is supported.

Please note that pressing any buttons while the screensaver is active will automatically switch to the next preset, so you'll want to ensure that the screensaver is last in the preset list. If this isn't desired, advanced users can also modify the `ProfileUUID` values in `template/91EBCF7F-C727-43EF-BE2F-58EE5B617867.sdProfile/Profiles/CS3KF237953I337M0QTB32DD3KZ/manifest.json` to use the UUID of your preferred preset, which you can find by exporting a preset that contains a "Switch Profile" button with your desired preset. The presets that the Elgato app saves are just ZIP archives with JSON files inside.

## Usage

### Linux/macOS

Install Homebrew, then run these commands:

```sh
brew install ffmpeg 7z git
git clone https://github.com/illixion/StreamDeck-Animated-Screensaver.git
cd StreamDeck-Animated-Screensaver
./elgatoscreensaver.sh /path/to/video.mp4
```

### Windows

Set up WSL and install Ubuntu from the Windows Store, then once it's set up, run these commands:

```sh
sudo apt update
sudo apt install ffmpeg p7zip-full git
git clone https://github.com/illixion/StreamDeck-Animated-Screensaver.git
cd StreamDeck-Animated-Screensaver
./elgatoscreensaver.sh /mnt/c/Users/User/Desktop/video.mp4
```

The resulting preset file will be saved in the same folder as the script, which you can then open using the Elgato Stream Deck software, and assign a "Switch Profile" action to switch to the screensaver.

## Licensing

This project is licensed under [Affero GPL](https://github.com/illixion/StreamDeck-Animated-Screensaver/blob/main/LICENSE.txt). We also offer to provide this software under an MIT license upon request.
