use strict;
use warnings;

use Test::More;
use FindBin::libs;

use_ok 'TemplateEngine';

subtest '{% %}' => sub {
  my $template = TemplateEngine->new( file => 'templates/main.html' );
  isa_ok $template, 'TemplateEngine';

  my $expected = <<'HTML';
<html>
  <head>
    <title>タイトル</title>
  </head>
  <body>
    <p>これはコンテンツです。&amp;&lt;&gt;&quot;</p>
  </body>
</html>
HTML

  cmp_ok $template->render({
    title   => 'タイトル',
    content => 'これはコンテンツです。&<>"',
  }), 'eq', $expected; 
};

subtest '{{% %}} - return unescaped HTML' => sub {
  my $template = TemplateEngine->new ( file => 'templates/main2.html' );
  isa_ok $template, 'TemplateEngine';

  my $expected = <<'HTML';
<html>
  <head>
    <title>タイトル</title>
  </head>
  <body>
    <p><marquee>これはコンテンツです!!!!</marquee></p>
  </body>
</html>
HTML

  cmp_ok $template->render({
    title   => 'タイトル',
    content => '<marquee>これはコンテンツです!!!!</marquee>',
  }), 'eq', $expected; 
};

subtest '{%# %} - comments are ignored' => sub {
  my $template = TemplateEngine->new ( file => 'templates/main3.html' );
  isa_ok $template, 'TemplateEngine';

  my $expected = <<'HTML';
<html>
  <head>
    <title>タイトル</title>
  </head>
  <body>
    <p>これはコンテンツです</p>
    <p>せやな</p>
  </body>
</html>
HTML

  cmp_ok $template->render({
    title   => 'タイトル',
    content => 'これはコンテンツです'
  }), 'eq', $expected; 
};

done_testing();
