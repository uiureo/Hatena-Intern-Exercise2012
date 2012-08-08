package TemplateEngine;
use strict;
use warnings;
use utf8;
use Class::Accessor::Lite (
  new => 1,
  rw => [ qw(file) ],
);

use Data::Dumper;
sub p { print Dumper($_[0]); };

sub render {
  my ($self, $vars) = @_;

  open my $template_fh, '<', $self->file
    or die "Could not open " . $self->file . ": $!";
  my $template_text = join '', <$template_fh>;

  $self->_replace($template_text, $vars);
}

sub _replace {
  my ($self, $template_text, $vars) = @_;

  # {%+ a %} ... {%- a %} - loop over collections 'a'
  $template_text =~ 
    s/^\s* {%\+\s*(\w+)\s*%} \s*? \n (.*\n) \s*? {%\-\s*\g1\s*%} \s*$ \n /{
      my $replaced = "";
      my $sub_template = $2;
      for my $var (@{$vars->{$1}}) {
        $replaced .= $self->_replace($sub_template, $var);
      }
      $replaced;
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

