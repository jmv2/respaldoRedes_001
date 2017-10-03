#!/usr/bin/perl -w

use strict;
use Net::SSH::Expect;
use ConectarDB;
my $tftp = `dig daredevil.asinco.cl +short`;
my($dbh, $sth, $numrows);
$dbh = ConectarDB->connect();
$sth = $dbh->prepare('SELECT * FROM usuarios');
$sth->execute() or die "cuek";
$numrows = $sth->rows;
$sth->finish;
print "Cantidad de equipos: ".$numrows."\n";
for (my $i = 1; $i <= $numrows; $i++) {
    my $id = $i;
    my($dbh, $sth);
    $dbh = ConectarDB->connect();
    $sth = $dbh->prepare('SELECT usuario, clave, direccion, descripcion FROM usuarios WHERE idEquipo = ?');
    $sth->execute($id) or die "Error en la consulta" . $sth->errstr;
    my ($usuario, $clave, $equipo, $descripcion) = $sth->fetchrow_array();
    $sth->finish;
    $dbh->disconnect;
    my $ssh = Net::SSH::Expect->new (
            host => $equipo, 
            password=> $clave, 
            user => $usuario, 
            raw_pty => 1
        );
    my $login_output = $ssh->login();
    if ($login_output =~ /Welcome/){ 
    	die "Login has failed. Login output was $login_output";
    }else{
	     print "Equipo: $descripcion IP:$equipo\n";
         $ssh->send("copy running-config tftp:");
	     $ssh->waitfor('.*\?', 10) or die "No coincide la regex";
         $ssh->send($tftp);
         $ssh->waitfor('\?', 10) or die "No coincide la regex";
         $ssh->send("\r");
         }
    $ssh->close();
}
print "Hecho!\n";
#Hecho por JMv2
