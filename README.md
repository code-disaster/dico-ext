# dico-ext

This is just an aggregation of third-party C/C++ dependencies, accompanied by some small CMake utility scripts.

You can see this as a list of _"most favorite open-source libraries"_, with most of the libraries I'm using for my own private projects and experiments. I use this repository, as a submodule, to pull everything in at once.

About the dependencies that make this list:

- Most of them are about doing one thing well, and one thing only. I try to avoid large jack-of-all-trades libraries.
- Most of them are hosted on GitHub and included as submodules, tagged to a recent version. I usually update to release tags, if available.
- Most of them are either single-header libraries, or can be compiled without much hassle from your own favorite build tool.
- For licensing information, please refer to the respective dependency. They all should use a permissive license (MIT, zlib, BSD 2/3 or similar).

Notable exceptions about what I just wrote:

- Some libraries like SDL3 and freetype aren't easy to build "by hand" from source. But their CMake build scripts are pretty good. All I do for Windows, Linux and macOS builds is to call e.g. `add_subdirectory(${DICO_EXT_DIR}/SDL ${CMAKE_BINARY_DIR}/ext/SDL EXCLUDE_FROM_ALL)`.
- The Steamworks SDK isn't open-source. See remarks in `steamworks-sdk/README.md`.
