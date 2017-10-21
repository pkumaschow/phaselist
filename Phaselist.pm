#!/usr/bin/perl

#    Phaselist Module
#
#    Copyright (C) 2017 Peter Kumaschow
#
#    This program is f ee software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License along
#    with this program; if not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

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
                              'end'  => $end,
                              'is_new' => $phase == 0 ? 1 : 0,
                              'is_first' => $phase == 1 ? 1 : 0,
                              'is_full' => $phase == 2 ? 1 : 0,
                              'is_last' => $phase == 3 ? 1 : 0,
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

    #pop off the last element for now -- dates are screwed up
    pop @table;

    return @table;
}


1;
