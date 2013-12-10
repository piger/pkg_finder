#!/usr/bin/perl -w
# $Id: pkg_finder.pl,v 1.10 2005/11/23 21:13:25 cvs Exp $

# OpenBSD package finder 2.1
# by: Daniel Kertesz <daniel@spatof.org> http://www.spatof.org

# for help: $ perldoc ./pkg_finder.pl

use Net::FTP;
use strict;

sub find_file {
	my ($what, $where, $l) = @_;

	my @res = glob($where . "/" . "*.tgz");
	foreach my $i (@res) {
		$i =~ s#^.*/##;
		if ($i =~ /$what/i) {
			if ($l) {
				print "$i ";
			} else {
				print "$i\n";
			}
		}
	}
}

sub find_ftp {
	my ($what, $where, $l) = @_;
	my ($host, $path) = $where =~ m#^ftp://([\w\.]+)([/\w\.]+)#;

	my $f = Net::FTP->new($host, Passive => 1)
		or die "Cannot open ftp connection to: $host\n$@";
	$f->login("anonymous",'\-anonymous@')
		or die("Cannot do anonymous login:\n", $f->message);
	$f->cwd($path)
		or die("Cannot chdir:\n", $f->message);
	my @quasi = grep { /$what/i } $f->ls();
	foreach my $i (@quasi) {
		if ($l) {
			print "$i ";
		} else {
			print "$i\n";
		}
	}
	$f->quit;
}

if (!defined($ARGV[0])) {
print <<EOF;
Usage: $0 [-l] "<match>"
Where match is a regular expression describing the package
filename, for example:
screen
"^auto"
"^p5-HTML"

for help: perldoc ./pkg_finder.pl
EOF
	exit 1;
}

my $line = 0;
my $find;
if (defined($ARGV[1]) && $ARGV[0] eq "-l") {
	$line = 1;
	$find = $ARGV[1];
} else {
	$find = $ARGV[0];
}

if ($ENV{PKG_PATH}) {
	if ($ENV{PKG_PATH} =~ /^ftp/) {
		find_ftp($find, $ENV{PKG_PATH}, $line);
	}
	else {
		find_file($find, $ENV{PKG_PATH}, $line);
	}
} else {
	my $pkgpath = "ftp://ftp.openbsd.org/pub/OpenBSD/" . `uname -r` . \
		"/packages/" . `uname -m` . "/";
	$pkgpath =~ s#\n##mg;
	find_ftp($find, $pkgpath, $line);
}

__END__

=head1 NAME

pkg_finder - search packages filename from command line

=head1 SYNOPSIS

	pkg_finder.pl [-l] <match>

	pkg_finder.pl foobar

	pkg_finder.pl "^(foo|bar)-2\.0"

=head1 DESCRIPTION

First search for package filename, then install it:

 # export PKG_PATH=/mnt/cdrom/3.8/packages/i386
 # pkg_finder.pl screen
 screen-4.0.2.tgz
 # pkg_add screen-4.0.2.tgz

Also via network:

 # export PKG_PATH="ftp://ftp.kd85.com/pub/OpenBSD/3.8/packages/i386/"
 # pkg_finder.pl screen
 p5-Term-Screen-1.02.tgz
 p5-Term-ScreenColor-1.09.tgz
 screen-4.0.2-shm.tgz
 screen-4.0.2-static.tgz
 screen-4.0.2.tgz
 xscreensaver-4.21-no_gle.tgz
 # pkg_add screen-4.0.2-static.tgz

Use -l for grouping the output on a single line:

 % sudo pkg_add -v $(pkg_finder.pl -l p5-HTML-Template)
 Password:
 parsing p5-HTML-Template-2.6
 p5-HTML-Template-2.6: complete
 parsing p5-HTML-Template-Expr-0.04
 ...
 p5-HTML-Template-Expr-0.04: complete


=head1 AUTHOR

Daniel Kertesz - <daniel@spatof.org> http://www.spatof.org

=cut
