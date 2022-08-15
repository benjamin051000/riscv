load.mif is a symbolic link to make it easy to swap programs in and out of the RAM.
Instead of changing the code in the source files, just change this symbolic link via:
`ln --force --symbolic <mif file to be loaded> load.mif`.

Shorthand:
`ln -fs <mif file to be loaded> load.mif`
