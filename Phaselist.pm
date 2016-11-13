#!/usr/bin/perl

package Phaselist;

use strict;

require Exporter;
my @ISA = qw(Exporter);
my @EXPORT = qw(list);

use Astro::MoonPhase;
use Switch;
use POSIX qw(strftime);
use DateTime;
use Getopt::Std;
use Data::Dumper;

my $date_format ="%d-%b-%Y";

my $seconds_since_1970 = time;

my $one_day = 24 * 60 * 60;
my $one_year = 365 * $one_day;
my $start = $seconds_since_1970 - 0.05 * (365 * 24 * 60 * 60);
my $end;

my $stop = $seconds_since_1970 + 0.255 * (365 * 24 * 60 * 60);

our($phase, @times) = phaselist($start, $stop);

my @table = ();

my @name = ('The New Moon', 'First Quarter Moon', 'The Full Moon', 'Last Quarter Moon');

my $prev_end = 0;

my $phase_time = 0;

#numbers of days pre and post a phase
my $pre;
my $post;

my %phase_current;
my %phase_prev;
my %phase_next;

sub list() {
    while (@times) {
        $phase_time = shift @times;
        #default for quarter phases;

        switch ($phase) {
            #The New Moon
            case 0 {
               $pre = 4;
               $post = 5;
            }
            #FIrst Quarter Moon
            case 1 {
                 $pre = 2;
                 $post = 2;
            }
            #The Full Moon
            case 2 {
                $pre = 4;
                $post = 5;
            }
            #Last Quarter Moon
            case 3 {
                 $pre = 2;
                 $post = 2;
            }
        }

        $start = $phase_time - $pre * $one_day;
        $end = $phase_time + $post * $one_day;
        my %phase_current = ( 'type' => $phase,
                              'name' => $name[$phase],
                              'start'=> $start,
                              'phase'=> $phase_time,
                              'end'  => $end
                            );

        push @table, \%phase_current;

        $phase = ($phase + 1) % 4;
    }

    #parse it and clean it up so that dates are contiguous

    for(my $row = 0; $row < scalar @table; $row++) {


        %phase_current = %{$table[$row]};
        %phase_prev = %{$table[$row - 1]};

        if ($row < scalar @table - 1) {
            %phase_next = %{$table[$row + 1]};
            #print Dumper(\%phase_next);
        }



        #if full moon or new moon
        if ($table[$row]{type} == 0 || $table[$row]{type} == 2) {

            #if next start date less than 1 day after this end date
            #then set this end date to next start date -1 day

            if ($phase_next{start} - $phase_current{end} <= $one_day && $phase_next{start} != 0) {
                $phase_current{end} = $phase_next{start} - $one_day;
            }
        }

        if ($row > 0 ) {

            if ($phase_current{start} - $phase_prev{end} > $one_day)
            {
                 $phase_current{start} = $phase_prev{end} + $one_day;
            }
        }

        $table[$row]{start_formatted} = strftime $date_format, localtime $phase_current{start};
        $table[$row]{end_formatted} = strftime $date_format, localtime $phase_current{end};
        $table[$row]{phase_formatted} = strftime $date_format, localtime $phase_current{phase};
    }

    pop @table;

    return @table;
}

sub html_print() {
    #print "Content-type: text/html\n\n";
    print "<html>\n";
    print "<head>\n";
    print '<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/css/bootstrap.min.css" integrity="sha384-AysaV+vQoT3kOAXZkl02PThvDr8HYKPZhNT5h/CXfBThSRXQ6jW5DO2ekP5ViFdi" crossorigin="anonymous">' . "\n";
    #print "<link href='default.css' rel='stylesheet'>";
    print "</head>\n";
    print "<body>\n";
    print "<div class='container-fluid'>\n";
    print "<table>\n";
    print "<tr><th>Phase Name</th><th>Phase Start</th><th>Phase Date</th><th>Phase End</th></tr>";
    for( my $row = 0; $row < scalar @_ -1; $row++ ) {
        printf "<tr class=\"cell row type_%s\">\n", $_[$row]{type};
        printf "\t<td class=\"cell phase_name\">%s</td> \n", $_[$row]{name};
        printf "\t<td class=\"cell phase_start\">%s</td> \n", $_[$row]{start_formatted};
        printf "\t<td class=\"cell phase_date\">%s</td> \n", $_[$row]{phase_formatted};
        printf "\t<td class=\"cell phase_end\">%s</td> \n", $_[$row]{end_formatted};
        print "</tr>\n";
    }
    print "</table>";
    print '<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js" integrity="sha384-3ceskX3iaEnIogmQchP8opvBy3Mi7Ce34nWjpBIwVTHfGYWQS9jwHDVRnpKKHJg7" crossorigin="anonymous"></script>';
    print '<script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.3.7/js/tether.min.js" integrity="sha384-XTs3FgkjiBgo8qjEjBk0tGmf3wPrWtA6coPfQDfFEY8AnYJwjalXCiosYRBIBZX8" crossorigin="anonymous"></script>';
    print '<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/js/bootstrap.min.js" integrity="sha384-BLiI7JTZm+JWlgKa0M0kGRpJbF2J8q+qreVrKBC47e3K6BW78kGLrCkeRX6I9RoK" crossorigin="anonymous"></script>';
    print "</div>";
    print "</body></html>";
}

1;