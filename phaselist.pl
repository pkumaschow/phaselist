#!/usr/bin/env perl


# Lambda function spins up a container - executes this script to generate the html file
# stores the function in a bucket in s3

# Lambda function has a role that allows it to spin up the docker container
# Docker container has a role that allows it to write to the bucket

# cloud formation template spins it all up, creates the roles etc


use Astro::MoonPhase;
use Switch;
use POSIX qw(strftime);
use DateTime;

use lib 'local/lib/';

$dateformat ="%d-%b-%Y";

$seconds_since_1970 = time;

$one_day = 24 * 60 * 60;
$one_year = 365 * $one_day;
$start = $seconds_since_1970 - 0.05 * (365 * 24 * 60 * 60);
$stop = $seconds_since_1970 + 0.255 * (365 * 24 * 60 * 60);

($phase, @times) = phaselist($start, $stop);

@table = ();

@name = ('The New Moon', 'First Quarter Moon', 'The Full Moon', 'Last Quarter Moon');

$prev_end = 0;

while (@times) {
    $phasetime = shift @times;
    #default for quarter phases;
    switch ($phase) {
        case 0 {
           $pre = 4;
           $post = 5;
        }
        case 1 {
             $pre = 2;
             $post = 2;
        }
        case 2 {
            $pre = 4;
            $post = 5;
        }
        case 3 {
             $pre = 2;
             $post = 2;
        }
    }
    $start = $phasetime - $pre * $one_day;
    $end = $phasetime + $post * $one_day;
    my %phase = (type => $phase, name=>$name[$phase], start=>$start, phase=>$phasetime, end=>$end);
    push @table, \%phase;
    $phase = ($phase + 1) % 4;
}

#parse it and clean it up so that dates are contiguous

for($row = 0; $row < scalar @table; $row++) {
    %phase = %{$table[$row]};
    if ($row > 0 ) {
        %prev_phase = %{$table[$row - 1]};
        if ($phase{start} - $prev_phase{end} > $one_day)
        {
             $table[$row]{start} = $prev_phase{end} + $one_day;
        }
    }
    if ($row < scalar @table) {
        %next_phase = %{$table[$row + 1]};
    }
    #if full moon or new moon
    if ($table[$row]{type} == 0 || $table[$row]{type} == 2) {
        #if prev end date doesn't equal 1 day prior to this start date
        #then set this start date to prev end date +1 day
        if ($phase{start} - $prev_phase{end} < $one_day) {
            $table[$row]{start} = $prev_phase{end} + $one_day;
        }

        #if next start date less than 1 day after this end date
        #then set this end date to next start date -1 day

        if ($next_phase{start} - $phase{end} <= $one_day && $next_phase{start} != 0) {
            $table[$row]{end} = $next_phase{start} - $one_day;
        }
    }
    $table[$row]{start_formatted} = strftime $dateformat, localtime $table[$row]{start};
    $table[$row]{end_formatted} = strftime $dateformat, localtime $table[$row]{end};
    $table[$row]{phase_formatted} = strftime $dateformat, localtime $table[$row]{phase};
}

#if any argument is passed then output html
if (@ARGV) {
    &html_print(@table);
} else {
    &text_print(@table);
}

sub text_print() {
    print "============================================================\n";
    for( $row = 0; $row < scalar @_; $row++ ) {
        #printf "%s ", $phase{type};
        printf "%-22s%s ", $_[$row]{name};
        printf "%s  ", $_[$row]{start_formatted};
        printf "%s  ", $_[$row]{phase_formatted};
        printf "%s  ", $_[$row]{end_formatted};
        print "\n";
        if ($_[$row]{type} == 0) {
            print "============================================================\n";
        }
    }
}

sub html_print() {
    #print "Content-type: text/html\n\n";
    print "<html>";
    print "<head><link href='default.css' rel='stylesheet'></head>";
    print "<body>";
    print "<table>";
    print "<tr><th>Phase Name</th><th>Phase Start</th><th>Phase Date</th><th>Phase End</th></tr>";
    for( $row = 0; $row < scalar @_; $row++ ) {
        printf "<tr class=\"cell row type_%s\">\n", $_[$row]{type};
        printf "\t<td class=\"cell phase_name\">%s</td> \n", $_[$row]{name};
        printf "\t<td class=\"cell phase_start\">%s</td> \n", $_[$row]{start_formatted};
        printf "\t<td class=\"cell phase_date\">%s</td> \n", $_[$row]{phase_formatted};
        printf "\t<td class=\"cell phase_end\">%s</td> \n", $_[$row]{end_formatted};
        print "</tr>\n";
    }
    print "</table></body></html>";
}

