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

  $self->_replace($template_text, $vars);
}

sub _replace {
  my ($self, $template_text, $vars) = @_;

  ## TODO: refactor regexp
  # {%+ a %} ... {%- a %} - loop over collections 'a'
  $template_text =~ 
    s/^\s* {%\+\s*(\w+)\s*%} \s*$ \n (.*) \n \s* {%\-\s*\g1\s*%} \s*$/{
      my @replaced = ();
      if (@{$vars->{$1}} >= 1) {
        for my $var (@{$vars->{$1}}) {
          push @replaced, $self->_replace($2, $var);
        }
      }
      join "\n", @replaced;
    }/smegx; 

  # {{% ... %}} returns unescaped HTML
  $template_text =~ s/{{%\s*(\w+)\s*%}}/$vars->{$1}/g;
  # {% ... %} returns escaped HTML by default
  $template_text =~ s/{%\s*(\w+)\s*%}/$self->_escape_html($vars->{$1})/eg;
  # {%# ... %} is comments and ignored
  $template_text =~ s/{%#[\s\w]*?%}//g;

  $template_text;
}

sub _escape_html {
  my $str = $_[1];
  my %character = ( '&' => '&amp;', '<' => '&lt;', '>' => '&gt;', '"' => '&quot;' );
  $str =~ s/([&<>"])/$character{$1}/g;
  $str;
}

1;

