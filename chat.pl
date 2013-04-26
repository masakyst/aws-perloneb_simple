#!/usr/bin/env perl

=pod
AWS Elastic Load Balancer Protocol TCP only
edit .elasticbeanstalk/optionsettings, and eb update
----------------------------
[aws:elb:loadbalancer]
LoadBalancerPortProtocol=TCP
----------------------------
=cut

use utf8;
use Encode;
use Mojolicious::Lite;
use Time::Piece;
use Mojo::JSON;

app->config(hypnotoad => {
    pid_file => '/tmp/hypnotoad.pid',
    listen   => ['http://*:80'],
    workers  => 1,
});

get '/' => 'index';

my $clients = {};

websocket '/echo' => sub {
    my $self = shift;
    my $json = Mojo::JSON->new;
    
    # Mojo::IOLoop->stream($self->tx->connection)->timeout(300);

    my $id = sprintf "%s", $self->tx;
    
    $clients->{$id} = $self->tx;
    $self->on(message => sub {
            my ($self, $msg) = @_;
            app->log->debug('Client id: '.$id);
            for (keys %$clients) {
                $clients->{$_}->send(
                    decode(utf8 => $json->encode({
                        hms  => localtime->strftime('%H:%M:%S'),
                        text => $msg,
                    }))
                );
            }
        }
    );
    $self->on(finish => sub {
            app->log->debug('Client disconnected');
            delete $clients->{$id};
        }
    );
};

app->start;

__DATA__
@@ index.html.ep
<html>
  <head>
    <title>WebSocket Client</title>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js" ></script>
    <script type="text/javascript" src="ws.js"></script>
    <link href="http://kevinburke.bitbucket.org/markdowncss/markdown.css" rel="stylesheet"></link>
  </head>
<body>

<h1>Perl Mojolicious / WebSocket chat</h1>
<p><input type="text" id="msg" /></p>
<div id="talks"></div>

</body>
</html>

@@ ws.js
$(function () {
    $('#msg').focus();
    var loc = window.location;
    var uri = "ws://" + loc.host + loc.pathname + 'echo';
    var ws = new WebSocket(uri);
    ws.onopen = function () {
        $('#talks').prepend('<h2>Congratulations!!</h2>');
    };
    ws.onmessage = function (msg) {
        var res = JSON.parse(msg.data);
        //console.log(res);
        if (res.text != 'ping') {
            $('#talks').prepend('<h2>' + res.hms + ' = ' + res.text + '</h2>');
        }
    };
    $('#msg').keydown(function (e) {
        if (e.keyCode == 13 && $('#msg').val()) {
            ws.send($('#msg').val());
            $('#msg').val('');
        }
    });
    var connection_interval = setInterval(function(){ 
        ws.send('ping');
    }, 10000);
});
