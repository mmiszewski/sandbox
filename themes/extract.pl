#!/usr/bin/perl
# prosty skrypt wyci±gaj±cy z ../src/themes.c wszystkie formaty pozwalaj±c
# na ³atw± edycjê. ziew. 
# $Id: extract.pl,v 1.4 2003-08-22 12:35:56 wojtekka Exp $

open(FOO, "../src/themes.c") || die("Nie wstanê, tak bêdê le¿a³!");

while(<FOO>) {
	chomp;

	next if (!/\tformat_add\("/);

	s/\/\* .* \*\///;
	s/.*format_add\("//;
	s/", *"/ /;
	s/", *1\);.*//;

	print "$_\n";
}
