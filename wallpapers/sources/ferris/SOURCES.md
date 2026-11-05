Ferris original transparent PNG artwork by Karen Rustad Tölva, from https://rustacean.net/ (public domain / CC0 dedication).

`ferris-cuddly-bright.png` is an AI-edited brighter coral variant of
`ferris-cuddly-transparent.png`, used for the Noctalia launcher icon.

- https://rustacean.net/assets/rustacean-flat-noshadow.png
- https://rustacean.net/assets/rustacean-flat-noshadow.svg (`ferris-flat.svg`)
- https://rustacean.net/assets/rustacean-flat-happy.png
- https://rustacean.net/assets/cuddlyferris.png

`ferris-avatar.png` is rendered from `ferris-flat.svg` with transparent padding
for the circular Noctalia profile image. Regenerate from the repository root:

```sh
magick -background none -density 192 wallpapers/sources/ferris/ferris-flat.svg -resize 880x880 -gravity center -extent 1024x1024 wallpapers/sources/ferris/ferris-avatar.png
```

The wallpaper embeds the original characters directly. Buildings, paths, trees,
and layout are simple generated SVG shapes. From the repository root, run
`ruby scripts/build-town.rb` or `ruby scripts/build-quiet-town.rb` to regenerate
the SVG in `wallpapers/archive/ferris/`.
