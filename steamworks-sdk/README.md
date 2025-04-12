## Where are the files?

Even if copies of the SDK can be found all over GitHub, it's technically not allowed to "redistribute" any source files according to Valve's license agreement.

## How to "install"

Just drop the content of the `sdk/` folder here. Only the `public/steam/` and `redistributable_bin/` subfolders are required.

## Known issues

### Patch SONAME

To "ship" the `libsdkencryptedappticket.so` shared library alongside a Linux server binary. This only needs to be done once after a SDK udpate.

```sh
cd $(dico-ext)/steamworks-sdk/public/steam/lib/linux64/
patchelf --set-soname libsdkencryptedappticket.so libsdkencryptedappticket.so
```
