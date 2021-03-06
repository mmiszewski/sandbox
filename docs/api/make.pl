#!/usr/bin/perl
#
# prosty skrypt tworz�cy dokumentacj� API libgadu z dost�pnych �r�de�.
#
# $Id: make.pl,v 1.6 2003-03-11 19:39:05 wojtekka Exp $

open(H, ">functions.html");

print H "<html>\n<head>\n<meta http-equiv=\"Content-type\" content=\"text/html; charset=iso-8859-2\">\n<link rel=stylesheet href=\"style.css\" type=\"text/css\">\n</head>\n<body>\n<center>\n<table border=\"0\" width=\"600\"><tr><td>\n";

for $i (glob("../../lib/*.c")) {
	open(F, $i);

	print "Plik $i\n";

	while (<F>) {
		chomp();
		next if (!/^\/\*/);

		$_ = <F>;
		chomp();
		next if (!/^ \* gg_.*\(\)/);

		s/^ \* //;
		s/\(.*//;

		$name = $_;
		print "  Funkcja $name\n";
		$descr = "";
		$p_num = 0;
		%p_descr = ();
		%p_type = ();
		$result = "";
		
		<F>;
		
		while (1) {
			# wczytaj lini�.
			$_ = <F>;
			chomp();

			# usu� komentarz.
			s/^ \* *//;
			
			# je�li zacz�y si� parametry, spadaj.
			last if (/^-/ || /^\/$/);
			
			if (/^$/) {
				$descr .= "<p> ";
			} else {
				$descr .= "$_ ";
			}
		}

		$descr =~ s/<p> $//;

		$descr = uc_my($descr);

		while (1) {
			# je�li koniec parametr�w, wyjd�.
			last if (/^$/ || /^\/$/);

			# pocz�tek opisu parametru?
			if (/^- ([^ -]+) - (.*)/) {
				$last_p = "$p_num $1";
				$p_descr{$last_p} = $2;
				$p_num++;
			} elsif (/^- ([a-zA-Z0-9_]+)/) {
				$last_p = "$p_num $1";
				$p_descr{$last_p} = "";
				$last_p = $1;
			} else {
				$p_descr{$last_p} .= " $_ ";
			}

			# czytaj nast�pn� lini�.
			$_ = <F>;
			chomp();
			s/^ \* *//;
		}

		while (!/^\/$/) {
			if ($_ ne "") {
				$result .= "$_ ";
			}

			$_ = <F>;
			chomp();
			s/^ \* *//;
		}

		if (!$result) {
			$result = "Brak.";
		}

		if ($result =~ /0, -1, errno/) {
			$result = "0 je�li operacja si� powiod�a, -1 w przypadku b��du (kod b��du w zmiennej <tt>errno</tt>.)";
		}
		if ($result =~ /0, -1/) {
			$result = "0 je�li operacja si� powiod�a, -1 w przypadku b��du.";
		}

		$result = uc_my($result);

		$_ = <F>;
		chomp();

		next if (/^static/);
		
		$decl = $_;
		
		s/^[^(]*\(//;
		s/\) *$//;

		foreach (split(/ *, */)) {
			s/^ *//;
			s/ *$//;

			if (/([a-zA-Z0-9_]+)$/) {
				$p_name = $1;
				$_ =~ s/$p_name$//;
				$p_type{$p_name} = $_;
			}
		}

		print H "\n\n";
		print H "<a name=\"$name\"></a>\n";
		print H "<div class=\"function\">$name</div>\n";
		print H "<div class=\"header\">Dzia�anie:</div>\n";
		print H "<div class=\"desc\">$descr</div>\n";

		$decl = declarize($decl);

		$functions{$name} = declarize2($decl);

		print H "<div class=\"header\">Deklaracja:</div>\n";
		print H "<div class=\"decl\">$decl;</div>\n";

		if (%p_descr) {
			print H "<div class=\"header\">Parametry:</div>\n";
			print H "<div class=\"params\">\n<table cellspacing=\"1\" border=\"0\" class=\"params\">\n";
			
			foreach $i (sort keys %p_descr) {
				$name = $i;
				$name =~ s/^[0-9]* //g;
				$name2 = $name;
				$name2 =~ s/\.\.\.$//;
				$type = colorize($p_type{$name2});
				print H "<tr><td class=\"paramname\">$type<i>$name</i></td><td class=\"paramdescr\">" . $p_descr{$i} . "</td></tr>\n";
			}
			print H "</table>\n</div>\n";
		}

		print H "<div class=\"header\">Zwracana warto��:</div>\n";
		print H "<div class=\"result\">$result</div>\n";
	}

	close(F);
	
}

print H "</td></tr></table>\n</body>\n</html>\n";
close(H);

open(F, "../../lib/libgadu.h");
open(H, ">types.html");
print H "<html>\n<head>\n<meta http-equiv=\"Content-type\" content=\"text/html; charset=iso-8859-2\">\n<link rel=stylesheet href=\"style.css\" type=\"text/css\">\n</head>\n<body>\n<center>\n<table border=\"0\" width=\"600\"><tr><td>\n";

while(<F>) {
	chomp;

	if (/^#define gg_common_head/) {
		$common = "";

		while (<F>) {
			chomp;
			if (/^(\t|        )([a-z].*)\/\* (.*) \*\//) {
				$field = colorize($2);
				$common .= "<tr><td class=\"paramname\">$2</td><td class=\"paramdescr\">$3</td></tr>\n";
			}
			last if (/^$/);
		}
	}

	if (/^ \* (enum|struct|typedef) (.*)/) {
		$name = $2;
		$type = $1;

		print H "\n\n<a name=\"$1_$2\"></a>\n";
		print H "<div class=\"$1\">$2</div>\n";
		<F>;
		$body = "";
		while (<F>) {
			chomp;
			last if (/^ \*\//);
			s/^ \* //;
			$body .= "$_\n";
		}

		$body = uc_my($body);
		print H "<div class=\"header\">\nZnaczenie:\n</div>\n";
		print H "<div class=\"desc\">\n$body\n</div>\n";

		if ($type eq "enum") {
			push @enums, $name;

			print H "<div class=\"header\">Warto�ci:</div>\n";
			print H "<div class=\"params\">\n<table cellspacing=\"1\" border=\"0\" class=\"params\">\n";
			while (<F>) {
				chomp;
				if (/(GG_[A-Z0-9_]+).*\/\* (.*) \*\//) {
					print H "<tr><td class=\"paramname\">$1</td><td class=\"paramdescr\">$2</td></tr>\n";
				}
				last if (/^}/);
			}
			print H "</table>\n</div>\n";
		}

		if ($type eq "struct") {
			push @structs, $name;

			print H "<div class=\"header\">Pola struktury:</div>\n";

			$table_open = 0;

			while (<F>) {
				chomp;

				if (/^(\t|        )gg_common_head/) {
					print H "<div class=\"params\">\n";
					print H "<table cellspacing=\"1\" border=\"0\" class=\"params\">\n";
					print H $common;

					$table_open = 1;
				}

				if (/^(\t|        ){2}struct.*\/\* @([^ ]*) (.*) \*\//) {
					if ($table_open) {
						print H "</table>\n</div>\n";
						$table_open = 0;
					}

					print H "<div class=\"header\">Pola struktury <tt>$union.$2</tt> ($3):</div>\n";
				}

				if (/^(\t|        ){2}} && $table_open/) {
					print H "</table>\n</div>\n";
					$table_open = 0;
				}

				if (/^(\t|        )union.*\/\* @([^ ]*) .*/) {
					$union = $2;

					if ($table_open) {
						print H "</table>\n</div>\n";
						$table_open = 0;
					}

					print H "<div class=\"header\">Pola unii <tt>$2</tt>:</div>\n";
				}

				if (/^(\t|        ){2}} && $table_open/) {
					print H "</table>\n</div>\n";
					$table_open = 0;
				}

				if (/^(\t|        ){1,3}([a-z].*)\/\* (.*) \*\// && $1 !~ /gg_session_common/) {
					$name = $2;
					$desc = $3;

					if ($name !~ /^(struct|union) \{/) {
						if ($table_open == 0) {
							print H "<div class=\"params\">\n";
							print H "<table cellspacing=\"1\" border=\"0\" class=\"params\">\n";
							$table_open = 1;
						}

						print H "<tr><td class=\"paramname\">$name</td><td class=\"paramdescr\">$desc</td></tr>\n";
					}
				}

				last if (/^}/);
			}

			if ($table_open) {
				print H "</table>\n</div>\n";
			}
		}

		if ($type eq "typedef") {
			push @typedefs, $name;
		}
	}
}

