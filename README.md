# pkg_finder

A *package finder* for [OpenBSD][openbsd].

[openbsd]: http://www.openbsd.org

This is a little script I wrote many years ago to ease the maintenance of a OpenBSD system; it's like an `ls | grep` for FTP :)

I'm releasing it because apparently the **pkg** tools on OpenBSD still does not have this feature; the "code" is BSD licensed.

## Usage

To read the script documentation you can use `perldoc`:

	$ perldoc ./pkg_finder.pl

`pkg_finder` requires the environment variable `PKG_PATH` containing the path of a local package repository or the URL of a remote FTP package repository.

For example to search for the **screen** package on
`ftp://ftp.kd85.com/pub/OpenBSD/3.8/packages/i386/`:

	# export PKG_PATH="ftp://ftp.kd85.com/pub/OpenBSD/3.8/packages/i386/"
	# pkg_finder.pl screen
	p5-Term-Screen-1.02.tgz
	p5-Term-ScreenColor-1.09.tgz
	screen-4.0.2-shm.tgz
	screen-4.0.2-static.tgz
	screen-4.0.2.tgz
	xscreensaver-4.21-no_gle.tgz
	# pkg_add screen-4.0.2-static.tgz
	...

See also: [pkg_add][pkg_add] man page.

[pkg_add]: http://www.openbsd.org/cgi-bin/man.cgi?query=pkg_add&sektion=1&arch=i386&apropos=0&manpath=OpenBSD+Current

