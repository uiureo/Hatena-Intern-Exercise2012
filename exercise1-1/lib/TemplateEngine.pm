package TemplateEngine;
use strict;
use warnings;
use utf8;
use Class::Accessor::Lite (
  new => 1,
  rw => [ qw(file) ],
);

sub render {
  my ($self, $vars) = @_;

  open my $template_fh, '<', $self->file
    or die "Could not open " . $self->file . ": $!";
  my $template_text = join '', <$template_fh>;

  # {{% ... %}} returns unescaped HTML
  $template_text =~ s/{{%\s*(\w+)\s*%}}/$vars->{$1}/g;
  # {% ... %} returns escaped HTML by default
  $template_text =~ s/{%\s*(\w+)\s*%}/$self->_escapeHTML($vars->{$1})/eg;

  $template_text;
}

sub _escapeHTML {
  my $str = $_[1];
  my %character = ( '&' => '&amp;', '<' => '&lt;', '>' => '&gt;', '"' => '&quot;' );
  $str =~ s/([&<>"])/$character{$1}/g;
  $str;
}

1;
