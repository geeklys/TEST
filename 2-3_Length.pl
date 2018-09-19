#!/usr/bin/perl -w

use strict;

my %hash;
open IN, "newBGIseq500.scafSeq";
my @seq;
my ($len, $totallen,$name);
while (<IN>){
	chomp;
	if (/>/){
		$name = (split/\s+/,$_)[0];
		$len = 0;
		$hash{$name} = $len;
		next;
	}
	$totallen += length($_);
	$len = length($_);
	$hash{$name} += $len;
}
close IN;

my $Nlen = 0;
my $flag = 0;

open OUT,">scaf_len.txt";

foreach my $key (sort {$hash{$b} <=> $hash{$a}} keys %hash){
	print OUT "$key\t$hash{$key}\n";
	$Nlen += $hash{$key};
	if ($Nlen >= $totallen * 0.5 and !$flag) {
		print "N50: $hash{$key}\n";
		$flag = 1;
	}
}
close OUT;