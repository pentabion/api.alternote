package MyApp::Controller::Api;
use Mojo::Base 'Mojolicious::Controller';

use JSON qw/from_json/;
use Data::Dumper;

# This action will render a template
sub get_node_config {
  my $self = shift;
  my $id = $self->param('id');

  my $sth = $self->db->prepare('SELECT config FROM nodes WHERE id=?');
  $sth->execute($id);
  my $config = $sth->fetchrow_arrayref();

  # Render template "example/welcome.html.ep" with message
  $self->render(json => {status => 'ok', data => ($config->[0] // '')});
}

sub set_node_config {
  my $self       = shift;
  my $id         = $self->param('id');
  my $config = $self->param('config');
  
  my $sth = $self->db->prepare('UPDATE nodes SET config=? WHERE id=?');
  $sth->execute($config, $id);
  
  return $self->render(json => {status => "ok"});
}

sub list_nodes {
  my $self   = shift;
  my $active = $self->param('active');

  my $sth = $self->db->prepare('SELECT id FROM nodes WHERE is_active=?');
  $sth->execute($active);
  my $ids = [];
  while( my @r = $sth->fetchrow_array()){
    push @$ids, $r[0];
  }

  return $self->render(json => {status => "ok", data => $ids});
}

sub add_node {
  my $self = shift;
  my $id = $self->param('id');

  my $sth = $self->db->prepare("INSERT INTO nodes (id, is_active) VALUES (?, True)");
  $sth->execute($id);
  
  return $self->render(json => {status => "ok"});
}

sub remove_node {
  my $self = shift;
  my $id   = $self->param('id');

  my $sth = $self->db->prepare("DELETE FROM nodes WHERE id=?");
  $sth->execute($id);
  
  return $self->render(json => {status => "ok"});
}

sub set_node_state {
  my $self  = shift;
  my $id    = $self->param('id');
  my $raw_state = $self->param('state');

  return $self->render(json => {status => 'fail', ecode => 1, emsg => 'Malformed [id] value'}) unless $id =~ /^[0-9]+$/;
  return $self->render(json => {status => 'fail', ecode => 2, emsg => 'Malformed [state] value'}) unless $raw_state eq 'on' || $raw_state eq 'off';

  my $state = $raw_state eq 'on' ? 1 : 0;

  my $sth = $self->db->prepare("UPDATE nodes SET is_active=? WHERE id=?");
  $sth->execute($state, $id);

  return $self->render(json => {status => 'ok'});
}

sub get_node_state {
  my $self = shift;
  my $id = $self->param('id');

  my $sth = $self->db->prepare("SELECT is_active FROM nodes WHERE id=?");
  $sth->execute($id);

  my @row = $sth->fetchrow_array();
  return $self->render({status => 'fail', ecode => 3, emsg => "No such node [$id]"}) unless @row;

  return $self->render(json => {status => 'ok', state => $row[0]});
}

sub add_group {
  my $self          = shift;
  my $group_name    = $self->param('name');
  my $group_comment = $self->param('comment');

  my $sth = $self->db->prepare('INSERT INTO groups (name, comment) VALUES (?, ?)');
  $sth->execute($group_name, $group_comment);

  return $self->render(json => {status => 'ok'});
}

sub group_add_node {
  my $self = shift;
  my $node_id = $self->param('node_id');
  my $group_id = $self->param('group_id');

  my $self->db->prepare('INSERT INTO node_group (node_id, group_id) VALUES(?, ?)');
  $sth->execute($node_id, $group_id);

  return $self->render(json => {status => 'ok'});
}

sub del_group {
  my $self = shift;
  my $id = $self->param('id');

  my $sth = $self->db->prepare("DELETE FROM node_group WHERE group_id=?");
  $sth->execute($id);
  my $nodes_affected = $sth->fetch()->[0];

  $sth = $self->db->prepare("DELETE FROM groups WHERE id=?");
  $sth->execute($id);
  my $groups_affected = $sth->fetch()->[0];

  return $self->render(json => {status => 'ok', nodes_affected => $nodes_affected, groups_affected => $groups_affected});
}

1;
