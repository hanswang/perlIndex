use Mojo::DOM;

my $dom = Mojo::DOM->new('<span class="degree-summary__code-text">012045K</span>');

print $dom->find('span')->text;
