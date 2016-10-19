package PhaseList::Handler::Site;

use Dancer ':syntax';
use DateTime;
use DateTime::Format::DateParse;

sub index {

    template "index" => {
        _template_params,
        msg => 'hellooo',
};
}
