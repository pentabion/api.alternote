create table nodes {
  id bigint not null primary key,
  name char(30),
  comment varchar(255),
  is_active boolean not null,
  config text
}

create table statuses {
  id tinyint,
  code char(10),
  comment varchar(255)
}

0 inactive
1 failed
2 active
3 done
4 canceled

create table jobs {
  id primary key,
  node_id bigint not null,
  job_status tinyint,
}

create table job_history {
  id long primary key,
  job_id,
  datetime,
  was_status
}

create table groups {
  id long primary key,
  name char(30),
  comment varchar(255)
}

create table node_group {
  id long primary key,
  node_id,
  group_id
}
