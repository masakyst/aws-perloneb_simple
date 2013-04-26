use Mojolicious::Lite;

app->config(hypnotoad => {
    pid_file => '/tmp/hypnotoad.pid',
    listen   => ['http://*:80'],
    workers  => 1,
});

get '/' => {text => 'Hello Perl!'};

app->start;
