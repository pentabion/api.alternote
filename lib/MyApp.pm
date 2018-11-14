package MyApp;
use Mojo::Base 'Mojolicious';

use Mojolicious::Plugin::Database;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by "my_app.conf"
  my $config = $self->plugin('Config');

  $self->plugin('database', {
      dsn      => "dbi:Pg:dbname=$config->{db}->{database};host=$config->{db}->{hostname}",
      username => $config->{db}->{username},
      password => $config->{db}->{password},
      options  => { 'pg_enable_utf8' => 1, AutoCommit => 1 },
      helper   => 'db',
      });

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('www#index');

  $r->get('/api/1/node/list_active')->to('api#list_nodes', active => 1);
  $r->get('/api/1/node/list_inactive')->to('api#list_nodes', active => 0);

  $r->get('/api/1/node/config/get')->to('api#get_node_config');
  $r->post('/api/1/node/config/set')->to('api#set_node_config');
  $r->post('/api/1/node/confi/cpy')->to('api#copy_node_config');

  $r->get('/api/1/node/add')->to('api#add_node');
  $r->get('/api/1/node/del')->to('api#remove_node');
  $r->get('/api/1/node/state/set')->to('api#set_node_state');
  $r->get('/api/1/node/state/get')->to('api#get_node_state');

  $r->get('/api/1/node/job/add')->to('api#add_node_job');
  $r->get('/api/1/node/job/cancel')->to('api#set_node_state', state => 'canceled');
  $r->get('/api/1/node/job/status/set')->to('api#set_job_status');
  $r->get('/api/1/node/job/status/get')->to('api#get_job_status');

  $r->get('/api/1/group/add')->to('api#add_group');
  $r->get('/api/1/group/del')->to('api#del_group');
  $r->get('/api/1/group/list')->to('api#list_groups');
  $r->get('/api/1/group/node/add')->to('api#group_add_node');
  $r->get('/api/1/group/node/del')->to('api#group_del_node');
  $r->get('/api/1/group/list_nodes')->to('api#list_nodes_in_group');
  $r->get('/api/1/group/list_groups')->to('api#list_groups_of_node');
}

1;
