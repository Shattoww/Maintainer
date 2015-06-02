#!/usr/bin/perl
use strict;
use warnings;

my $START='NETWORK ID TOTALS';
my $END='NETWORK ID  COUNT TOTALS';

while (<>) {
  if (/$START/../$END/) {
    next if /START/ || /END/;
    print;
    if (/$END/) {
      print "\n **** END OF SECTION **** \n\n\n\n  **** BEGIN NEW SECTION **** \n\n";
    }
  }
}

