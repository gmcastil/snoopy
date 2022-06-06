Directories
-----------
The following directories are used here

`src` - Downloaded sources are assumed to be here
`target` - Files compiled for the target (i.e., what will eventually get put
onto boot media) go here.  Notionally, this will include a `rootfs`, bootloader
files, and a kernel image
`toolchain` - Output products from the build of the toolchain
`sysroot` - Sysrooty things

None of these are included in the repository for obvious reasons and they should
all be created by a script or some sort of make target

Getting Sources
---------------

Some possibly useful `wget` commands are

`wget --input-file=sources.lst --directory-prefix=./sources --progress=bar`

To obtain the sources via wget and drop them into a sources directory