close(F);
close(H);

open(F, "functions.txt");

open(H, ">index.html");
print H "<html>\n<head>\n<meta http-equiv=\"Content-type\" content=\"text/html; charset=iso-8859-2\">\n<link rel=stylesheet href=\"style.css\" type=\"text/css\">\n</head>\n<body>\n<center>\n<table border=\"0\" width=\"600\"><tr><td>\n";

$first = 1;

print H "<div class=\"funcgroup\">Typy danych</div>\n";
print H "<div class=\"indexdecl\">\n";

foreach $i (sort @typedefs) {
	print H "<span class=\"index_typedef\">typedef</span> <a href=\"types.html#typedef_$i\"><b>$i</b></a>;<br>\n";
}

print H "</div>\n\n";

print H "<div class=\"funcgroup\">Struktury</div>\n";
print H "<div class=\"indexdecl\">\n";

foreach $i (sort @structs) {
	print H "<span class=\"index_struct\">struct</span> <a href=\"types.html#struct_$i\"><b>$i</b></a>;<br>\n";
}

print H "</div>\n\n";

print H "<div class=\"funcgroup\">Typy wyliczeniowe</div>\n";
print H "<div class=\"indexdecl\">\n";

foreach $i (sort @enums) {
	print H "<span class=\"index_enum\">enum</span> <a href=\"types.html#enum_$i\"><b>$i</b></a>;<br>\n";
}

