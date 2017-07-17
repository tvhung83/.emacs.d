#!/usr/bin/env perl

# This perl script launches a simple REPL daemon for Doom Emacs (and its
# app/regex module) to communicate with.
#
# Why perl? Because of out-of-the-box PCRE compatibility (no additional
# dependencies) and perl's ubiquity; it comes pre-packaged in a number of Linux
# distros (and MacOS).

use strict;
use warnings;
use 5.008;
use utf8;

sub set {
    my $eob = shift . "\n";
    my $buffer = "";
    my $line;
    while (1) {
        $line = <STDIN>;
        last if $line eq $eob;
        $buffer .= $line;
    }
    return $buffer;
}

sub match {
    my $text = shift;
    print "(";
    while ($text =~ m/$1/gm) {
        my @matches = ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15);
        print "(", length($`), " ", length($&);
        for my $i (0 .. $#matches) {
            if ($matches[$i]) {
                $matches[$i] =~ s/([\\"])/\\$1/g;
                print " (", $i, " \"", $matches[$i], "\")";
            }
        }
        print ") ";
    }
    print ")\n";
}

# TODO
sub replace {}

#
sub main() {
    my $text;

    print "hi\n";
    while (1) {
        print "> ";
        my $input = <STDIN>;
        chomp $input;
        if ($input =~ /^exit$/) {
            print "bye\n";
            exit;
        } elsif ($input =~ /^show$/) {
            print defined $text ? $text : "nil\n";
        } elsif ($input =~ /^text (.+)/) {
            $text = set $1;
            print "text set\n";
        } elsif ($input =~ /^match ([^\n]+)/) {
            match $text;
        } else {
            print "unrecognized input\n";
        }
    }
}

main();
