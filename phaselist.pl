#!/usr/bin/env perl

use strict;

require Phaselist;
require HTML::Template;

use constant TMPL_FILE => "./templates/html.tmpl";

my @list = Phaselist::list();

my $tmpl = new HTML::Template( filename => TMPL_FILE );

$tmpl->param( phase_list => \@list );

print $tmpl->output;