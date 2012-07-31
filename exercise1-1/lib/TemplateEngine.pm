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

  for my $key (keys %$vars) {
    $vars->{$key} = $self->_escapeHTML($vars->{$key});
  }

  open my $template_fh, '<', $self->file
    or die "Could not open " . $self->file . ": $!";
  my $template_text = join '', <$template_fh>;

  $template_text =~ s/{%\s*(\w+)\s*%}/$vars->{$1}/g;

  $template_text;
}

sub _escapeHTML {
  $_ = $_[1];
  s/&/&amp;/g;
  s/>/&gt;/g;
  s/</&lt;/g;
  s/"/&quot;/g;

  $_;
}

1;
