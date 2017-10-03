#!/usr/bin/perl -w
package ConectarDB;
use strict;
use DBI;

my $db_user = "user_database";
my $db_pass = "passwd_database";

my $host_name = "host_database";
my $db_name = "database";


my $q_string = "DBI:mysql:host=$host_name;database=$db_name";


sub connect{
	return (DBI->connect ($q_string, $db_user, $db_pass,{PrintError => 0, RaiseError => 1}));
}

1;
