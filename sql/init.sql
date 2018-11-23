DROP TABLE IF EXISTS `nodes`;
CREATE TABLE `nodes` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` CHAR(30) NOT NULL,
  `comment` VARCHAR(255) DEFAULT NULL,
  `is_active` TINYINT NOT NULL DEFAULT 0,
  `config` text
) ENGINE=MyISAM;

DROP TABLE `groups`;
CREATE TABLE `groups` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` CHAR(30) NOT NULL,
  `comment` VARCHAR(255) DEFAULT NULL
) ENGINE=MyISAM;

DROP TABLE `node_group`;
CREATE TABLE `node_group` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `node_id` INT UNSIGNED NOT NULL,
  `group_id` INT UNSIGNED NOT NULL
) ENGINE=MyISAM;

/*

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
*/
