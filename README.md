# Scratch 2.0 editor and player [![Build Status](https://api.travis-ci.org/LLK/scratch-flash.svg?branch=master)](https://travis-ci.org/LLK/scratch-flash)

## Note

**Scratch 2.0 is now in maintenance mode while the team focuses efforts on [Scratch
3.0](https://scratch.mit.edu/developers). While critical issues will be addressed please note that any feature
requests or minor issues will not be reviewed until the next major release.**

## Overview

This is the open source version of Scratch 2.0 and the core code for the official version found on
<http://scratch.mit.edu>. This code has been released under the GPL version 2 license. Forks can be released under the
GPL v2 or any later version of the GPL.

If you're interested in contributing to Scratch, please take a look at the issues on this repository. Two great ways
of helping Scratch are by identifying bugs and documenting them as issues, or fixing issues and creating pull
requests. When submitting pull requests please be patient -- the Scratch Team is very busy and it can take a while to
find time to review them. The organization and class structures can't be radically changed without significant
coordination and collaboration from the Scratch Team, so these types of changes should be avoided.

It's been said that the Scratch Team spends about one hour of design discussion for every pixel in Scratch, but some
think that estimate is a little low. While we welcome suggestions for new features in our [suggestions
forum](http://scratch.mit.edu/discuss/1/) (especially ones that come with mockups), we are unlikely to accept PRs with
new features that we haven't deeply thought through. Why? Because we have a strong belief in the value of keeping
things simple for new users. To learn more about our design philosophy, see [this forum
post](http://scratch.mit.edu/discuss/post/1576/) or [this
paper](http://web.media.mit.edu/~jmaloney/papers/ScratchLangAndEnvironment.pdf).

## Quick Start: Building and Debugging with Visual Studio Code

1. Build at least once using the Gradle instructions listed in the "Building" instructions below.
   * TL;DR: run `./gradlew build -Ptarget="11.6"` in a terminal (on Windows, replace `/` with `\` as usual).
   * This will download and unpack the necessary SDKs.
   * You may need to agree to a few licenses (press `y` then `enter`).
   * It may take quite a while and appear to hang at times. Watch disk and network activity to be sure.
2. Install [Visual Studio Code](https://code.visualstudio.com/).
3. Install the "ActionScript & MXML" extension (search for `@ext:as3` in the `Extensions` pane).
   * Reload VS Code when prompted.
4. Add the `scratch-flash` folder to the VS Code workspace.
5. Click "No SDK" then "Add more SDKs to this list...".
6. Browse to your home directory, then go into `.gradle`, then `gradleFx`. Choose `sdks` and close the dialog.
7. Your list of SDKs should now include something starting with "Apache Flex 4.15.0"; choose that.

You should now be able to build and debug using your usual Visual Studio Code hotkeys. The defaults are Ctrl+Shift+B
(or Cmd+Shift+B on Mac) to build and F5 to run.

Note that this will build a SWF which requires a very recent version of Flash, so the IDE build should only be used
for development and debugging. The Gradle builds (see below) are configured for compatibility with a broad range of
Flash versions.

Check `asconfig.json` for the configuration settings used by the IDE build.

## Building

The Scratch 2.0 build uses Gradle to acquire and cache the Flex SDK. The Gradle wrapper is included in this repository.
Gradle 5.6.4 supports Java 8 through 12; Java 11 is recommended for a reproducible build.

There are two versions of the Scratch 2.0 editor that can be built from this repository. See the following table to
determine the appropriate command for each version. When building on Windows, replace `./gradlew` with `.\gradlew`.

Required Flash version | Features | Command
--- | --- | ---
11.6 or above | 3D-accelerated rendering | `./gradlew build -Ptarget="11.6"`
10.2 - 11.5 | No 3D acceleration; compatible with older Flash runtimes | `./gradlew build -Ptarget="10.2"`

A successful build should look something like this (SDK download information omitted):

```sh
$ ./gradlew build -Ptarget="11.6"
Defining custom 'build' task when using the standard Gradle lifecycle plugins has been deprecated and is scheduled to be removed in Gradle 3.0
Target is: 11.6
Commit ID for scratch-flash is: e6df4f4
:copyresources
:compileFlex
WARNING: The -library-path option is being used internally by GradleFx. Alternative: specify the library as a 'merged' Gradle dependendency
:copytestresources
:test
Skipping tests since no tests exist
:build

BUILD SUCCESSFUL

Total time: 13.293 secs
```

Upon completion, you should find your new SWF in the `build` subdirectory.

```sh
$ ls -R build
build:
10.2  11.6

build/10.2:
ScratchFor10.2.swf

build/11.6:
Scratch.swf
```

Please note that the Scratch trademarks (including the Scratch name, logo, Scratch Cat, and Gobo) are property of MIT.
For use of these Marks, please see the [Scratch Trademark
Policy](http://wiki.scratch.mit.edu/wiki/Scratch_1.4_Source_Code#Scratch_Trademark_Policy).

## Ubuntu Desktop

Flash Player is end-of-life and is not available as a supported Ubuntu desktop runtime. Install Java 11 and Ruffle's
desktop application, then build the non-3D target and launch it:

```sh
sudo apt update
sudo apt install openjdk-11-jdk flatpak git
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub rs.ruffle.Ruffle
./gradlew build -Ptarget=10.2
./run-ubuntu.sh
```

The launcher uses a `ruffle` executable on `PATH` or the Ruffle Flatpak. Ruffle's ActionScript 3 support is still
incomplete, so some Scratch editor features may not work. The SWF build is verified; full desktop runtime compatibility
must be checked against the Ruffle version and Ubuntu system in use.

## Offline Media

When no remote library or asset URLs are supplied, the editor loads media from a `media/` directory next to the SWF.
This packages media alongside the SWF, not inside it. No FlashVars or local web server are needed for Ruffle desktop.

### Import From the Scratch 2 AIR Package

The build can extract the media from Scratch 2's offline-editor AIR package without installing or running Adobe AIR.
A [third-party preserved copy of Scratch-461.air](https://archive.org/download/scratch-offline-editor/Scratch-461.air)
is available on Internet Archive. This is not an official download host. The checksum below matches that archive's
published copy; it is not an independently verified publisher checksum.

On Ubuntu, download once and build:

```sh
mkdir -p build/downloads
curl --fail --location --output build/downloads/Scratch-461.air \
   https://archive.org/download/scratch-offline-editor/Scratch-461.air
echo 'fbfda62b49ea8e59f02f6757b23ee0ca5c516f63a3936bd7733bd9236117eaec  build/downloads/Scratch-461.air' | sha256sum --check
./gradlew build -Ptarget=10.2
./run-ubuntu.sh
```

Builds automatically use `build/downloads/Scratch-461.air` when it is present and `mediaDir` is not supplied. To use
an AIR archive elsewhere, pass `-PmediaArchive=/path/to/Scratch-461.air` instead. The archive is used only at build
time. Its original layout is preserved: catalogues stay in `media/libs/`, and hashed media files stay directly
in `media/` next to the SWF. AIR application code, scripts, and Git metadata are not imported. The source
archive and extracted media stay in the ignored `build/` directory. A Gradle `clean` removes them, so retain the
original archive elsewhere if needed. Review the original media's licensing and attribution before redistribution.

### Use an Existing Media Folder

Alternatively, supply a complete Scratch 2-compatible media bundle in this layout:

```text
media/
   libs/
      spriteLibrary.json
      costumeLibrary.json
      backdropLibrary.json
      soundLibrary.json
   <md5>.json
   <md5>.svg
   <md5>.png
   <md5>.wav
```

Keep the original asset filenames referenced by the library JSON and sprite JSON. The library list alone is not
enough: sprite metadata, costumes, text layers, and sounds must all be present. Downloaded media is not included in
this source repository. Obtain a compatible bundle separately and retain its license and attribution files.

An extracted Scratch 2 AIR package's `media/` folder can be used directly, without rearranging files. Place the
bundle at the repository's `media/` directory, or point the build to an existing folder:

```sh
./gradlew build -Ptarget=10.2 -PmediaDir=/path/to/media
./run-ubuntu.sh
```

The build checks referenced assets and copies the bundle to `build/10.2/media/` (or `build/11.6/media/` for that target).
Distribute that directory together with the SWF. Explicit `urlOverrides` for remote libraries/assets still take
precedence; `urlOverrides` can also set `mediaRoot` to another local directory or URL, including its trailing slash.
Do not substitute Scratch 3 library JSON: it uses a different format. Local packaging does not resolve unrelated
Ruffle rendering limitations or a missing default sprite.

## Debugging

Here are a few integrated development environments available with Flash debugging support:

* [Visual Studio Code](https://code.visualstudio.com/)
* [Intellij IDEA](http://www.jetbrains.com/idea/features/flex_ide.html)
* [Adobe Flash Builder](http://www.adobe.com/products/flash-builder.html)
* [FlashDevelop](http://www.flashdevelop.org/)
* [FDT for Eclipse](http://fdt.powerflasher.com/)

It may be difficult to configure your IDE to use Gradle's cached version of the Flex SDK. The Gradle build downloads
the required PlayerGlobal SWCs automatically. For IDE builds, use the [Flex SDK](http://flex.apache.org/) version 4.10+
and install the matching PlayerGlobal SWC under ``${FLEX_HOME}/frameworks/libs/player/${VERSION}/playerglobal.swc``.

Consult your IDE's documentation to configure it for your newly-constructed copy of the Flex SDK.

If the source is building but the resulting .swf is producing runtime errors, your first course of action should be to
download version 4.11 of the Flex SDK and try targeting that. The Apache foundation maintains an
[installer](http://flex.apache.org/installer.html) that lets you select a variety of versions.
