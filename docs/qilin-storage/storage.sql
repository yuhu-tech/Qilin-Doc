CREATE TABLE `folder` (
  `id` varchar(50) PRIMARY KEY,
  `parent_id` varchar(50) COMMENT '父级文件夹ID, 根目录此字端为空',
  `name` varchar(255) COMMENT '文件夹名称',
  `path` varchar(255) NOT NULL COMMENT '文件夹全路径 eg. /tid-yuhu/1000201022/',
  `digest` varchar(255) NOT NULL COMMENT '文件夹摘要 = hash(id)',
  `owner_id` varchar(50) COMMENT '文件夹所属用户id',
  `tenant_id` varchar(50) COMMENT '文件夹所属用户id',
  `group_id` varchar(50) COMMENT '文件夹所属组id',
  `created_at` datetime DEFAULT (now()),
  `update_at` datetime DEFAULT (now())
);

CREATE TABLE `file` (
  `id` varchar(50) PRIMARY KEY,
  `folder_id` varchar(50) COMMENT '文件夹id',
  `folder_digest` varchar(255) COMMENT '需上链，不能修改',
  `name` varchar(50) COMMENT '文件名 需上链，不能修改',
  `content_digest` varchar(255) COMMENT '文件摘要 需上链，不能修改',
  `path` varchar(255) NOT NULL COMMENT '文件全路径 eg. /tid-yuhu/1000201022/0.jpg',
  `owner_id` varchar(50) COMMENT '文件夹所属用户id',
  `tenant_id` varchar(50) COMMENT '文件夹所属用户id',
  `group_id` varchar(50) COMMENT '文件夹所属组id',
  `tx_hash` varchar(100),
  `status` varchar(50) COMMENT 'wait_build,builded,succeed,failed;',
  `created_at` datetime DEFAULT (now()),
  `update_at` datetime DEFAULT (now())
);

CREATE TABLE `file_storage` (
  `id` varchar(50) PRIMARY KEY,
  `storage_type` varchar(50) COMMENT 'eg. oss',
  `file_type` varchar(50) COMMENT 'mime type',
  `size_bytes` bigint COMMENT 'bytes',
  `path` varchar(255) NOT NULL COMMENT 'eg. /storage/1/5/0.jpg',
  `content_digest` varchar(255)
);

ALTER TABLE `file` ADD FOREIGN KEY (`folder_digest`) REFERENCES `folder` (`digest`);

ALTER TABLE `file` ADD FOREIGN KEY (`folder_id`) REFERENCES `folder` (`id`);

ALTER TABLE `file` ADD FOREIGN KEY (`content_digest`) REFERENCES `file_storage` (`content_digest`);

CREATE UNIQUE INDEX `idx_file_path` ON `folder` (`path`);

CREATE UNIQUE INDEX `idx_floder_content` ON `folder` (`parent_id`, `name`);

CREATE INDEX `idx_folder_digest` ON `folder` (`digest`);

CREATE UNIQUE INDEX `idx_file_path` ON `file` (`path`);

CREATE UNIQUE INDEX `idx_floder_content` ON `file` (`folder_digest`, `name`);

CREATE INDEX `idx_file_content_digest` ON `file` (`content_digest`);

CREATE INDEX `idx_file_status` ON `file` (`status`);

CREATE UNIQUE INDEX `file_storage_index_7` ON `file_storage` (`path`);

CREATE UNIQUE INDEX `file_storage_index_8` ON `file_storage` (`content_digest`);

ALTER TABLE `folder` COMMENT = 'table \'floder\' contains floder information';

ALTER TABLE `file` COMMENT = 'table \'file\' contains file information';
