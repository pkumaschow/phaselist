package PhaseList;

use Dancer;
use CHI;

my $cache = CHI->new(driver => 'FastMmap', cache_size => '10m');

sub cached (&) {
    my ($s) = @_;
    return sub {
        content_type 'text/html';
        my $expiry_key = "_expiry_".request->uri;
        my $expires_in = $cache->get($expiry_key) // 1;
        my $out = $cache->compute(request->uri, $expires_in, sub {
            $cache->set($expiry_key, min($expires_in * 1.6, 3600));
            [$s->(), content_type()];
        });
        content_type $out->[1];
        $out->[0];
    };
}

sub cache_cleared (&) {
    my ($s) = @_;
    return sub { $cache->clear; $s->() };
}

get "/" => cached \&PhaseList::Handler::Site::index;
