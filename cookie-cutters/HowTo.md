1. Find suitable b/w portrait or manually trace an image, etc.
2. `potrace -s image.bmp -o v1.svg`
3. Manually refine in `inkscape`
4. Export & convert to bmp (`gimp` or `imagemagick/convert`)
5. Trace the refined image `potrace -s refined.bmp -o v2.svg`
6. Use in OpenSCAD
