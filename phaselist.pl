#!/usr/bin/env perl

#    phaselist
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

use strict;

require Phaselist;

require HTML::Template;

use constant TMPL_FILE => "./templates/phaselist_template.html";

my @list = Phaselist::list();

my $tmpl = new HTML::Template( filename => TMPL_FILE );

print "<!-- Phaselist version 1.0, Copyright (C) 2017 Peter Kumaschow -->\n";
print "<!-- Phaselist comes with ABSOLUTELY NO WARRANTY -->\n";
print "<!-- This is free software, and you are welcome to redistrubute it -->\n";
print "<!-- under certain conditions; -->\n\n";

$tmpl->param( phase_list => \@list );

print $tmpl->output;