print H "</div>\n\n";

while(<F>) {
	chomp;

	next if (/^[\t ]*$/);

	if (/^[A-Z]/) {
		if (!$first) {
			print H "</div>\n";
		}
		$first = 0;
		print H "<div class=\"funcgroup\">$_</div>\n";
		print H "<div class=\"indexdecl\">\n";
	}

	if (/^\t(.*)/) {
		print H $functions{$1}, ";<br>\n";
	}
}

print H "</body>\n</html>\n";

close(F);
close(H);

sub uc_char($)
{
	my ($ch) = @_;

	$ch =~ y/a-z����󶿼/A-Z��ʣ�Ӧ��/;

	return $ch;
}

sub uc_my()
{
	my ($str) = @_;

	$str =~ s/ +/ /g;

	$str =~ s/^(.)/uc_char($1)/eg;
	$str =~ s/\. ([a-z����󶿼])/sprintf(". %s", uc_char($1))/eg;
	$str =~ s/\"([^"]*)\"/"<tt>$1<\/tt>"/g;
	$str =~ s/\'([^']*)\'/'<tt>$1<\/tt>'/g;
	$str =~ s/([a-zA-Z0-9_]+\(\))/<tt>$1<\/tt>/g;
	$str =~ s/(gg_[a-zA-Z0-9_]+)\(\)/<a href="#$1">$1()<\/a>/g;
	$str =~ s/(GG_[A-Z0-9_]+)/<tt>$1<\/tt>/g;
	$str =~ s/NULL/<tt>NULL<\/tt>/g;

	return $str;
}

sub space_to_dash($)
{
	$_ = $_[0];

	y/ /_/;

	return $_;
}

sub colorize($)
{
	$_ = $_[0];

	@ctypes = qw(void char long short u?int[0-9]+_t int);
	push @ctypes, "struct hostent";
	push @ctypes, "struct in_addr";
	foreach $i (@ctypes) {
		s/(inline |const |static |unsigned )*($i)/<span class=\"ctype\">$1$2<\/span>/g;
	}

	$known[0] = "struct gg_[0-9a-z_]+";
	$known[1] = "gg_[0-9a-z_]+_t";
	$known[2] = "uin_t";
	foreach $i (@known) {
		$type = $i;
		$type =~ s/ /_/g;
		s/(const )*($i)/sprintf("<a class=\"typelink\" href=\"types.html#%s\">%s%s<\/a>", space_to_dash($2), $1, $2)/eg;
	}

	return $_;
}

sub declarize()
{
	my $result, $params, $nam, $type, ($decl) = @_;

	$params = $decl;
	$params =~ s/[^(]*\(//;
	$params =~ s/\).*//;

	$nam = $decl;
	$nam =~ s/\(.*//;
	$nam =~ s/.*(gg_[a-z0-9_]+)/$1/;

	$type = $decl;
	$type =~ s/gg_[a-z0-9_]+\(.*//;

	$result = colorize($type) . "<b>$nam</b>(";

	foreach (split(/ *, */, $params)) {
		s/^ *//;
		s/ *$//;

		if (/([a-zA-Z0-9_]+)$/) {
			$nam = $1;
			$_ =~ s/$nam$//;
			$result .= colorize($_) . "<i>$nam</i>, ";
		} elsif (/^\.\.\.$/) {
			$result .= "<i>...</i>";
		}
	}

	$result =~ s/, $//;
	$result .= ")";

	return $result;
}

sub declarize2()
{
	my ($str) = @_;

	$str =~ s/<a [^>]*>/<span class=\"ggtype\">/g;
	$str =~ s/<\/a>/<\/span>/g;

	$str =~ s/<b>([^<]*)<\/b>/<b><a class=\"funclink\" href=\"functions.html#$1\">$1<\/a><\/b>/g;

	return $str;
}

