#!/usr/bin/perl
use strict;
use warnings;
my @sample;
my %hash;
open (IN,"chr17.vcf") or die $!;
while (<IN>) {
	chomp;
	next if (/^##/);
	my $line=$_;
	if ($line=~/^#CHROM/){ (undef,undef,undef,undef,undef,undef,undef,undef,undef,@sample)=split/\t/,$line;
		next;
	}
#CHROM POS ID REF ALT QUAL FILTER INFO FORMAT 27DMBDM4YT 7XKZJA3JWX APRDKV0LDS
my ($chrom,$pos,$id,$ref,$alt,$qual,$filter,$info,$format,@Other)=split/\t/,$line;
if ($pos>=7661779 && $pos <=7687550){
	for (my $i=0;$i<@sample ;$i++) {
		my $lis=(split/:/,$Other[$i])[0];
		my ($aa,$bb)=split/\//,$lis;
		$hash{$sample[$i]}{'00'} = 0 unless $hash{$sample[$i]}{'00'};
		$hash{$sample[$i]}{'..'} = 0 unless $hash{$sample[$i]}{'..'};
		$hash{$sample[$i]}{'aa'} = 0 unless $hash{$sample[$i]}{'aa'};
		$hash{$sample[$i]}{'ab'} = 0 unless $hash{$sample[$i]}{'ab'};
		if ($aa eq '.'){
			$hash{$sample[$i]}{'..'}+=1;
		}
		if ($aa ==0 and $bb==0){
			$hash{$sample[$i]}{'00'}+=1;
		}
		if ($aa == $bb and $aa !=0) {
			$hash{$sample[$i]}{'aa'} +=1;
		}
		if ($aa != $bb){
			$hash{$sample[$i]}{'ab'} +=1;
		}
	}
}
}

close IN;
print "#Sample\t./.\t0/0\tHomozygousALT\tHeterozygoteALT\n";
foreach my $name (keys %hash) {
print "$name\t$hash{$name}{'..'}\t$hash{$name}{'00'}\t$hash{$name}{'aa'}\t$hash{$name}{'ab'}\n";
}