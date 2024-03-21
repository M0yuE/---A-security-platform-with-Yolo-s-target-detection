/*
Navicat MySQL Data Transfer

Source Server         : navicat
Source Server Version : 50728
Source Host           : localhost:3306
Source Database       : wisdom_security

Target Server Type    : MYSQL
Target Server Version : 50728
File Encoding         : 65001

Date: 2021-09-25 10:15:26
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `BLOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `SCHED_NAME` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `CALENDAR_NAME` varchar(200) NOT NULL,
  `CALENDAR` blob NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`CALENDAR_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `CRON_EXPRESSION` varchar(120) NOT NULL,
  `TIME_ZONE_ID` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `ENTRY_ID` varchar(95) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `INSTANCE_NAME` varchar(200) NOT NULL,
  `FIRED_TIME` bigint(13) NOT NULL,
  `SCHED_TIME` bigint(13) NOT NULL,
  `PRIORITY` int(11) NOT NULL,
  `STATE` varchar(16) NOT NULL,
  `JOB_NAME` varchar(200) DEFAULT NULL,
  `JOB_GROUP` varchar(200) DEFAULT NULL,
  `IS_NONCONCURRENT` varchar(1) DEFAULT NULL,
  `REQUESTS_RECOVERY` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`SCHED_NAME`,`ENTRY_ID`),
  KEY `IDX_QRTZ_FT_TRIG_INST_NAME` (`SCHED_NAME`,`INSTANCE_NAME`),
  KEY `IDX_QRTZ_FT_INST_JOB_REQ_RCVRY` (`SCHED_NAME`,`INSTANCE_NAME`,`REQUESTS_RECOVERY`),
  KEY `IDX_QRTZ_FT_J_G` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_FT_JG` (`SCHED_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_FT_T_G` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_QRTZ_FT_TG` (`SCHED_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `JOB_NAME` varchar(200) NOT NULL,
  `JOB_GROUP` varchar(200) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `JOB_CLASS_NAME` varchar(250) NOT NULL,
  `IS_DURABLE` varchar(1) NOT NULL,
  `IS_NONCONCURRENT` varchar(1) NOT NULL,
  `IS_UPDATE_DATA` varchar(1) NOT NULL,
  `REQUESTS_RECOVERY` varchar(1) NOT NULL,
  `JOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_J_REQ_RECOVERY` (`SCHED_NAME`,`REQUESTS_RECOVERY`),
  KEY `IDX_QRTZ_J_GRP` (`SCHED_NAME`,`JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `LOCK_NAME` varchar(40) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`LOCK_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------
INSERT INTO `qrtz_locks` VALUES ('RenrenScheduler', 'STATE_ACCESS');

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `INSTANCE_NAME` varchar(200) NOT NULL,
  `LAST_CHECKIN_TIME` bigint(13) NOT NULL,
  `CHECKIN_INTERVAL` bigint(13) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`INSTANCE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------
INSERT INTO `qrtz_scheduler_state` VALUES ('RenrenScheduler', 'SC-2018121714111570518430640', '1570518479735', '15000');

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `REPEAT_COUNT` bigint(7) NOT NULL,
  `REPEAT_INTERVAL` bigint(12) NOT NULL,
  `TIMES_TRIGGERED` bigint(10) NOT NULL,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `qrtz_triggers` (`SCHED_NAME`, `TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers` (
  `SCHED_NAME` varchar(120) NOT NULL,
  `TRIGGER_NAME` varchar(200) NOT NULL,
  `TRIGGER_GROUP` varchar(200) NOT NULL,
  `JOB_NAME` varchar(200) NOT NULL,
  `JOB_GROUP` varchar(200) NOT NULL,
  `DESCRIPTION` varchar(250) DEFAULT NULL,
  `NEXT_FIRE_TIME` bigint(13) DEFAULT NULL,
  `PREV_FIRE_TIME` bigint(13) DEFAULT NULL,
  `PRIORITY` int(11) DEFAULT NULL,
  `TRIGGER_STATE` varchar(16) NOT NULL,
  `TRIGGER_TYPE` varchar(8) NOT NULL,
  `START_TIME` bigint(13) NOT NULL,
  `END_TIME` bigint(13) DEFAULT NULL,
  `CALENDAR_NAME` varchar(200) DEFAULT NULL,
  `MISFIRE_INSTR` smallint(2) DEFAULT NULL,
  `JOB_DATA` blob,
  PRIMARY KEY (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_QRTZ_T_J` (`SCHED_NAME`,`JOB_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_T_JG` (`SCHED_NAME`,`JOB_GROUP`),
  KEY `IDX_QRTZ_T_C` (`SCHED_NAME`,`CALENDAR_NAME`),
  KEY `IDX_QRTZ_T_G` (`SCHED_NAME`,`TRIGGER_GROUP`),
  KEY `IDX_QRTZ_T_STATE` (`SCHED_NAME`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_N_STATE` (`SCHED_NAME`,`TRIGGER_NAME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_N_G_STATE` (`SCHED_NAME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_NEXT_FIRE_TIME` (`SCHED_NAME`,`NEXT_FIRE_TIME`),
  KEY `IDX_QRTZ_T_NFT_ST` (`SCHED_NAME`,`TRIGGER_STATE`,`NEXT_FIRE_TIME`),
  KEY `IDX_QRTZ_T_NFT_MISFIRE` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`),
  KEY `IDX_QRTZ_T_NFT_ST_MISFIRE` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`,`TRIGGER_STATE`),
  KEY `IDX_QRTZ_T_NFT_ST_MISFIRE_GRP` (`SCHED_NAME`,`MISFIRE_INSTR`,`NEXT_FIRE_TIME`,`TRIGGER_GROUP`,`TRIGGER_STATE`),
  CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`) REFERENCES `qrtz_job_details` (`SCHED_NAME`, `JOB_NAME`, `JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------

-- ----------------------------
-- Table structure for schedule_job
-- ----------------------------
DROP TABLE IF EXISTS `schedule_job`;
CREATE TABLE `schedule_job` (
  `job_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务id',
  `bean_name` varchar(200) DEFAULT NULL COMMENT 'spring bean名称',
  `params` varchar(2000) DEFAULT NULL COMMENT '参数',
  `cron_expression` varchar(100) DEFAULT NULL COMMENT 'cron表达式',
  `status` tinyint(4) DEFAULT NULL COMMENT '任务状态  0：正常  1：暂停',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`job_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8 COMMENT='定时任务';

-- ----------------------------
-- Records of schedule_job
-- ----------------------------
INSERT INTO `schedule_job` VALUES ('25', '2222', '33', '333', '0', '33', '2019-11-27 16:41:30');
INSERT INTO `schedule_job` VALUES ('26', 'ww', 'www', 'www', null, 'www', '2019-11-27 16:53:38');
INSERT INTO `schedule_job` VALUES ('27', '333', '333', '33', null, '333', '2019-11-27 17:05:30');
INSERT INTO `schedule_job` VALUES ('28', 'ww', 'www', 'www', null, 'ww', '2019-11-27 17:12:29');
INSERT INTO `schedule_job` VALUES ('29', '22', '222', '222', null, '22', '2019-11-27 17:15:54');
INSERT INTO `schedule_job` VALUES ('30', '1', '1', '1', null, '1', '2019-11-27 17:16:06');
INSERT INTO `schedule_job` VALUES ('31', '1', '4444', '444', null, '44', '2019-11-27 18:07:14');

-- ----------------------------
-- Table structure for schedule_job_log
-- ----------------------------
DROP TABLE IF EXISTS `schedule_job_log`;
CREATE TABLE `schedule_job_log` (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务日志id',
  `job_id` bigint(20) NOT NULL COMMENT '任务id',
  `bean_name` varchar(200) DEFAULT NULL COMMENT 'spring bean名称',
  `params` varchar(2000) DEFAULT NULL COMMENT '参数',
  `status` tinyint(4) NOT NULL COMMENT '任务状态    0：成功    1：失败',
  `error` varchar(2000) DEFAULT NULL COMMENT '失败信息',
  `times` int(11) NOT NULL COMMENT '耗时(单位：毫秒)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`log_id`),
  KEY `job_id` (`job_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='定时任务日志';

-- ----------------------------
-- Records of schedule_job_log
-- ----------------------------
INSERT INTO `schedule_job_log` VALUES ('1', '33', '33', '33', '1', '33', '33', '2019-11-26 17:47:15');

-- ----------------------------
-- Table structure for sec_connect
-- ----------------------------
DROP TABLE IF EXISTS `sec_connect`;
CREATE TABLE `sec_connect` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `port` int(11) DEFAULT NULL COMMENT '端口',
  `type` int(11) NOT NULL DEFAULT '1' COMMENT '1TCP,2UDP',
  `single` int(11) NOT NULL DEFAULT '0' COMMENT '单连接',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COMMENT='连接表';

-- ----------------------------
-- Records of sec_connect
-- ----------------------------
INSERT INTO `sec_connect` VALUES ('10', '安防平台接口', '4567', '1', '0', '2021-02-18 01:31:16');
INSERT INTO `sec_connect` VALUES ('11', 'test', '9999', '1', '0', '2021-03-25 13:41:52');
INSERT INTO `sec_connect` VALUES ('12', '测试单连接', '8999', '1', '1', '2021-04-01 13:35:53');
INSERT INTO `sec_connect` VALUES ('13', '8266LED演示例子', '3308', '1', '0', '2021-05-12 17:34:13');
INSERT INTO `sec_connect` VALUES ('14', '综合控制设备', '3309', '1', '0', '2021-05-19 20:21:30');

-- ----------------------------
-- Table structure for sec_connect_modular
-- ----------------------------
DROP TABLE IF EXISTS `sec_connect_modular`;
CREATE TABLE `sec_connect_modular` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL COMMENT '模块名称',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注',
  `connect_id` int(11) DEFAULT NULL COMMENT '连接id',
  `query_interval` int(11) NOT NULL DEFAULT '2000' COMMENT '查询间隔',
  `instruct_interval` int(11) NOT NULL DEFAULT '1000' COMMENT '指令间隔',
  `verify` varchar(50) DEFAULT NULL COMMENT '校验字符串',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COMMENT='通讯模块';

-- ----------------------------
-- Records of sec_connect_modular
-- ----------------------------
INSERT INTO `sec_connect_modular` VALUES ('4', 'Esp8266 12F', null, '10', '4000', '1000', 'aabb');
INSERT INTO `sec_connect_modular` VALUES ('5', '第二个模块', '这是备注', '10', '4000', '1000', 'uiyo');
INSERT INTO `sec_connect_modular` VALUES ('7', '单连接模块', 'test单连接模块', '12', '1000', '1000', null);
INSERT INTO `sec_connect_modular` VALUES ('8', '8266LED模块', null, '13', '1000', '1000', 'abcd');
INSERT INTO `sec_connect_modular` VALUES ('9', '综合模块(板子)', null, '14', '1000', '1000', 'aabc');
INSERT INTO `sec_connect_modular` VALUES ('10', '综合模块(组合)', null, '14', '1000', '1000', 'aabd');

-- ----------------------------
-- Table structure for sec_data
-- ----------------------------
DROP TABLE IF EXISTS `sec_data`;
CREATE TABLE `sec_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `instruct_id` int(11) DEFAULT NULL COMMENT '指令id',
  `cache_time` int(11) NOT NULL DEFAULT '0' COMMENT '缓存时长ms(0为永久保存)',
  `start` int(11) DEFAULT NULL COMMENT '数据起始位',
  `length` int(11) DEFAULT NULL COMMENT '数据长度',
  `high_low_convert` int(11) NOT NULL DEFAULT '0' COMMENT '高低位转换0不转换1转换',
  `convert_to` int(11) NOT NULL DEFAULT '1' COMMENT '1整数2浮点数3二进制',
  `cut` int(11) NOT NULL DEFAULT '0' COMMENT '数据切割0否1是',
  `cut_start` int(11) DEFAULT NULL COMMENT '切割起始',
  `cut_length` int(11) DEFAULT NULL COMMENT '切割长度',
  `data_warn` int(11) NOT NULL DEFAULT '0' COMMENT '数据预警0不预警1预警',
  `warn_option` int(11) NOT NULL DEFAULT '1' COMMENT '1等于2大于等于3小于等于',
  `warn_type` varchar(50) NOT NULL DEFAULT '1' COMMENT '预警方式多选逗号隔开1平台弹框2APP推送',
  `warn_value` varchar(50) DEFAULT NULL COMMENT '预警值',
  `bind_data` int(11) DEFAULT NULL COMMENT '绑定数据项值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8 COMMENT='数据解析';

-- ----------------------------
-- Records of sec_data
-- ----------------------------
INSERT INTO `sec_data` VALUES ('7', '红外状态', '7', '0', '4', '2', '0', '3', '1', '7', '1', '0', '1', '1', '2', null);
INSERT INTO `sec_data` VALUES ('8', '测试项', '7', '0', '4', '2', '0', '3', '1', '6', '1', '1', '1', '1,2', '1', null);
INSERT INTO `sec_data` VALUES ('9', 'test', '10', '0', '4', '2', '0', '1', '0', null, null, '0', '1', '1', null, null);
INSERT INTO `sec_data` VALUES ('10', '测试关联项', '9', '0', '4', '2', '0', '1', '0', null, null, '0', '1', '1', null, '9');
INSERT INTO `sec_data` VALUES ('11', '灯状态', '11', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, null);
INSERT INTO `sec_data` VALUES ('12', '关灯解析', '13', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, '11');
INSERT INTO `sec_data` VALUES ('13', '开灯解析', '12', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, '11');
INSERT INTO `sec_data` VALUES ('14', '温度值', '14', '0', '4', '8', '0', '2', '0', null, null, '0', '1', '1', null, null);
INSERT INTO `sec_data` VALUES ('15', '红灯开', '15', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, '16');
INSERT INTO `sec_data` VALUES ('16', '红灯状态', '16', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, null);
INSERT INTO `sec_data` VALUES ('17', '红灯关', '17', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, '16');
INSERT INTO `sec_data` VALUES ('18', '绿灯状态', '18', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, null);
INSERT INTO `sec_data` VALUES ('19', '绿灯开', '19', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, '18');
INSERT INTO `sec_data` VALUES ('20', '绿灯关', '20', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, '18');
INSERT INTO `sec_data` VALUES ('21', '蓝灯状态', '21', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, null);
INSERT INTO `sec_data` VALUES ('22', '蓝灯开', '22', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, '21');
INSERT INTO `sec_data` VALUES ('23', '蓝灯关', '23', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, '21');
INSERT INTO `sec_data` VALUES ('24', '温度值', '24', '0', '4', '8', '0', '2', '0', null, null, '0', '1', '1', null, null);
INSERT INTO `sec_data` VALUES ('25', '继电器状态', '25', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, null);
INSERT INTO `sec_data` VALUES ('26', '继电器开', '26', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, '25');
INSERT INTO `sec_data` VALUES ('27', '继电器关', '27', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, '25');
INSERT INTO `sec_data` VALUES ('28', '红灯开', '28', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, '16');
INSERT INTO `sec_data` VALUES ('29', '红灯状态', '29', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, null);
INSERT INTO `sec_data` VALUES ('30', '红灯关', '30', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, '16');
INSERT INTO `sec_data` VALUES ('31', '绿灯状态', '31', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, null);
INSERT INTO `sec_data` VALUES ('32', '绿灯开', '32', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, '18');
INSERT INTO `sec_data` VALUES ('33', '绿灯关', '33', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, '18');
INSERT INTO `sec_data` VALUES ('34', '蓝灯状态', '34', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, null);
INSERT INTO `sec_data` VALUES ('35', '蓝灯开', '35', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, '21');
INSERT INTO `sec_data` VALUES ('36', '蓝灯关', '36', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, '21');
INSERT INTO `sec_data` VALUES ('37', '温度值', '37', '0', '4', '8', '0', '2', '0', null, null, '0', '1', '1', null, null);
INSERT INTO `sec_data` VALUES ('38', '继电器关', '39', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, '25');
INSERT INTO `sec_data` VALUES ('39', '继电器开', '40', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, '25');
INSERT INTO `sec_data` VALUES ('40', '继电器状态', '38', '0', '5', '1', '0', '1', '0', null, null, '0', '1', '1', null, null);

-- ----------------------------
-- Table structure for sec_equipment
-- ----------------------------
DROP TABLE IF EXISTS `sec_equipment`;
CREATE TABLE `sec_equipment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `modular_id` int(11) DEFAULT NULL COMMENT '模块id',
  `name` varchar(50) DEFAULT NULL COMMENT '设备名称',
  `remark` varchar(50) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='设备表';

-- ----------------------------
-- Records of sec_equipment
-- ----------------------------
INSERT INTO `sec_equipment` VALUES ('6', '4', '人体红外', null);
INSERT INTO `sec_equipment` VALUES ('7', '5', '第二个模块的设备', '第二个模块');
INSERT INTO `sec_equipment` VALUES ('8', '7', '红外设备', '红外设备');
INSERT INTO `sec_equipment` VALUES ('9', '8', 'LED灯', null);
INSERT INTO `sec_equipment` VALUES ('10', '8', '温度模块', '温度模块');
INSERT INTO `sec_equipment` VALUES ('11', '9', 'LED灯', null);
INSERT INTO `sec_equipment` VALUES ('12', '9', '温度模块', null);
INSERT INTO `sec_equipment` VALUES ('13', '9', '继电器模块', null);
INSERT INTO `sec_equipment` VALUES ('14', '10', 'LED灯', null);
INSERT INTO `sec_equipment` VALUES ('15', '10', '温度模块', null);
INSERT INTO `sec_equipment` VALUES ('16', '10', '继电器模块', null);

-- ----------------------------
-- Table structure for sec_instruct
-- ----------------------------
DROP TABLE IF EXISTS `sec_instruct`;
CREATE TABLE `sec_instruct` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `equipment_id` int(11) DEFAULT NULL COMMENT '设备id',
  `name` varchar(50) DEFAULT NULL,
  `type` int(11) DEFAULT '0' COMMENT '0状态指令1动作指令',
  `instruct` varchar(50) DEFAULT NULL COMMENT '指令',
  `ret_example` varchar(50) DEFAULT NULL COMMENT '返回示例',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8 COMMENT='设备指令';

-- ----------------------------
-- Records of sec_instruct
-- ----------------------------
INSERT INTO `sec_instruct` VALUES ('7', '6', '红外状态', '0', '000200aaaa', '000201aaaa');
INSERT INTO `sec_instruct` VALUES ('8', '6', '测试指令', '0', '00012254aabb', '00012254aabb');
INSERT INTO `sec_instruct` VALUES ('9', '8', '测试指令', '1', '0102035565', '0102035565');
INSERT INTO `sec_instruct` VALUES ('10', '8', '名称0102035565ss', '0', '0104035565', '0104035565');
INSERT INTO `sec_instruct` VALUES ('11', '9', '查询灯的状态', '0', '000100aaaa', '000101aaaa');
INSERT INTO `sec_instruct` VALUES ('12', '9', '开灯', '1', '000201aaaa', '000201aaaa');
INSERT INTO `sec_instruct` VALUES ('13', '9', '关灯', '1', '000200aaaa', '000200aaaa');
INSERT INTO `sec_instruct` VALUES ('14', '10', '温度读取', '0', '000300aaaa', '000300000000aaaa');
INSERT INTO `sec_instruct` VALUES ('15', '11', '红灯开', '1', '000001aaaa', '000001aaaa');
INSERT INTO `sec_instruct` VALUES ('16', '11', '红灯查询', '0', '000300aaaa', '000301aaaa');
INSERT INTO `sec_instruct` VALUES ('17', '11', '红灯关', '1', '000000aaaa', '000000aaaa');
INSERT INTO `sec_instruct` VALUES ('18', '11', '绿灯查询', '0', '000400aaaa', '000401aaaa');
INSERT INTO `sec_instruct` VALUES ('19', '11', '绿灯开', '1', '000101aaaa', '000101aaaa');
INSERT INTO `sec_instruct` VALUES ('20', '11', '绿灯关', '1', '000100aaaa', '000100aaaa');
INSERT INTO `sec_instruct` VALUES ('21', '11', '蓝灯查询', '0', '000500aaaa', '000501aaaa');
INSERT INTO `sec_instruct` VALUES ('22', '11', '蓝灯开', '1', '000201aaaa', '000201aaaa');
INSERT INTO `sec_instruct` VALUES ('23', '11', '蓝灯关', '1', '000200aaaa', '000200aaaa');
INSERT INTO `sec_instruct` VALUES ('24', '12', '温度查询', '0', '000600aaaa', '000600000000aaaa');
INSERT INTO `sec_instruct` VALUES ('25', '13', '继电器查询', '0', '000800aaaa', '000801aaaa');
INSERT INTO `sec_instruct` VALUES ('26', '13', '继电器开', '1', '000701aaaa', '000701aaaa');
INSERT INTO `sec_instruct` VALUES ('27', '13', '继电器关', '1', '000700aaaa', '000700aaaa');
INSERT INTO `sec_instruct` VALUES ('28', '14', '红灯开', '1', '000001aaaa', '000001aaaa');
INSERT INTO `sec_instruct` VALUES ('29', '14', '红灯查询', '0', '000300aaaa', '000301aaaa');
INSERT INTO `sec_instruct` VALUES ('30', '14', '红灯关', '1', '000000aaaa', '000000aaaa');
INSERT INTO `sec_instruct` VALUES ('31', '14', '绿灯查询', '0', '000400aaaa', '000401aaaa');
INSERT INTO `sec_instruct` VALUES ('32', '14', '绿灯开', '1', '000101aaaa', '000101aaaa');
INSERT INTO `sec_instruct` VALUES ('33', '14', '绿灯关', '1', '000100aaaa', '000100aaaa');
INSERT INTO `sec_instruct` VALUES ('34', '14', '蓝灯查询', '0', '000500aaaa', '000501aaaa');
INSERT INTO `sec_instruct` VALUES ('35', '14', '蓝灯开', '1', '000201aaaa', '000201aaaa');
INSERT INTO `sec_instruct` VALUES ('36', '14', '蓝灯关', '1', '000200aaaa', '000200aaaa');
INSERT INTO `sec_instruct` VALUES ('37', '15', '温度查询', '0', '000600aaaa', '000600000000aaaa');
INSERT INTO `sec_instruct` VALUES ('38', '16', '继电器查询', '0', '000800aaaa', '000801aaaa');
INSERT INTO `sec_instruct` VALUES ('39', '16', '继电器开', '1', '000701aaaa', '000701aaaa');
INSERT INTO `sec_instruct` VALUES ('40', '16', '继电器关', '1', '000700aaaa', '000700aaaa');

-- ----------------------------
-- Table structure for sec_warn_msg
-- ----------------------------
DROP TABLE IF EXISTS `sec_warn_msg`;
CREATE TABLE `sec_warn_msg` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `msg` varchar(50) DEFAULT NULL COMMENT '消息',
  `data_id` int(11) DEFAULT NULL COMMENT '数据项id',
  `warn_data` varchar(50) DEFAULT NULL COMMENT '警告值',
  `is_read` int(11) NOT NULL DEFAULT '0' COMMENT '是否已读0未读1已读',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='警告消息表';

-- ----------------------------
-- Records of sec_warn_msg
-- ----------------------------
INSERT INTO `sec_warn_msg` VALUES ('1', '人体红外设备的测试项数据值等于预警值[1]当前值为[1]', '8', '1', '0', '2021-03-27 14:51:50');
INSERT INTO `sec_warn_msg` VALUES ('2', '外部雷达设备的测试项数据值等于预警值[1]当前值为[1]', '8', '1', '1', '2021-03-27 15:52:59');
INSERT INTO `sec_warn_msg` VALUES ('3', '人体红外设备的测试项数据值等于预警值[1]当前值为[1]', '8', '1', '1', '2021-04-01 17:19:01');
INSERT INTO `sec_warn_msg` VALUES ('4', '人体红外设备的测试项数据值等于预警值[1]当前值为[1]', '8', '1', '0', '2021-09-23 18:29:25');
INSERT INTO `sec_warn_msg` VALUES ('5', '预警灯光设备的测试项数据值等于预警值[1]当前值为[1]', '8', '1', '0', '2021-09-23 18:31:19');
INSERT INTO `sec_warn_msg` VALUES ('6', 'ESP8266设备的测试项数据值等于预警值[1]当前值为[1]', '8', '1', '0', '2021-09-23 18:31:45');
INSERT INTO `sec_warn_msg` VALUES ('7', 'ESP32设备的测试项数据值等于预警值[1]当前值为[1]', '8', '1', '0', '2021-09-23 18:32:18');
INSERT INTO `sec_warn_msg` VALUES ('8', '树莓派设备的测试项数据值等于预警值[1]当前值为[1]', '8', '1', '0', '2021-09-23 18:33:14');

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `param_key` varchar(50) DEFAULT NULL COMMENT 'key',
  `param_value` varchar(2000) DEFAULT NULL COMMENT 'value',
  `status` tinyint(4) DEFAULT '1' COMMENT '状态   0：隐藏   1：显示',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `param_key` (`param_key`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='系统配置信息表';

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES ('1', 'CLOUD_STORAGE_CONFIG_KEY', '测试1', '1', '云存储配置信息');
INSERT INTO `sys_config` VALUES ('3', '测试1', '测试1', '1', '测试用例');
INSERT INTO `sys_config` VALUES ('6', '测试已越过', 'dawd', '1', 'dwadwad');
INSERT INTO `sys_config` VALUES ('7', 'tes', '424', '1', '4234');
INSERT INTO `sys_config` VALUES ('8', '542523', '2423', '1', '4234234');

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '字典名称',
  `type` varchar(100) NOT NULL COMMENT '字典类型',
  `code` varchar(100) NOT NULL COMMENT '字典码',
  `value` varchar(1000) NOT NULL COMMENT '字典值',
  `order_num` int(11) DEFAULT '0' COMMENT '排序',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `del_flag` tinyint(4) DEFAULT '0' COMMENT '删除标记  -1：已删除  0：正常',
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`,`code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='数据字典表';

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
INSERT INTO `sys_dict` VALUES ('1', '性别', 'sex', '6', '女', '12', '的官方认定事故绕过热狗热', '0');
INSERT INTO `sys_dict` VALUES ('2', '性别', 'sex', '1', '男', '1', '3543', '0');

-- ----------------------------
-- Table structure for sys_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL COMMENT '用户名',
  `operation` varchar(50) DEFAULT NULL COMMENT '用户操作',
  `method` varchar(200) DEFAULT NULL COMMENT '请求方法',
  `params` varchar(5000) DEFAULT NULL COMMENT '请求参数',
  `time` bigint(20) NOT NULL COMMENT '执行时长(毫秒)',
  `ip` varchar(64) DEFAULT NULL COMMENT 'IP地址',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=960 DEFAULT CHARSET=utf8 COMMENT='系统日志';

-- ----------------------------
-- Records of sys_log
-- ----------------------------
INSERT INTO `sys_log` VALUES ('307', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":102,\"name\":\"微信设置\",\"parentId\":0,\"perms\":\"wx\",\"type\":1}', '70', '192.168.5.234', '2020-03-06 14:02:21');
INSERT INTO `sys_log` VALUES ('308', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":103,\"name\":\"公众号菜单\",\"parentId\":102,\"perms\":\"wx.menu\",\"type\":2}', '46', '192.168.5.234', '2020-03-06 14:02:43');
INSERT INTO `sys_log` VALUES ('309', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":104,\"name\":\"测试\",\"parentId\":102,\"perms\":\"wx.test\",\"type\":2}', '30', '192.168.5.234', '2020-03-06 14:03:01');
INSERT INTO `sys_log` VALUES ('310', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":105,\"name\":\"富文本插件\",\"parentId\":102,\"perms\":\"wx.test\",\"type\":2}', '29', '192.168.5.234', '2020-03-06 14:03:29');
INSERT INTO `sys_log` VALUES ('311', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":108,\"name\":\"商品设置\",\"parentId\":0,\"perms\":\"product\",\"type\":1}', '64', '127.0.0.1', '2020-04-23 16:19:48');
INSERT INTO `sys_log` VALUES ('312', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":109,\"name\":\"类目管理\",\"parentId\":108,\"perms\":\"product.category\",\"type\":2}', '29', '127.0.0.1', '2020-04-23 16:20:24');
INSERT INTO `sys_log` VALUES ('313', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":110,\"name\":\"商品管理\",\"parentId\":108,\"perms\":\"product.goods\",\"type\":2}', '20', '127.0.0.1', '2020-04-23 16:20:53');
INSERT INTO `sys_log` VALUES ('314', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":111,\"name\":\"查看\",\"parentId\":109,\"perms\":\"shop.category.list\",\"type\":3}', '183', '192.168.5.234', '2020-04-24 14:43:05');
INSERT INTO `sys_log` VALUES ('315', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[57,58,59,60,61,62,63,65,66,67,68,64,69,70,71,72,73,78,79,80,81,74,76,77,82,83,84,85,86,87,88,89,90,91,92,93,108,109,111,110],\"remark\":\"超级管理员角色666\",\"roleId\":1,\"roleName\":\"超级管理员\"}', '1241', '192.168.5.234', '2020-04-24 14:51:21');
INSERT INTO `sys_log` VALUES ('316', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":109,\"name\":\"类目管理\",\"parentId\":108,\"perms\":\"shop.category\",\"type\":2}', '134', '192.168.5.234', '2020-04-24 14:55:28');
INSERT INTO `sys_log` VALUES ('317', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":110,\"name\":\"商品管理\",\"parentId\":108,\"perms\":\"shop.goods\",\"type\":2}', '18', '192.168.5.234', '2020-04-24 14:55:35');
INSERT INTO `sys_log` VALUES ('318', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":112,\"name\":\"新增修改\",\"parentId\":109,\"perms\":\"shop.category.addOrUpdate\",\"type\":3}', '28', '192.168.5.234', '2020-04-24 15:26:25');
INSERT INTO `sys_log` VALUES ('319', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[57,58,59,60,61,62,63,65,66,67,68,64,69,70,71,72,73,78,79,80,81,74,76,77,82,83,84,85,86,87,88,89,90,91,92,93,108,109,111,110],\"remark\":\"超级管理员角色666\",\"roleId\":1,\"roleName\":\"超级管理员\"}', '1713', '192.168.5.234', '2020-04-24 15:26:40');
INSERT INTO `sys_log` VALUES ('320', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"createTime\":1588141507983,\"menuIdList\":[102,103,104,105,106,107],\"remark\":\"admin\",\"roleId\":6,\"roleName\":\"测试\"}', '427', '192.168.5.234', '2020-04-29 14:25:08');
INSERT INTO `sys_log` VALUES ('321', 'admin', '删除配置', 'com.antd.modules.sys.controller.SysConfigController.delete()', '[5]', '40', '192.168.5.234', '2020-04-29 14:26:16');
INSERT INTO `sys_log` VALUES ('322', 'admin', '保存配置', 'com.antd.modules.sys.controller.SysConfigController.save()', '{\"id\":6,\"paramKey\":\"测试已越过\",\"paramValue\":\"dawd\",\"remark\":\"dwadwad\"}', '47', '192.168.5.234', '2020-04-29 14:32:14');
INSERT INTO `sys_log` VALUES ('323', 'admin', '删除配置', 'com.antd.modules.sys.controller.SysConfigController.delete()', '[4]', '51', '192.168.5.234', '2020-04-29 14:32:20');
INSERT INTO `sys_log` VALUES ('324', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":113,\"name\":\"类目属性管理\",\"parentId\":108,\"perms\":\"shop.categoryAttr\",\"type\":2}', '961', '192.168.5.234', '2020-05-06 14:06:36');
INSERT INTO `sys_log` VALUES ('325', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":114,\"name\":\"店铺中心\",\"parentId\":0,\"perms\":\"store\",\"type\":1}', '97', '192.168.1.99', '2020-08-10 16:54:33');
INSERT INTO `sys_log` VALUES ('326', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":115,\"name\":\"店铺管理\",\"parentId\":114,\"perms\":\"store.manager\",\"type\":2}', '23', '192.168.1.99', '2020-08-10 16:55:00');
INSERT INTO `sys_log` VALUES ('327', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":116,\"name\":\"增改\",\"parentId\":115,\"perms\":\"store.manager.saveOrUpdate\",\"type\":3}', '17', '192.168.1.99', '2020-08-10 16:55:40');
INSERT INTO `sys_log` VALUES ('328', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":117,\"name\":\"删除\",\"parentId\":115,\"perms\":\"store.manager.delete\",\"type\":3}', '17', '192.168.1.99', '2020-08-10 16:56:06');
INSERT INTO `sys_log` VALUES ('329', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":118,\"name\":\"查看\",\"parentId\":115,\"perms\":\"store.manager.list\",\"type\":3}', '21', '192.168.1.99', '2020-08-10 16:56:28');
INSERT INTO `sys_log` VALUES ('330', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":119,\"name\":\"素材管理\",\"parentId\":114,\"perms\":\"store.source\",\"type\":2}', '17', '192.168.1.99', '2020-08-10 16:56:52');
INSERT INTO `sys_log` VALUES ('331', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":120,\"name\":\"增改\",\"parentId\":119,\"perms\":\"store.source.saveOrUpdate\",\"type\":3}', '17', '192.168.1.99', '2020-08-10 16:57:27');
INSERT INTO `sys_log` VALUES ('332', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":121,\"name\":\"删除\",\"parentId\":119,\"perms\":\"store.source.delete\",\"type\":3}', '14', '192.168.1.99', '2020-08-10 16:57:57');
INSERT INTO `sys_log` VALUES ('333', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":122,\"name\":\"查看\",\"parentId\":119,\"perms\":\"store.source.list\",\"type\":3}', '18', '192.168.1.99', '2020-08-10 16:58:28');
INSERT INTO `sys_log` VALUES ('334', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[57,58,59,60,61,62,63,65,66,67,68,64,69,70,71,72,73,78,79,80,81,74,76,77,82,83,84,85,86,87,88,89,90,91,92,93,108,109,111,112,110,113,114,115,116,117,118,119,120,121,122],\"remark\":\"超级管理员角色666\",\"roleId\":1,\"roleName\":\"超级管理员\"}', '868', '192.168.1.99', '2020-08-10 16:59:20');
INSERT INTO `sys_log` VALUES ('335', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[63],\"remark\":\"测试管理员\",\"roleId\":4,\"roleName\":\"店铺管理员\"}', '741', '192.168.5.234', '2020-08-14 15:53:40');
INSERT INTO `sys_log` VALUES ('336', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[60,59],\"remark\":\"店铺客服\",\"roleId\":5,\"roleName\":\"店铺客服\"}', '91', '192.168.5.234', '2020-08-14 15:53:55');
INSERT INTO `sys_log` VALUES ('337', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[63],\"remark\":\"测试管理员\",\"roleId\":4,\"roleName\":\"店铺管理员\",\"shopRole\":1}', '570', '192.168.5.234', '2020-08-14 16:07:06');
INSERT INTO `sys_log` VALUES ('338', 'admin', '保存或修改用户', 'com.antd.modules.sys.controller.SysUserController.save()', '{\"email\":\"844899914@qq.com\",\"mobile\":\"13612345678\",\"roleIdList\":[1,3,5],\"status\":1,\"userId\":1,\"username\":\"admin\"}', '482', '192.168.5.234', '2020-08-18 14:23:54');
INSERT INTO `sys_log` VALUES ('339', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":123,\"name\":\"测试页面\",\"parentId\":0,\"perms\":\"test\",\"type\":1}', '17', '192.168.1.100', '2021-02-08 12:16:16');
INSERT INTO `sys_log` VALUES ('340', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":124,\"name\":\"页面一\",\"parentId\":123,\"perms\":\"test.page1\",\"type\":2}', '9', '192.168.1.100', '2021-02-08 12:16:37');
INSERT INTO `sys_log` VALUES ('341', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":125,\"name\":\"页面二\",\"parentId\":123,\"perms\":\"test.page2\",\"type\":2}', '9', '192.168.1.100', '2021-02-08 12:16:53');
INSERT INTO `sys_log` VALUES ('342', 'admin', '删除菜单', 'com.antd.modules.sys.controller.SysMenuController.delete()', '102', '4', '192.168.1.100', '2021-02-17 01:09:48');
INSERT INTO `sys_log` VALUES ('343', 'admin', '删除菜单', 'com.antd.modules.sys.controller.SysMenuController.delete()', '123', '1', '192.168.1.100', '2021-02-17 01:10:32');
INSERT INTO `sys_log` VALUES ('344', 'admin', '删除菜单', 'com.antd.modules.sys.controller.SysMenuController.delete()', '123', '77', '192.168.1.100', '2021-02-17 01:17:04');
INSERT INTO `sys_log` VALUES ('345', 'admin', '删除菜单', 'com.antd.modules.sys.controller.SysMenuController.delete()', '119', '19', '192.168.1.100', '2021-02-17 01:17:19');
INSERT INTO `sys_log` VALUES ('346', 'admin', '删除菜单', 'com.antd.modules.sys.controller.SysMenuController.delete()', '114', '22', '192.168.1.100', '2021-02-17 01:17:36');
INSERT INTO `sys_log` VALUES ('347', 'admin', '删除菜单', 'com.antd.modules.sys.controller.SysMenuController.delete()', '108', '17', '192.168.1.100', '2021-02-17 01:17:49');
INSERT INTO `sys_log` VALUES ('348', 'admin', '删除菜单', 'com.antd.modules.sys.controller.SysMenuController.delete()', '102', '18', '192.168.1.100', '2021-02-17 01:17:57');
INSERT INTO `sys_log` VALUES ('349', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":126,\"name\":\"连接/设备管理\",\"parentId\":0,\"perms\":\"con_equ\",\"type\":1}', '10', '192.168.1.100', '2021-02-17 01:28:40');
INSERT INTO `sys_log` VALUES ('350', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":127,\"name\":\"连接管理\",\"parentId\":126,\"perms\":\"con_equ.connect\",\"type\":2}', '7', '192.168.1.100', '2021-02-17 01:29:04');
INSERT INTO `sys_log` VALUES ('351', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":128,\"name\":\"设备管理\",\"parentId\":126,\"perms\":\"com_equ.equipment\",\"type\":2}', '8', '192.168.1.100', '2021-02-17 01:34:40');
INSERT INTO `sys_log` VALUES ('352', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":128,\"name\":\"设备管理\",\"parentId\":126,\"perms\":\"con_equ.equipment\",\"type\":2}', '20', '192.168.1.100', '2021-02-17 01:35:15');
INSERT INTO `sys_log` VALUES ('353', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":129,\"name\":\"查看\",\"parentId\":127,\"perms\":\"con_equ.connect.list\",\"type\":3}', '27', '192.168.1.100', '2021-02-18 01:06:05');
INSERT INTO `sys_log` VALUES ('354', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":130,\"name\":\"增改\",\"parentId\":127,\"perms\":\"con_equ.connect.write\",\"type\":3}', '7', '192.168.1.100', '2021-02-18 01:07:07');
INSERT INTO `sys_log` VALUES ('355', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":131,\"name\":\"删除\",\"parentId\":127,\"perms\":\"con_equ.connect.delete\",\"type\":3}', '9', '192.168.1.100', '2021-02-18 01:07:49');
INSERT INTO `sys_log` VALUES ('356', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":2,\"name\":\"测试连接\",\"port\":666,\"type\":1}', '15', '192.168.1.100', '2021-02-18 01:14:11');
INSERT INTO `sys_log` VALUES ('357', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":3,\"name\":\"在测试一个连接\",\"port\":4545,\"type\":2}', '6', '192.168.1.100', '2021-02-18 01:15:03');
INSERT INTO `sys_log` VALUES ('358', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":4,\"name\":\"测试\",\"port\":897,\"type\":1}', '7', '192.168.1.100', '2021-02-18 01:15:30');
INSERT INTO `sys_log` VALUES ('359', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":5,\"name\":\"测试dadwad\",\"port\":900,\"type\":1}', '5', '192.168.1.100', '2021-02-18 01:15:43');
INSERT INTO `sys_log` VALUES ('360', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":5,\"name\":\"测试sssss\",\"port\":900,\"type\":1}', '34', '192.168.1.100', '2021-02-18 01:23:30');
INSERT INTO `sys_log` VALUES ('361', 'admin', '删除用户', 'com.antd.modules.sys.controller.SysUserController.delete()', '[null,null,null,null,null]', '23', '192.168.1.100', '2021-02-18 01:23:37');
INSERT INTO `sys_log` VALUES ('362', 'admin', '删除连接', 'com.antd.modules.security.controller.SecConnectController.delete()', '[4,5]', '9', '192.168.1.100', '2021-02-18 01:28:49');
INSERT INTO `sys_log` VALUES ('363', 'admin', '删除连接', 'com.antd.modules.security.controller.SecConnectController.delete()', '[1,2,3]', '6', '192.168.1.100', '2021-02-18 01:28:54');
INSERT INTO `sys_log` VALUES ('364', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":6,\"name\":\"才打完的\",\"port\":14,\"type\":1}', '9', '192.168.1.100', '2021-02-18 01:29:58');
INSERT INTO `sys_log` VALUES ('365', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":7,\"name\":\"4234234\",\"port\":234234234,\"type\":1}', '5', '192.168.1.100', '2021-02-18 01:30:02');
INSERT INTO `sys_log` VALUES ('366', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":8,\"name\":\"4234\",\"port\":234234,\"type\":1}', '5', '192.168.1.100', '2021-02-18 01:30:08');
INSERT INTO `sys_log` VALUES ('367', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":9,\"name\":\"4234234\",\"port\":4234,\"type\":1}', '6', '192.168.1.100', '2021-02-18 01:30:11');
INSERT INTO `sys_log` VALUES ('368', 'admin', '删除连接', 'com.antd.modules.security.controller.SecConnectController.delete()', '[9]', '5', '192.168.1.100', '2021-02-18 01:30:17');
INSERT INTO `sys_log` VALUES ('369', 'admin', '删除连接', 'com.antd.modules.security.controller.SecConnectController.delete()', '[8]', '4', '192.168.1.100', '2021-02-18 01:31:04');
INSERT INTO `sys_log` VALUES ('370', 'admin', '删除连接', 'com.antd.modules.security.controller.SecConnectController.delete()', '[7]', '3', '192.168.1.100', '2021-02-18 01:31:11');
INSERT INTO `sys_log` VALUES ('371', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":10,\"name\":\"dwadwad\",\"port\":13,\"type\":2}', '6', '192.168.1.100', '2021-02-18 01:31:17');
INSERT INTO `sys_log` VALUES ('372', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":11,\"name\":\"312321\",\"port\":3123,\"type\":1}', '6', '192.168.1.100', '2021-02-18 01:31:21');
INSERT INTO `sys_log` VALUES ('373', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":12,\"name\":\"4213123\",\"port\":3123,\"type\":2}', '5', '192.168.1.100', '2021-02-18 01:31:26');
INSERT INTO `sys_log` VALUES ('374', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":132,\"name\":\"系统日志\",\"parentId\":57,\"perms\":\"sys.log\",\"type\":2}', '43', '192.168.1.107', '2021-02-21 12:16:26');
INSERT INTO `sys_log` VALUES ('375', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":133,\"name\":\"查看\",\"parentId\":132,\"perms\":\"sys.log.list\",\"type\":3}', '8', '192.168.1.107', '2021-02-21 12:17:03');
INSERT INTO `sys_log` VALUES ('376', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":13,\"name\":\"测试连接\",\"port\":999,\"type\":1}', '16', '192.168.1.107', '2021-02-21 13:54:53');
INSERT INTO `sys_log` VALUES ('377', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":6,\"name\":\"才打完的\",\"port\":144,\"type\":1}', '64', '192.168.1.107', '2021-02-22 20:01:06');
INSERT INTO `sys_log` VALUES ('378', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":6,\"name\":\"才打完的\",\"port\":1444,\"type\":1}', '23084', '192.168.1.107', '2021-02-22 20:02:46');
INSERT INTO `sys_log` VALUES ('379', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":6,\"name\":\"才打完的\",\"port\":1446,\"type\":1}', '34896', '192.168.1.107', '2021-02-22 20:04:57');
INSERT INTO `sys_log` VALUES ('380', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":6,\"name\":\"才打完的\",\"port\":1449,\"type\":1}', '37', '192.168.1.107', '2021-02-22 20:06:47');
INSERT INTO `sys_log` VALUES ('381', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":6,\"name\":\"才打完的\",\"port\":1450,\"type\":1}', '8', '192.168.1.107', '2021-02-22 20:07:25');
INSERT INTO `sys_log` VALUES ('382', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":6,\"name\":\"才打完的\",\"port\":1418,\"type\":1}', '13264', '192.168.1.107', '2021-02-22 20:08:24');
INSERT INTO `sys_log` VALUES ('383', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":6,\"name\":\"才打完的\",\"port\":1488,\"type\":1}', '8', '192.168.1.107', '2021-02-22 20:08:55');
INSERT INTO `sys_log` VALUES ('384', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":6,\"name\":\"才打完的\",\"port\":1450,\"type\":1}', '40', '192.168.1.107', '2021-02-22 20:10:53');
INSERT INTO `sys_log` VALUES ('385', 'admin', '删除连接', 'com.antd.modules.security.controller.SecConnectController.delete()', '[6]', '25', '192.168.1.107', '2021-02-22 20:11:07');
INSERT INTO `sys_log` VALUES ('386', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":14,\"name\":\"新的TCP\",\"port\":665,\"type\":1}', '18', '192.168.1.107', '2021-02-22 20:44:15');
INSERT INTO `sys_log` VALUES ('387', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":10,\"name\":\"TCP端口13\",\"port\":13,\"type\":2}', '37', '192.168.1.107', '2021-02-22 20:44:51');
INSERT INTO `sys_log` VALUES ('388', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":10,\"name\":\"TCP端口\",\"port\":13,\"type\":2}', '9', '192.168.1.107', '2021-02-22 20:44:59');
INSERT INTO `sys_log` VALUES ('389', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":12,\"name\":\"4213123\",\"port\":3124,\"type\":2}', '8', '192.168.1.107', '2021-02-22 20:49:39');
INSERT INTO `sys_log` VALUES ('390', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":134,\"name\":\"模块列表\",\"parentId\":128,\"perms\":\"con_equ.equipment.modularList\",\"type\":3}', '22', '192.168.1.107', '2021-02-22 23:23:48');
INSERT INTO `sys_log` VALUES ('391', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":15,\"type\":1}', '53', '192.168.1.107', '2021-02-22 23:49:14');
INSERT INTO `sys_log` VALUES ('392', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":16,\"type\":1}', '7', '192.168.1.107', '2021-02-22 23:49:22');
INSERT INTO `sys_log` VALUES ('393', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":135,\"name\":\"增改模块\",\"parentId\":128,\"perms\":\"con_equ.equipment.modularWrite\",\"type\":3}', '48', '192.168.1.107', '2021-02-23 00:03:51');
INSERT INTO `sys_log` VALUES ('394', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":136,\"name\":\"删除模块\",\"parentId\":128,\"perms\":\"con_equ.equipment.modularDelete\",\"type\":3}', '11', '192.168.1.107', '2021-02-23 00:04:07');
INSERT INTO `sys_log` VALUES ('395', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[57,58,59,60,61,62,63,65,66,67,68,64,69,70,71,72,73,78,79,80,81,74,76,77,82,83,84,85,86,87,88,89,90,91,92,93,132,133,126,127,129,130,131,128,134,135,136,137,138,139],\"remark\":\"超级管理员角色666\",\"roleId\":1,\"roleName\":\"超级管理员\",\"shopRole\":0}', '212', '192.168.1.102', '2021-02-23 22:33:54');
INSERT INTO `sys_log` VALUES ('396', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[57,58,59,60,61,62,63,65,66,67,68,64,69,70,71,72,73,78,79,80,81,74,76,77,82,83,84,85,86,87,88,89,90,91,92,93,132,133,126,127,129,130,131,128,134,135,136,137,138,139],\"remark\":\"超级管理员角色666\",\"roleId\":1,\"roleName\":\"超级管理员\",\"shopRole\":0}', '168', '192.168.1.102', '2021-02-23 23:07:49');
INSERT INTO `sys_log` VALUES ('397', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[57,58,59,60,61,62,63,65,66,67,68,64,69,70,71,72,73,78,79,80,81,74,76,77,82,83,84,85,86,87,88,89,90,91,92,93,132,133,126,127,129,130,131,128,134,135,136,137,138,139],\"remark\":\"超级管理员角色666\",\"roleId\":1,\"roleName\":\"超级管理员\",\"shopRole\":0}', '153', '192.168.1.102', '2021-02-24 00:28:28');
INSERT INTO `sys_log` VALUES ('398', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":146,\"name\":\"数据解析器\",\"parentId\":126,\"perms\":\"sec.dataAnalysis\",\"type\":2}', '26', '192.168.1.102', '2021-02-24 00:53:48');
INSERT INTO `sys_log` VALUES ('399', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":146,\"name\":\"数据解析器\",\"parentId\":126,\"perms\":\"con_equ.dataAnalysis\",\"type\":2}', '17', '192.168.1.102', '2021-02-24 00:54:05');
INSERT INTO `sys_log` VALUES ('400', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":147,\"name\":\"查看\",\"parentId\":146,\"perms\":\"con_equ.dataAnalysis.list\",\"type\":3}', '11', '192.168.1.102', '2021-02-24 00:54:26');
INSERT INTO `sys_log` VALUES ('401', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":148,\"name\":\"增改\",\"parentId\":146,\"perms\":\"con_equ.dataAnalysis.write\",\"type\":3}', '12', '192.168.1.102', '2021-02-24 00:54:47');
INSERT INTO `sys_log` VALUES ('402', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":149,\"name\":\"删除\",\"parentId\":146,\"perms\":\"con_equ.dataAnalysis.delete\",\"type\":3}', '10', '192.168.1.102', '2021-02-24 00:55:06');
INSERT INTO `sys_log` VALUES ('403', 'admin', '保存或修改解析器', 'com.antd.modules.security.controller.SecDataAnalysisController.saveOrUpdate()', '{\"convertTo\":2,\"cut\":0,\"example\":\"23131421\",\"highLowConvert\":0,\"id\":1,\"info\":\"吊袜带大武当\",\"name\":\"那么\"}', '17', '192.168.1.102', '2021-02-24 01:14:00');
INSERT INTO `sys_log` VALUES ('404', 'admin', '保存或修改解析器', 'com.antd.modules.security.controller.SecDataAnalysisController.saveOrUpdate()', '{\"convertTo\":2,\"cut\":1,\"cutLength\":3123,\"cutStart\":313,\"example\":\"23131421\",\"highLowConvert\":0,\"id\":1,\"info\":\"吊袜带大武当\",\"name\":\"那么\"}', '37', '192.168.1.102', '2021-02-24 01:17:55');
INSERT INTO `sys_log` VALUES ('405', 'admin', '保存或修改解析器', 'com.antd.modules.security.controller.SecDataAnalysisController.saveOrUpdate()', '{\"convertTo\":2,\"cut\":0,\"example\":\"dqwdqw\",\"highLowConvert\":0,\"id\":2,\"info\":\"dqwdqwdwq\",\"name\":\"dqwdwq\"}', '6', '192.168.1.102', '2021-02-24 01:18:07');
INSERT INTO `sys_log` VALUES ('406', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"analysisId\":1,\"id\":4,\"instructId\":3,\"length\":6,\"name\":\"teasdw\",\"start\":0}', '241', '192.168.10.13', '2021-02-28 15:34:57');
INSERT INTO `sys_log` VALUES ('407', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"analysisId\":1,\"id\":6,\"instructId\":6,\"length\":3,\"name\":\"Dwadwad\",\"start\":2}', '220', '192.168.43.99', '2021-03-04 15:12:59');
INSERT INTO `sys_log` VALUES ('408', 'admin', '保存或修改解析器', 'com.antd.modules.security.controller.SecDataAnalysisController.saveOrUpdate()', '{\"convertTo\":3,\"cut\":0,\"example\":\"010100aaaa\",\"highLowConvert\":0,\"id\":1,\"info\":\"人体红外传感解析\",\"name\":\"人体红外传感解析\"}', '101', '192.168.43.99', '2021-03-04 15:14:30');
INSERT INTO `sys_log` VALUES ('409', 'admin', '保存或修改解析器', 'com.antd.modules.security.controller.SecDataAnalysisController.saveOrUpdate()', '{\"convertTo\":2,\"cut\":0,\"example\":\"0102f2aaaa\",\"highLowConvert\":0,\"id\":2,\"info\":\"温度值解析\",\"name\":\"温度值解析\"}', '92', '192.168.43.99', '2021-03-04 15:15:32');
INSERT INTO `sys_log` VALUES ('410', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"analysisId\":2,\"id\":5,\"instructId\":4,\"length\":313,\"name\":\"带娃大无\",\"start\":312}', '92', '192.168.43.99', '2021-03-04 15:35:34');
INSERT INTO `sys_log` VALUES ('411', 'admin', '删除模块', 'com.antd.modules.security.controller.SecEquipmentController.modularDelete()', '[1]', '187', '192.168.43.99', '2021-03-04 15:37:42');
INSERT INTO `sys_log` VALUES ('412', 'admin', '删除指令', 'com.antd.modules.security.controller.SecEquipmentController.instructDelete()', '[1]', '198', '192.168.43.99', '2021-03-04 15:38:29');
INSERT INTO `sys_log` VALUES ('413', 'admin', '删除模块', 'com.antd.modules.security.controller.SecEquipmentController.modularDelete()', '[3,2]', '125', '192.168.43.99', '2021-03-04 15:43:47');
INSERT INTO `sys_log` VALUES ('414', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":10,\"name\":\"安防平台接口\",\"port\":4567,\"type\":1}', '99', '192.168.43.99', '2021-03-04 15:45:19');
INSERT INTO `sys_log` VALUES ('415', 'admin', '保存或修改模块', 'com.antd.modules.security.controller.SecEquipmentController.modularSaveOrUpdate()', '{\"connectId\":10,\"id\":4,\"name\":\"Esp8266 12F\",\"verify\":\"aabb\"}', '87', '192.168.43.99', '2021-03-04 15:46:10');
INSERT INTO `sys_log` VALUES ('416', 'admin', '保存或修改设备', 'com.antd.modules.security.controller.SecEquipmentController.equipmentSaveOrUpdate()', '{\"id\":6,\"modularId\":4,\"name\":\"人体红外\"}', '78', '192.168.43.99', '2021-03-04 15:46:27');
INSERT INTO `sys_log` VALUES ('417', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":6,\"id\":7,\"instruct\":\"000100aaaa\",\"name\":\"红外状态\",\"type\":0}', '87', '192.168.43.99', '2021-03-04 15:47:20');
INSERT INTO `sys_log` VALUES ('418', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"analysisId\":1,\"id\":7,\"instructId\":7,\"length\":2,\"name\":\"红外状态\",\"start\":4}', '67', '192.168.43.99', '2021-03-04 15:47:57');
INSERT INTO `sys_log` VALUES ('419', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"analysisId\":1,\"id\":7,\"instructId\":7,\"length\":2,\"name\":\"红外状态\",\"start\":4}', '108', '192.168.43.99', '2021-03-04 16:18:53');
INSERT INTO `sys_log` VALUES ('420', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":6,\"id\":7,\"instruct\":\"000100aaaa\",\"name\":\"红外状态\",\"type\":0}', '71', '192.168.1.102', '2021-03-05 23:01:12');
INSERT INTO `sys_log` VALUES ('421', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":6,\"id\":7,\"instruct\":\"000100aaaa\",\"name\":\"红外状态\",\"retExample\":\"000101aaaa\",\"type\":0}', '17', '192.168.1.102', '2021-03-05 23:02:07');
INSERT INTO `sys_log` VALUES ('422', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":2,\"cut\":0,\"highLowConvert\":0,\"id\":7,\"instructId\":7,\"length\":2,\"name\":\"红外状态\",\"start\":4}', '19', '192.168.1.102', '2021-03-05 23:31:55');
INSERT INTO `sys_log` VALUES ('423', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":2,\"cut\":1,\"cutLength\":8,\"cutStart\":8,\"highLowConvert\":1,\"id\":7,\"instructId\":7,\"length\":2,\"name\":\"红外状态\",\"start\":4}', '7', '192.168.1.102', '2021-03-05 23:32:06');
INSERT INTO `sys_log` VALUES ('424', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":2,\"cut\":1,\"highLowConvert\":1,\"id\":7,\"instructId\":7,\"length\":2,\"name\":\"红外状态\",\"start\":4}', '7', '192.168.1.102', '2021-03-05 23:33:37');
INSERT INTO `sys_log` VALUES ('425', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":1,\"cut\":1,\"cutLength\":10,\"cutStart\":10,\"highLowConvert\":0,\"id\":8,\"instructId\":7,\"length\":2,\"name\":\"测试项\",\"start\":5}', '12', '192.168.1.102', '2021-03-05 23:33:56');
INSERT INTO `sys_log` VALUES ('426', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":2,\"cut\":1,\"cutLength\":10,\"cutStart\":10,\"highLowConvert\":1,\"id\":7,\"instructId\":7,\"length\":2,\"name\":\"红外状态\",\"start\":4}', '7', '192.168.1.102', '2021-03-05 23:34:58');
INSERT INTO `sys_log` VALUES ('427', 'admin', '保存或修改解析器', 'com.antd.modules.security.controller.SecDataAnalysisController.saveOrUpdate()', '{\"convertTo\":3,\"cut\":0,\"example\":\"010100aaaa\",\"highLowConvert\":1,\"id\":1,\"info\":\"人体红外传感解析\",\"name\":\"人体红外传感解析\"}', '26', '192.168.1.102', '2021-03-05 23:39:21');
INSERT INTO `sys_log` VALUES ('428', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":1,\"cut\":1,\"cutLength\":22,\"cutStart\":122,\"highLowConvert\":0,\"id\":8,\"instructId\":7,\"length\":2,\"name\":\"测试项\",\"start\":5}', '5', '192.168.1.102', '2021-03-05 23:40:06');
INSERT INTO `sys_log` VALUES ('429', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":2,\"cut\":0,\"highLowConvert\":0,\"id\":7,\"instructId\":7,\"length\":2,\"name\":\"红外状态\",\"start\":4}', '5', '192.168.1.102', '2021-03-05 23:40:20');
INSERT INTO `sys_log` VALUES ('430', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":3,\"cut\":1,\"cutLength\":1,\"cutStart\":7,\"highLowConvert\":0,\"id\":8,\"instructId\":7,\"length\":2,\"name\":\"测试项\",\"start\":5}', '21', '192.168.1.102', '2021-03-06 22:43:19');
INSERT INTO `sys_log` VALUES ('431', 'admin', '删除连接', 'com.antd.modules.security.controller.SecConnectController.delete()', '[11,12,13,14]', '89', '192.168.1.102', '2021-03-06 22:47:39');
INSERT INTO `sys_log` VALUES ('432', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":6,\"id\":8,\"instruct\":\"00012254aabb\",\"name\":\"测试指令\",\"retExample\":\"00012254aabb\",\"type\":0}', '17', '192.168.1.102', '2021-03-07 22:02:55');
INSERT INTO `sys_log` VALUES ('433', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":6,\"id\":7,\"instruct\":\"000200aaaa\",\"name\":\"红外状态\",\"retExample\":\"000201aaaa\",\"type\":0}', '20', '192.168.1.102', '2021-03-08 00:47:20');
INSERT INTO `sys_log` VALUES ('434', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[null],\"remark\":\"普通用户\",\"roleId\":3,\"roleName\":\"普通用户\",\"shopRole\":1}', '111', '192.168.1.102', '2021-03-08 12:33:11');
INSERT INTO `sys_log` VALUES ('435', 'admin', '删除角色', 'com.antd.modules.sys.controller.SysRoleController.delete()', '[6]', '17', '192.168.1.102', '2021-03-08 12:36:03');
INSERT INTO `sys_log` VALUES ('436', 'admin', '删除角色', 'com.antd.modules.sys.controller.SysRoleController.delete()', '[4]', '10', '192.168.1.102', '2021-03-08 12:36:13');
INSERT INTO `sys_log` VALUES ('437', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"createTime\":1615178562610,\"menuIdList\":[59],\"remark\":\"test\",\"roleId\":8,\"roleName\":\"test\",\"shopRole\":1}', '10', '192.168.1.102', '2021-03-08 12:42:43');
INSERT INTO `sys_log` VALUES ('438', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[59,60],\"remark\":\"test\",\"roleId\":8,\"roleName\":\"test\",\"shopRole\":1}', '11', '192.168.1.102', '2021-03-08 12:44:39');
INSERT INTO `sys_log` VALUES ('439', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[62],\"remark\":\"普通用户\",\"roleId\":3,\"roleName\":\"普通用户\",\"shopRole\":1}', '8', '192.168.1.102', '2021-03-08 12:44:58');
INSERT INTO `sys_log` VALUES ('440', 'admin', '删除用户', 'com.antd.modules.sys.controller.SysUserController.delete()', '[21,22,23,26]', '13', '192.168.1.102', '2021-03-08 12:45:06');
INSERT INTO `sys_log` VALUES ('441', 'admin', '保存或修改用户', 'com.antd.modules.sys.controller.SysUserController.save()', '{\"createTime\":1615178735331,\"email\":\"www@qq.com\",\"mobile\":\"17803221554\",\"password\":\"5873005bd7488a7521ded10a0f99738f08c57891c4ba429d675fe7a7688ab909\",\"roleIdList\":[8],\"salt\":\"PFfizCQ4inDCcHA54hES\",\"status\":1,\"userId\":27,\"username\":\"test\"}', '23', '192.168.1.102', '2021-03-08 12:45:35');
INSERT INTO `sys_log` VALUES ('442', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[60],\"remark\":\"test\",\"roleId\":8,\"roleName\":\"test\",\"shopRole\":1}', '10', '192.168.1.102', '2021-03-08 12:47:09');
INSERT INTO `sys_log` VALUES ('443', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[62],\"remark\":\"test\",\"roleId\":8,\"roleName\":\"test\",\"shopRole\":1}', '9', '192.168.1.102', '2021-03-08 12:47:36');
INSERT INTO `sys_log` VALUES ('444', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":150,\"name\":\"权限菜单\",\"parentId\":0,\"perms\":\"sys.socket\",\"type\":3}', '11', '192.168.1.102', '2021-03-08 12:49:56');
INSERT INTO `sys_log` VALUES ('445', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":150,\"name\":\"其他权限\",\"parentId\":0,\"perms\":\"other\",\"type\":1}', '7', '192.168.1.102', '2021-03-08 12:51:56');
INSERT INTO `sys_log` VALUES ('446', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":151,\"name\":\"socket权限\",\"parentId\":150,\"perms\":\"other.socket\",\"type\":2}', '7', '192.168.1.102', '2021-03-08 12:52:18');
INSERT INTO `sys_log` VALUES ('447', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":152,\"name\":\"系统提示socket\",\"parentId\":151,\"perms\":\"other.socket.sysSocket\",\"type\":3}', '5', '192.168.1.102', '2021-03-08 12:52:45');
INSERT INTO `sys_log` VALUES ('448', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":153,\"name\":\"数据socket权限\",\"parentId\":151,\"perms\":\"other.socket.dataSocket\",\"type\":3}', '8', '192.168.1.102', '2021-03-08 12:53:04');
INSERT INTO `sys_log` VALUES ('449', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[62,152],\"remark\":\"test\",\"roleId\":8,\"roleName\":\"test\",\"shopRole\":1}', '10', '192.168.1.102', '2021-03-08 12:55:32');
INSERT INTO `sys_log` VALUES ('450', 'admin', '删除菜单', 'com.antd.modules.sys.controller.SysMenuController.delete()', '146', '15', '192.168.1.102', '2021-03-08 12:56:23');
INSERT INTO `sys_log` VALUES ('451', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[62,128,134,135,136,137,138,139,140,141,142,143,144,145],\"remark\":\"test\",\"roleId\":8,\"roleName\":\"test\",\"shopRole\":1}', '21', '192.168.1.102', '2021-03-08 12:56:45');
INSERT INTO `sys_log` VALUES ('452', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[62,128,134,135,136,137,138,139,140,141,142,143,144,145,59],\"remark\":\"test\",\"roleId\":8,\"roleName\":\"test\",\"shopRole\":1}', '34', '192.168.1.102', '2021-03-08 20:03:01');
INSERT INTO `sys_log` VALUES ('453', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[62,128,134,135,136,137,138,139,140,141,142,143,144,145,59,152],\"remark\":\"test\",\"roleId\":8,\"roleName\":\"test\",\"shopRole\":1}', '26', '192.168.1.102', '2021-03-08 20:09:32');
INSERT INTO `sys_log` VALUES ('454', 'admin', '保存或修改用户', 'com.antd.modules.sys.controller.SysUserController.save()', '{\"createTime\":1615205428249,\"email\":\"8448@qq.com\",\"mobile\":\"17803215100\",\"password\":\"b4aa2d01ad4d98cc12aebb112afa0ae301e782abb0731cfb490cecf1cb542158\",\"roleIdList\":[8],\"salt\":\"wXCfgb0BpIXqJb7SARNd\",\"status\":1,\"userId\":28,\"username\":\"admin1\"}', '18', '192.168.1.102', '2021-03-08 20:10:28');
INSERT INTO `sys_log` VALUES ('455', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[62,128,134,135,136,137,138,139,140,141,142,143,144,145,59],\"remark\":\"test\",\"roleId\":8,\"roleName\":\"test\",\"shopRole\":1}', '30', '192.168.1.102', '2021-03-08 20:10:59');
INSERT INTO `sys_log` VALUES ('456', 'admin', '保存或修改模块', 'com.antd.modules.security.controller.SecEquipmentController.modularSaveOrUpdate()', '{\"connectId\":10,\"id\":4,\"instructInterval\":500,\"isUp\":0,\"name\":\"Esp8266 12F\",\"queryInterval\":2000,\"verify\":\"aabb\"}', '35', '192.168.1.102', '2021-03-11 13:39:04');
INSERT INTO `sys_log` VALUES ('457', 'admin', '保存或修改模块', 'com.antd.modules.security.controller.SecEquipmentController.modularSaveOrUpdate()', '{\"connectId\":10,\"id\":4,\"instructInterval\":100,\"isUp\":0,\"name\":\"Esp8266 12F\",\"queryInterval\":2000,\"verify\":\"aabb\"}', '6', '192.168.1.102', '2021-03-11 13:39:23');
INSERT INTO `sys_log` VALUES ('458', 'admin', '保存或修改模块', 'com.antd.modules.security.controller.SecEquipmentController.modularSaveOrUpdate()', '{\"connectId\":10,\"id\":4,\"instructInterval\":1000,\"isUp\":0,\"name\":\"Esp8266 12F\",\"queryInterval\":4000,\"verify\":\"aabb\"}', '5', '192.168.1.102', '2021-03-11 13:40:36');
INSERT INTO `sys_log` VALUES ('459', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":3,\"cut\":0,\"highLowConvert\":0,\"id\":7,\"instructId\":7,\"length\":2,\"name\":\"红外状态\",\"start\":4}', '10', '192.168.1.102', '2021-03-11 13:46:17');
INSERT INTO `sys_log` VALUES ('460', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":3,\"cut\":1,\"cutLength\":1,\"cutStart\":6,\"highLowConvert\":0,\"id\":8,\"instructId\":7,\"length\":2,\"name\":\"测试项\",\"start\":4}', '37', '192.168.1.102', '2021-03-11 13:56:55');
INSERT INTO `sys_log` VALUES ('461', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":3,\"cut\":1,\"cutLength\":1,\"cutStart\":7,\"highLowConvert\":0,\"id\":7,\"instructId\":7,\"length\":2,\"name\":\"红外状态\",\"start\":4}', '7', '192.168.1.102', '2021-03-11 13:58:02');
INSERT INTO `sys_log` VALUES ('462', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[57,58,59,60,61,62,63,65,66,67,68,64,69,70,71,72,73,78,79,80,81,74,76,77,82,83,84,85,86,87,88,89,90,91,92,93,132,133,126,127,129,130,131,128,134,135,136,137,138,139,140,141,142,143,144,145,150,151,152,153],\"remark\":\"超级管理员角色666\",\"roleId\":1,\"roleName\":\"超级管理员\",\"shopRole\":0}', '246', '192.168.1.102', '2021-03-11 20:58:24');
INSERT INTO `sys_log` VALUES ('463', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":154,\"name\":\"数据管理\",\"parentId\":0,\"perms\":\"secData\",\"type\":1}', '21', '192.168.1.102', '2021-03-11 21:10:08');
INSERT INTO `sys_log` VALUES ('464', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":155,\"name\":\"实时数据\",\"parentId\":154,\"perms\":\"secData.realTimeData\",\"type\":2}', '22', '192.168.1.102', '2021-03-11 21:10:46');
INSERT INTO `sys_log` VALUES ('465', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":156,\"name\":\"查看\",\"parentId\":155,\"perms\":\"secData.realTimeData.list\",\"type\":3}', '10', '192.168.1.102', '2021-03-11 21:11:02');
INSERT INTO `sys_log` VALUES ('466', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":3,\"cut\":1,\"cutLength\":1,\"cutStart\":6,\"highLowConvert\":0,\"id\":8,\"instructId\":7,\"length\":2,\"name\":\"测试项1\",\"start\":4}', '19', '192.168.1.102', '2021-03-11 22:01:51');
INSERT INTO `sys_log` VALUES ('467', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":3,\"cut\":1,\"cutLength\":1,\"cutStart\":6,\"highLowConvert\":0,\"id\":8,\"instructId\":7,\"length\":2,\"name\":\"测试项1\",\"start\":4}', '8', '192.168.1.102', '2021-03-11 22:02:34');
INSERT INTO `sys_log` VALUES ('468', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":3,\"cut\":1,\"cutLength\":1,\"cutStart\":6,\"highLowConvert\":0,\"id\":8,\"instructId\":7,\"length\":2,\"name\":\"测试项1666\",\"start\":4}', '75', '192.168.1.102', '2021-03-13 13:55:47');
INSERT INTO `sys_log` VALUES ('469', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":3,\"cut\":1,\"cutLength\":1,\"cutStart\":7,\"highLowConvert\":0,\"id\":7,\"instructId\":7,\"length\":2,\"name\":\"红外状态777\",\"start\":4}', '10', '192.168.1.102', '2021-03-13 13:56:00');
INSERT INTO `sys_log` VALUES ('470', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":6,\"id\":7,\"instruct\":\"000200aaaa\",\"name\":\"红外状态ddd\",\"retExample\":\"000201aaaa\",\"type\":0}', '10', '192.168.1.102', '2021-03-13 13:56:18');
INSERT INTO `sys_log` VALUES ('471', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":6,\"id\":7,\"instruct\":\"000200aaaa\",\"name\":\"红外状态\",\"retExample\":\"000201aaaa\",\"type\":0}', '7', '192.168.1.102', '2021-03-13 13:56:30');
INSERT INTO `sys_log` VALUES ('472', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":3,\"cut\":1,\"cutLength\":1,\"cutStart\":6,\"highLowConvert\":0,\"id\":8,\"instructId\":7,\"length\":2,\"name\":\"测试项\",\"start\":4}', '8', '192.168.1.102', '2021-03-13 13:56:37');
INSERT INTO `sys_log` VALUES ('473', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":3,\"cut\":1,\"cutLength\":1,\"cutStart\":7,\"highLowConvert\":0,\"id\":7,\"instructId\":7,\"length\":2,\"name\":\"红外状态\",\"start\":4}', '7', '192.168.1.102', '2021-03-13 13:56:41');
INSERT INTO `sys_log` VALUES ('474', 'admin', '保存或修改模块', 'com.antd.modules.security.controller.SecEquipmentController.modularSaveOrUpdate()', '{\"connectId\":10,\"id\":5,\"instructInterval\":1000,\"isUp\":0,\"name\":\"第二个模块\",\"queryInterval\":4000,\"remark\":\"这是备注\",\"verify\":\"uiyo\"}', '17', '192.168.1.102', '2021-03-13 14:48:40');
INSERT INTO `sys_log` VALUES ('475', 'admin', '保存或修改设备', 'com.antd.modules.security.controller.SecEquipmentController.equipmentSaveOrUpdate()', '{\"id\":7,\"modularId\":5,\"name\":\"第二个模块的设备\",\"remark\":\"第二个模块\"}', '8', '192.168.1.102', '2021-03-13 14:48:58');
INSERT INTO `sys_log` VALUES ('476', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":3,\"cut\":1,\"cutLength\":1,\"cutStart\":7,\"dataWarn\":1,\"highLowConvert\":0,\"id\":7,\"instructId\":7,\"length\":2,\"name\":\"红外状态\",\"start\":4,\"warnOption\":1,\"warnType\":\"1\",\"warnValue\":\"2\"}', '21', '192.168.1.102', '2021-03-15 23:20:33');
INSERT INTO `sys_log` VALUES ('477', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":3,\"cut\":1,\"cutLength\":1,\"cutStart\":6,\"dataWarn\":0,\"highLowConvert\":0,\"id\":8,\"instructId\":7,\"length\":2,\"name\":\"测试项\",\"start\":4}', '6', '192.168.1.102', '2021-03-15 23:21:31');
INSERT INTO `sys_log` VALUES ('478', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":3,\"cut\":1,\"cutLength\":1,\"cutStart\":7,\"dataWarn\":0,\"highLowConvert\":0,\"id\":7,\"instructId\":7,\"length\":2,\"name\":\"红外状态\",\"start\":4}', '6', '192.168.1.102', '2021-03-15 23:21:45');
INSERT INTO `sys_log` VALUES ('479', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":3,\"cut\":1,\"cutLength\":1,\"cutStart\":6,\"dataWarn\":1,\"highLowConvert\":0,\"id\":8,\"instructId\":7,\"length\":2,\"name\":\"测试项\",\"start\":4,\"warnOption\":2,\"warnType\":\"1,2\",\"warnValue\":\"33\"}', '8', '192.168.1.102', '2021-03-15 23:22:03');
INSERT INTO `sys_log` VALUES ('480', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":3,\"cut\":1,\"cutLength\":1,\"cutStart\":6,\"dataWarn\":1,\"highLowConvert\":0,\"id\":8,\"instructId\":7,\"length\":2,\"name\":\"测试项\",\"start\":4,\"warnOption\":1,\"warnType\":\"1,2\",\"warnValue\":\"1\"}', '38', '192.168.1.103', '2021-03-18 21:09:24');
INSERT INTO `sys_log` VALUES ('481', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":157,\"name\":\"警告消息\",\"parentId\":154,\"perms\":\"secData.warnMsg\",\"type\":2}', '23', '192.168.1.103', '2021-03-21 22:51:12');
INSERT INTO `sys_log` VALUES ('482', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":158,\"name\":\"查看\",\"parentId\":157,\"perms\":\"secData.warnMsg.list\",\"type\":3}', '8', '192.168.1.103', '2021-03-21 22:51:42');
INSERT INTO `sys_log` VALUES ('483', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":159,\"name\":\"标记已读\",\"parentId\":157,\"perms\":\"secData.warnMsg.read\",\"type\":3}', '9', '192.168.1.103', '2021-03-21 22:52:12');
INSERT INTO `sys_log` VALUES ('484', 'admin', '标记消息已读', 'com.antd.modules.security.controller.SecWarnMsgController.delete()', '[1]', '34', '192.168.1.103', '2021-03-21 23:24:21');
INSERT INTO `sys_log` VALUES ('485', 'admin', '标记消息已读', 'com.antd.modules.security.controller.SecWarnMsgController.delete()', '[1]', '23', '192.168.1.103', '2021-03-22 20:59:37');
INSERT INTO `sys_log` VALUES ('486', 'admin', '标记消息已读', 'com.antd.modules.security.controller.SecWarnMsgController.delete()', '[1]', '158', '192.168.1.103', '2021-03-24 12:59:25');
INSERT INTO `sys_log` VALUES ('487', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":11,\"name\":\"test\",\"port\":9999,\"type\":1}', '25', '192.168.1.103', '2021-03-25 13:41:52');
INSERT INTO `sys_log` VALUES ('488', 'admin', '标记消息已读', 'com.antd.modules.security.controller.SecWarnMsgController.delete()', '[56,55,54,53,52,51,50,49,48,47]', '20', '192.168.1.103', '2021-03-27 15:48:45');
INSERT INTO `sys_log` VALUES ('489', 'admin', '标记消息已读', 'com.antd.modules.security.controller.SecWarnMsgController.delete()', '[46,45,44,43,42,41,40,39,38,37]', '5', '192.168.1.103', '2021-03-27 15:48:48');
INSERT INTO `sys_log` VALUES ('490', 'admin', '标记消息已读', 'com.antd.modules.security.controller.SecWarnMsgController.delete()', '[36,35,34,33,32,31,30,29,28,27]', '5', '192.168.1.103', '2021-03-27 15:48:51');
INSERT INTO `sys_log` VALUES ('491', 'admin', '标记消息已读', 'com.antd.modules.security.controller.SecWarnMsgController.delete()', '[26,25,24,23,22,21,20,19,18,17]', '6', '192.168.1.103', '2021-03-27 15:48:54');
INSERT INTO `sys_log` VALUES ('492', 'admin', '标记消息已读', 'com.antd.modules.security.controller.SecWarnMsgController.delete()', '[16,15,14,13,12,11,10,9,8,7]', '4', '192.168.1.103', '2021-03-27 15:48:57');
INSERT INTO `sys_log` VALUES ('493', 'admin', '标记消息已读', 'com.antd.modules.security.controller.SecWarnMsgController.delete()', '[6,5,4,3,2,1,56,55,54,53]', '5', '192.168.1.103', '2021-03-27 15:49:00');
INSERT INTO `sys_log` VALUES ('494', 'admin', '标记消息已读', 'com.antd.modules.security.controller.SecWarnMsgController.delete()', '[2,1]', '40', '192.168.1.103', '2021-03-31 23:49:56');
INSERT INTO `sys_log` VALUES ('495', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":12,\"name\":\"测试单连接\",\"port\":8999,\"single\":1,\"type\":1}', '15', '192.168.1.103', '2021-04-01 13:35:53');
INSERT INTO `sys_log` VALUES ('496', 'admin', '保存或修改模块', 'com.antd.modules.security.controller.SecEquipmentController.modularSaveOrUpdate()', '{\"connectId\":12,\"id\":6,\"instructInterval\":1000,\"isUp\":0,\"name\":\"test\",\"queryInterval\":1000,\"remark\":\"test\"}', '16', '192.168.1.103', '2021-04-01 15:26:39');
INSERT INTO `sys_log` VALUES ('497', 'admin', '删除模块', 'com.antd.modules.security.controller.SecEquipmentController.modularDelete()', '[6]', '27', '192.168.1.103', '2021-04-01 15:58:42');
INSERT INTO `sys_log` VALUES ('498', 'admin', '保存或修改模块', 'com.antd.modules.security.controller.SecEquipmentController.modularSaveOrUpdate()', '{\"connectId\":12,\"id\":7,\"instructInterval\":1000,\"isUp\":0,\"name\":\"单连接模块\",\"queryInterval\":1000,\"remark\":\"test单连接模块\"}', '12', '192.168.1.103', '2021-04-01 16:15:51');
INSERT INTO `sys_log` VALUES ('499', 'admin', '保存或修改设备', 'com.antd.modules.security.controller.SecEquipmentController.equipmentSaveOrUpdate()', '{\"id\":8,\"modularId\":7,\"name\":\"红外设备\",\"remark\":\"红外设备\"}', '7', '192.168.1.103', '2021-04-01 16:16:07');
INSERT INTO `sys_log` VALUES ('500', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":8,\"id\":9,\"instruct\":\"0102035565\",\"name\":\"测试指令\",\"retExample\":\"0102035565\",\"type\":1}', '8', '192.168.1.103', '2021-04-01 16:16:28');
INSERT INTO `sys_log` VALUES ('501', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":8,\"id\":10,\"instruct\":\"0104035565\",\"name\":\"名称0102035565ss\",\"retExample\":\"0104035565\",\"type\":0}', '7', '192.168.1.103', '2021-04-01 16:16:44');
INSERT INTO `sys_log` VALUES ('502', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":1,\"cut\":0,\"dataWarn\":0,\"highLowConvert\":0,\"id\":9,\"instructId\":10,\"length\":2,\"name\":\"test\",\"start\":4}', '24', '192.168.1.103', '2021-04-01 20:42:23');
INSERT INTO `sys_log` VALUES ('503', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"bindData\":9,\"convertTo\":1,\"cut\":0,\"dataWarn\":0,\"highLowConvert\":0,\"id\":10,\"instructId\":9,\"length\":2,\"name\":\"测试关联项\",\"start\":4}', '8', '192.168.1.103', '2021-04-01 20:47:52');
INSERT INTO `sys_log` VALUES ('504', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":160,\"name\":\"手动发送指令\",\"parentId\":128,\"perms\":\"connectEquipment.equipment.sendInstruct\",\"type\":3}', '21', '192.168.1.103', '2021-04-01 22:40:43');
INSERT INTO `sys_log` VALUES ('505', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[57,58,59,60,61,62,63,65,66,67,68,64,69,70,71,72,73,78,79,80,81,74,76,77,82,83,84,85,86,87,88,89,90,91,92,93,132,133,126,127,129,130,131,128,134,135,136,137,138,139,140,141,142,143,144,145,150,151,152,153],\"remark\":\"超级管理员角色666\",\"roleId\":1,\"roleName\":\"超级管理员\",\"shopRole\":0}', '168', '192.168.1.103', '2021-04-01 22:40:52');
INSERT INTO `sys_log` VALUES ('506', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '9', '0', '192.168.1.103', '2021-04-01 22:43:57');
INSERT INTO `sys_log` VALUES ('507', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '9', '0', '192.168.1.103', '2021-04-01 22:44:54');
INSERT INTO `sys_log` VALUES ('508', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '9', '12', '192.168.1.103', '2021-04-01 22:46:11');
INSERT INTO `sys_log` VALUES ('509', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '9', '3', '192.168.1.103', '2021-04-01 22:46:29');
INSERT INTO `sys_log` VALUES ('510', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '9', '3', '192.168.1.103', '2021-04-01 22:46:43');
INSERT INTO `sys_log` VALUES ('511', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '9', '5', '192.168.1.103', '2021-04-01 22:50:05');
INSERT INTO `sys_log` VALUES ('512', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '9', '72624', '192.168.1.103', '2021-04-01 22:51:31');
INSERT INTO `sys_log` VALUES ('513', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '9', '9812', '192.168.1.103', '2021-04-01 22:52:07');
INSERT INTO `sys_log` VALUES ('514', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '9', '4', '192.168.1.103', '2021-04-01 23:08:50');
INSERT INTO `sys_log` VALUES ('515', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '9', '12', '192.168.1.103', '2021-04-01 23:11:07');
INSERT INTO `sys_log` VALUES ('516', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '9', '4', '192.168.1.103', '2021-04-01 23:11:11');
INSERT INTO `sys_log` VALUES ('517', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '9', '2', '192.168.1.103', '2021-04-01 23:11:16');
INSERT INTO `sys_log` VALUES ('518', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '9', '4', '192.168.1.103', '2021-04-01 23:11:19');
INSERT INTO `sys_log` VALUES ('519', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '9', '3', '192.168.1.103', '2021-04-01 23:11:25');
INSERT INTO `sys_log` VALUES ('520', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '9', '3', '192.168.1.103', '2021-04-01 23:11:26');
INSERT INTO `sys_log` VALUES ('521', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '9', '4', '192.168.1.103', '2021-04-01 23:11:28');
INSERT INTO `sys_log` VALUES ('522', 'admin', '保存配置', 'com.antd.modules.sys.controller.SysConfigController.save()', '{\"id\":7,\"paramKey\":\"tes\",\"paramValue\":\"424\",\"remark\":\"4234\"}', '293', '192.168.43.34', '2021-05-07 21:07:30');
INSERT INTO `sys_log` VALUES ('523', 'admin', '保存配置', 'com.antd.modules.sys.controller.SysConfigController.save()', '{\"id\":8,\"paramKey\":\"542523\",\"paramValue\":\"2423\",\"remark\":\"4234234\"}', '54848', '192.168.43.34', '2021-05-07 21:09:32');
INSERT INTO `sys_log` VALUES ('524', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":13,\"name\":\"8266LED演示例子\",\"port\":3308,\"single\":0,\"type\":1}', '36', '192.168.43.34', '2021-05-12 17:34:14');
INSERT INTO `sys_log` VALUES ('525', 'admin', '保存或修改模块', 'com.antd.modules.security.controller.SecEquipmentController.modularSaveOrUpdate()', '{\"connectId\":13,\"id\":8,\"instructInterval\":1000,\"isUp\":0,\"name\":\"8266LED模块\",\"queryInterval\":1000,\"verify\":\"abcd\"}', '67', '192.168.43.34', '2021-05-12 17:37:17');
INSERT INTO `sys_log` VALUES ('526', 'admin', '保存或修改设备', 'com.antd.modules.security.controller.SecEquipmentController.equipmentSaveOrUpdate()', '{\"id\":9,\"modularId\":8,\"name\":\"LED灯\"}', '6', '192.168.43.34', '2021-05-12 17:39:28');
INSERT INTO `sys_log` VALUES ('527', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":9,\"id\":11,\"instruct\":\"000100aaaa\",\"name\":\"查询灯的状态\",\"retExample\":\"000101aaaa\",\"type\":0}', '9', '192.168.43.34', '2021-05-12 17:39:54');
INSERT INTO `sys_log` VALUES ('528', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":1,\"cut\":0,\"dataWarn\":0,\"highLowConvert\":0,\"id\":11,\"instructId\":11,\"length\":1,\"name\":\"灯状态\",\"start\":5}', '13', '192.168.43.34', '2021-05-12 17:40:47');
INSERT INTO `sys_log` VALUES ('529', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":9,\"id\":12,\"instruct\":\"000201aaaa\",\"name\":\"开灯\",\"retExample\":\"000201aaaa\",\"type\":1}', '4', '192.168.43.34', '2021-05-12 17:41:11');
INSERT INTO `sys_log` VALUES ('530', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":9,\"id\":13,\"instruct\":\"000200aaaa\",\"name\":\"关灯\",\"retExample\":\"000200aaaa\",\"type\":0}', '4', '192.168.43.34', '2021-05-12 17:41:33');
INSERT INTO `sys_log` VALUES ('531', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":9,\"id\":13,\"instruct\":\"000200aaaa\",\"name\":\"关灯\",\"retExample\":\"000200aaaa\",\"type\":1}', '20', '192.168.43.34', '2021-05-12 17:41:46');
INSERT INTO `sys_log` VALUES ('532', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '4', '192.168.43.34', '2021-05-12 17:42:56');
INSERT INTO `sys_log` VALUES ('533', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-12 17:43:07');
INSERT INTO `sys_log` VALUES ('534', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-12 17:43:30');
INSERT INTO `sys_log` VALUES ('535', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"bindData\":11,\"convertTo\":1,\"cut\":0,\"dataWarn\":0,\"highLowConvert\":0,\"id\":12,\"instructId\":13,\"length\":1,\"name\":\"关灯解析\",\"start\":5}', '6', '192.168.43.34', '2021-05-12 17:44:21');
INSERT INTO `sys_log` VALUES ('536', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"bindData\":11,\"convertTo\":1,\"cut\":0,\"dataWarn\":0,\"highLowConvert\":0,\"id\":13,\"instructId\":12,\"length\":1,\"name\":\"开灯解析\",\"start\":5}', '4', '192.168.43.34', '2021-05-12 17:44:43');
INSERT INTO `sys_log` VALUES ('537', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '1', '192.168.43.34', '2021-05-12 17:44:51');
INSERT INTO `sys_log` VALUES ('538', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '13', '2', '192.168.43.34', '2021-05-12 17:45:33');
INSERT INTO `sys_log` VALUES ('539', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '3', '192.168.43.34', '2021-05-12 17:45:40');
INSERT INTO `sys_log` VALUES ('540', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '13', '1', '192.168.43.34', '2021-05-12 17:45:46');
INSERT INTO `sys_log` VALUES ('541', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-12 17:46:57');
INSERT INTO `sys_log` VALUES ('542', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-12 17:47:13');
INSERT INTO `sys_log` VALUES ('543', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-12 17:47:34');
INSERT INTO `sys_log` VALUES ('544', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-12 17:47:38');
INSERT INTO `sys_log` VALUES ('545', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-12 17:47:43');
INSERT INTO `sys_log` VALUES ('546', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-12 17:48:41');
INSERT INTO `sys_log` VALUES ('547', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-12 17:48:59');
INSERT INTO `sys_log` VALUES ('548', 'admin', '保存或修改模块', 'com.antd.modules.security.controller.SecEquipmentController.modularSaveOrUpdate()', '{\"connectId\":13,\"id\":8,\"instructInterval\":4000,\"isUp\":0,\"name\":\"8266LED模块\",\"queryInterval\":4000,\"verify\":\"abcd\"}', '7', '192.168.43.34', '2021-05-12 17:49:24');
INSERT INTO `sys_log` VALUES ('549', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '3', '192.168.43.34', '2021-05-12 17:50:57');
INSERT INTO `sys_log` VALUES ('550', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '3', '192.168.43.34', '2021-05-12 17:51:15');
INSERT INTO `sys_log` VALUES ('551', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-12 17:52:57');
INSERT INTO `sys_log` VALUES ('552', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-12 17:55:44');
INSERT INTO `sys_log` VALUES ('553', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-12 18:02:41');
INSERT INTO `sys_log` VALUES ('554', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '3', '192.168.43.34', '2021-05-12 18:03:17');
INSERT INTO `sys_log` VALUES ('555', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-12 18:06:22');
INSERT INTO `sys_log` VALUES ('556', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '13', '2', '192.168.43.34', '2021-05-12 18:06:56');
INSERT INTO `sys_log` VALUES ('557', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-12 18:07:02');
INSERT INTO `sys_log` VALUES ('558', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '13', '2', '192.168.43.34', '2021-05-12 18:10:11');
INSERT INTO `sys_log` VALUES ('559', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '1', '192.168.43.34', '2021-05-12 18:10:53');
INSERT INTO `sys_log` VALUES ('560', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '13', '3', '192.168.43.34', '2021-05-12 18:10:58');
INSERT INTO `sys_log` VALUES ('561', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-12 18:15:13');
INSERT INTO `sys_log` VALUES ('562', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '13', '2', '192.168.43.34', '2021-05-12 18:15:48');
INSERT INTO `sys_log` VALUES ('563', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-12 19:20:12');
INSERT INTO `sys_log` VALUES ('564', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '13', '2', '192.168.43.34', '2021-05-12 19:20:18');
INSERT INTO `sys_log` VALUES ('565', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-12 19:22:29');
INSERT INTO `sys_log` VALUES ('566', 'admin', '保存或修改菜单', 'com.antd.modules.sys.controller.SysMenuController.save()', '{\"menuId\":161,\"name\":\"测试菜单\",\"parentId\":126,\"perms\":\"connectEquipment.test\",\"type\":2}', '17', '192.168.43.34', '2021-05-12 19:45:30');
INSERT INTO `sys_log` VALUES ('567', 'admin', '保存或修改用户', 'com.antd.modules.sys.controller.SysUserController.save()', '{\"createTime\":1620820017772,\"email\":\"test1@qq.com\",\"mobile\":\"17803215666\",\"password\":\"ba2373c2eae005620746a4df5e2efca51a8e565e4e37fc41ccb431adc9d80042\",\"roleIdList\":[8],\"salt\":\"Q3AW4PHB2fQ43jTS9Z2L\",\"status\":1,\"userId\":29,\"username\":\"test1\"}', '103', '192.168.43.34', '2021-05-12 19:46:58');
INSERT INTO `sys_log` VALUES ('568', 'admin', '保存或修改角色', 'com.antd.modules.sys.controller.SysRoleController.save()', '{\"menuIdList\":[62,128,134,135,136,137,138,139,140,141,142,143,144,145,160,59,127,129,130,131,161,126],\"remark\":\"test\",\"roleId\":8,\"roleName\":\"test\",\"shopRole\":1}', '47', '192.168.43.34', '2021-05-12 19:47:29');
INSERT INTO `sys_log` VALUES ('569', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '13', '2', '192.168.43.34', '2021-05-12 19:52:33');
INSERT INTO `sys_log` VALUES ('570', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-12 20:11:11');
INSERT INTO `sys_log` VALUES ('571', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '13', '2', '192.168.43.34', '2021-05-12 20:11:19');
INSERT INTO `sys_log` VALUES ('572', 'admin', '保存或修改设备', 'com.antd.modules.security.controller.SecEquipmentController.equipmentSaveOrUpdate()', '{\"id\":10,\"modularId\":8,\"name\":\"温度模块\",\"remark\":\"温度模块\"}', '18', '192.168.43.34', '2021-05-19 15:49:20');
INSERT INTO `sys_log` VALUES ('573', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":10,\"id\":14,\"instruct\":\"000300aaaa\",\"name\":\"温度读取\",\"retExample\":\"000300000000aaaa\",\"type\":0}', '8', '192.168.43.34', '2021-05-19 15:49:46');
INSERT INTO `sys_log` VALUES ('574', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":2,\"cut\":0,\"dataWarn\":0,\"highLowConvert\":0,\"id\":14,\"instructId\":14,\"length\":8,\"name\":\"温度值\",\"start\":4}', '23', '192.168.43.34', '2021-05-19 15:54:23');
INSERT INTO `sys_log` VALUES ('575', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '3', '192.168.43.34', '2021-05-19 15:58:32');
INSERT INTO `sys_log` VALUES ('576', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-19 15:59:07');
INSERT INTO `sys_log` VALUES ('577', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '3', '192.168.43.34', '2021-05-19 16:02:25');
INSERT INTO `sys_log` VALUES ('578', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '3', '192.168.43.34', '2021-05-19 16:14:04');
INSERT INTO `sys_log` VALUES ('579', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '3', '192.168.43.34', '2021-05-19 16:14:59');
INSERT INTO `sys_log` VALUES ('580', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '13', '3', '192.168.43.34', '2021-05-19 16:15:29');
INSERT INTO `sys_log` VALUES ('581', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '3', '192.168.43.34', '2021-05-19 16:15:31');
INSERT INTO `sys_log` VALUES ('582', 'admin', '保存或修改模块', 'com.antd.modules.security.controller.SecEquipmentController.modularSaveOrUpdate()', '{\"connectId\":13,\"id\":8,\"instructInterval\":1000,\"isUp\":0,\"name\":\"8266LED模块\",\"queryInterval\":1000,\"verify\":\"abcd\"}', '17', '192.168.43.34', '2021-05-19 16:20:04');
INSERT INTO `sys_log` VALUES ('583', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '5', '192.168.43.34', '2021-05-19 16:23:12');
INSERT INTO `sys_log` VALUES ('584', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '13', '2', '192.168.43.34', '2021-05-19 16:23:33');
INSERT INTO `sys_log` VALUES ('585', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-19 16:50:23');
INSERT INTO `sys_log` VALUES ('586', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '13', '2', '192.168.43.34', '2021-05-19 16:50:27');
INSERT INTO `sys_log` VALUES ('587', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '2', '192.168.43.34', '2021-05-19 17:27:14');
INSERT INTO `sys_log` VALUES ('588', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '13', '1', '192.168.43.34', '2021-05-19 17:27:22');
INSERT INTO `sys_log` VALUES ('589', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '1', '192.168.43.34', '2021-05-19 17:27:28');
INSERT INTO `sys_log` VALUES ('590', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '13', '2', '192.168.43.34', '2021-05-19 17:27:30');
INSERT INTO `sys_log` VALUES ('591', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":14,\"name\":\"测试设备连接\",\"port\":3309,\"single\":0,\"type\":1}', '15', '192.168.3.127', '2021-05-19 20:21:31');
INSERT INTO `sys_log` VALUES ('592', 'admin', '保存或修改连接', 'com.antd.modules.security.controller.SecConnectController.saveOrUpdate()', '{\"id\":14,\"name\":\"综合控制设备\",\"port\":3309,\"single\":0,\"type\":1}', '15', '192.168.3.127', '2021-05-19 20:21:45');
INSERT INTO `sys_log` VALUES ('593', 'admin', '保存或修改模块', 'com.antd.modules.security.controller.SecEquipmentController.modularSaveOrUpdate()', '{\"connectId\":14,\"id\":9,\"instructInterval\":1000,\"isUp\":0,\"name\":\"综合模块\",\"queryInterval\":1000,\"verify\":\"aabc\"}', '12', '192.168.3.127', '2021-05-19 20:22:19');
INSERT INTO `sys_log` VALUES ('594', 'admin', '保存或修改设备', 'com.antd.modules.security.controller.SecEquipmentController.equipmentSaveOrUpdate()', '{\"id\":11,\"modularId\":9,\"name\":\"LED灯\"}', '5', '192.168.3.127', '2021-05-19 20:22:52');
INSERT INTO `sys_log` VALUES ('595', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":11,\"id\":15,\"instruct\":\"000001aaaa\",\"name\":\"红灯开\",\"retExample\":\"000001aaaa\",\"type\":1}', '8', '192.168.3.127', '2021-05-19 20:23:19');
INSERT INTO `sys_log` VALUES ('596', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":11,\"id\":16,\"instruct\":\"000300aaaa\",\"name\":\"红灯查询\",\"retExample\":\"000301aaaa\",\"type\":0}', '5', '192.168.3.127', '2021-05-19 20:23:46');
INSERT INTO `sys_log` VALUES ('597', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":1,\"cut\":0,\"dataWarn\":0,\"highLowConvert\":0,\"id\":15,\"instructId\":15,\"length\":1,\"name\":\"红灯开\",\"start\":5}', '11', '192.168.3.127', '2021-05-19 20:24:20');
INSERT INTO `sys_log` VALUES ('598', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":1,\"cut\":0,\"dataWarn\":0,\"highLowConvert\":0,\"id\":16,\"instructId\":16,\"length\":1,\"name\":\"红灯状态\",\"start\":5}', '6', '192.168.3.127', '2021-05-19 20:24:45');
INSERT INTO `sys_log` VALUES ('599', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"bindData\":16,\"convertTo\":1,\"cut\":0,\"dataWarn\":0,\"highLowConvert\":0,\"id\":15,\"instructId\":15,\"length\":1,\"name\":\"红灯开\",\"start\":5}', '13', '192.168.3.127', '2021-05-19 20:24:51');
INSERT INTO `sys_log` VALUES ('600', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":11,\"id\":17,\"instruct\":\"000000aaaa\",\"name\":\"红灯关\",\"retExample\":\"000000aaaa\",\"type\":1}', '5', '192.168.3.127', '2021-05-19 20:25:13');
INSERT INTO `sys_log` VALUES ('601', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"bindData\":16,\"convertTo\":1,\"cut\":0,\"dataWarn\":0,\"highLowConvert\":0,\"id\":17,\"instructId\":17,\"length\":1,\"name\":\"红灯关\",\"start\":5}', '5', '192.168.3.127', '2021-05-19 20:25:30');
INSERT INTO `sys_log` VALUES ('602', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":11,\"id\":18,\"instruct\":\"000400aaaa\",\"name\":\"绿灯查询\",\"retExample\":\"000401aaaa\",\"type\":0}', '6', '192.168.3.127', '2021-05-19 20:26:13');
INSERT INTO `sys_log` VALUES ('603', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":1,\"cut\":0,\"dataWarn\":0,\"highLowConvert\":0,\"id\":18,\"instructId\":18,\"length\":1,\"name\":\"绿灯状态\",\"start\":5}', '4', '192.168.3.127', '2021-05-19 20:26:29');
INSERT INTO `sys_log` VALUES ('604', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":11,\"id\":19,\"instruct\":\"000101aaaa\",\"name\":\"绿灯开\",\"retExample\":\"000101aaaa\",\"type\":1}', '5', '192.168.3.127', '2021-05-19 20:26:47');
INSERT INTO `sys_log` VALUES ('605', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"bindData\":18,\"convertTo\":1,\"cut\":0,\"dataWarn\":0,\"highLowConvert\":0,\"id\":19,\"instructId\":19,\"length\":1,\"name\":\"绿灯开\",\"start\":5}', '5', '192.168.3.127', '2021-05-19 20:27:03');
INSERT INTO `sys_log` VALUES ('606', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":11,\"id\":20,\"instruct\":\"000100aaaa\",\"name\":\"绿灯关\",\"retExample\":\"000100aaaa\",\"type\":1}', '3', '192.168.3.127', '2021-05-19 20:27:22');
INSERT INTO `sys_log` VALUES ('607', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"bindData\":18,\"convertTo\":1,\"cut\":0,\"dataWarn\":0,\"highLowConvert\":0,\"id\":20,\"instructId\":20,\"length\":1,\"name\":\"绿灯关\",\"start\":5}', '6', '192.168.3.127', '2021-05-19 20:27:34');
INSERT INTO `sys_log` VALUES ('608', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":11,\"id\":21,\"instruct\":\"000500aaaa\",\"name\":\"蓝灯查询\",\"retExample\":\"000501aaaa\",\"type\":0}', '6', '192.168.3.127', '2021-05-19 20:27:52');
INSERT INTO `sys_log` VALUES ('609', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":1,\"cut\":0,\"dataWarn\":0,\"highLowConvert\":0,\"id\":21,\"instructId\":21,\"length\":1,\"name\":\"蓝灯状态\",\"start\":5}', '5', '192.168.3.127', '2021-05-19 20:28:04');
INSERT INTO `sys_log` VALUES ('610', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":11,\"id\":22,\"instruct\":\"000201aaaa\",\"name\":\"蓝灯开\",\"retExample\":\"000201aaaa\",\"type\":1}', '6', '192.168.3.127', '2021-05-19 20:28:17');
INSERT INTO `sys_log` VALUES ('611', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"bindData\":21,\"convertTo\":1,\"cut\":0,\"dataWarn\":0,\"highLowConvert\":0,\"id\":22,\"instructId\":22,\"length\":1,\"name\":\"蓝灯开\",\"start\":5}', '4', '192.168.3.127', '2021-05-19 20:28:30');
INSERT INTO `sys_log` VALUES ('612', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":11,\"id\":23,\"instruct\":\"000200aaaa\",\"name\":\"蓝灯关\",\"retExample\":\"000200aaaa\",\"type\":1}', '5', '192.168.3.127', '2021-05-19 20:28:56');
INSERT INTO `sys_log` VALUES ('613', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"bindData\":21,\"convertTo\":1,\"cut\":0,\"dataWarn\":0,\"highLowConvert\":0,\"id\":23,\"instructId\":23,\"length\":1,\"name\":\"蓝灯关\",\"start\":5}', '5', '192.168.3.127', '2021-05-19 20:29:11');
INSERT INTO `sys_log` VALUES ('614', 'admin', '保存或修改设备', 'com.antd.modules.security.controller.SecEquipmentController.equipmentSaveOrUpdate()', '{\"id\":12,\"modularId\":9,\"name\":\"温度模块\"}', '6', '192.168.3.127', '2021-05-19 20:29:22');
INSERT INTO `sys_log` VALUES ('615', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":12,\"id\":24,\"instruct\":\"000600aaaa\",\"name\":\"温度查询\",\"retExample\":\"000600000000aaaa\",\"type\":0}', '5', '192.168.3.127', '2021-05-19 20:29:49');
INSERT INTO `sys_log` VALUES ('616', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":2,\"cut\":0,\"dataWarn\":0,\"highLowConvert\":0,\"id\":24,\"instructId\":24,\"length\":8,\"name\":\"温度值\",\"start\":4}', '4', '192.168.3.127', '2021-05-19 20:30:06');
INSERT INTO `sys_log` VALUES ('617', 'admin', '保存或修改设备', 'com.antd.modules.security.controller.SecEquipmentController.equipmentSaveOrUpdate()', '{\"id\":13,\"modularId\":9,\"name\":\"继电器模块\"}', '4', '192.168.3.127', '2021-05-19 20:30:20');
INSERT INTO `sys_log` VALUES ('618', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":13,\"id\":25,\"instruct\":\"000800aaaa\",\"name\":\"继电器查询\",\"retExample\":\"000801aaaa\",\"type\":0}', '5', '192.168.3.127', '2021-05-19 20:30:37');
INSERT INTO `sys_log` VALUES ('619', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"convertTo\":1,\"cut\":0,\"dataWarn\":0,\"highLowConvert\":0,\"id\":25,\"instructId\":25,\"length\":1,\"name\":\"继电器状态\",\"start\":5}', '7', '192.168.3.127', '2021-05-19 20:30:48');
INSERT INTO `sys_log` VALUES ('620', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":13,\"id\":26,\"instruct\":\"000701aaaa\",\"name\":\"继电器开\",\"retExample\":\"000701aaaa\",\"type\":1}', '5', '192.168.3.127', '2021-05-19 20:31:07');
INSERT INTO `sys_log` VALUES ('621', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"bindData\":25,\"convertTo\":1,\"cut\":0,\"dataWarn\":0,\"highLowConvert\":0,\"id\":26,\"instructId\":26,\"length\":1,\"name\":\"继电器开\",\"start\":5}', '6', '192.168.3.127', '2021-05-19 20:31:17');
INSERT INTO `sys_log` VALUES ('622', 'admin', '保存或修改指令', 'com.antd.modules.security.controller.SecEquipmentController.instructSaveOrUpdate()', '{\"equipmentId\":13,\"id\":27,\"instruct\":\"000700aaaa\",\"name\":\"继电器关\",\"retExample\":\"000700aaaa\",\"type\":1}', '4', '192.168.3.127', '2021-05-19 20:31:34');
INSERT INTO `sys_log` VALUES ('623', 'admin', '保存或修改数据项', 'com.antd.modules.security.controller.SecEquipmentController.dataSaveOrUpdate()', '{\"bindData\":25,\"convertTo\":1,\"cut\":0,\"dataWarn\":0,\"highLowConvert\":0,\"id\":27,\"instructId\":27,\"length\":1,\"name\":\"继电器关\",\"start\":5}', '3', '192.168.3.127', '2021-05-19 20:31:49');
INSERT INTO `sys_log` VALUES ('624', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '3', '127.0.0.1', '2021-05-19 20:49:56');
INSERT INTO `sys_log` VALUES ('625', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '2', '192.168.43.34', '2021-05-19 20:50:59');
INSERT INTO `sys_log` VALUES ('626', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '2', '192.168.43.34', '2021-05-19 20:52:59');
INSERT INTO `sys_log` VALUES ('627', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '2', '192.168.43.34', '2021-05-19 20:53:05');
INSERT INTO `sys_log` VALUES ('628', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '2', '192.168.43.34', '2021-05-19 20:53:16');
INSERT INTO `sys_log` VALUES ('629', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '1', '192.168.43.34', '2021-05-19 20:53:21');
INSERT INTO `sys_log` VALUES ('630', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '2', '192.168.43.34', '2021-05-19 20:54:56');
INSERT INTO `sys_log` VALUES ('631', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '1', '192.168.43.34', '2021-05-19 20:55:03');
INSERT INTO `sys_log` VALUES ('632', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '1', '192.168.43.34', '2021-05-19 20:55:06');
INSERT INTO `sys_log` VALUES ('633', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '1', '192.168.43.34', '2021-05-19 20:55:12');
INSERT INTO `sys_log` VALUES ('634', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '1', '192.168.43.34', '2021-05-19 20:55:18');
INSERT INTO `sys_log` VALUES ('635', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '15', '1', '192.168.43.34', '2021-05-19 20:55:56');
INSERT INTO `sys_log` VALUES ('636', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '17', '2', '192.168.43.34', '2021-05-19 20:56:05');
INSERT INTO `sys_log` VALUES ('637', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '19', '2', '192.168.43.34', '2021-05-19 20:56:11');
INSERT INTO `sys_log` VALUES ('638', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '2', '192.168.43.34', '2021-05-19 20:56:17');
INSERT INTO `sys_log` VALUES ('639', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '19', '2', '192.168.43.34', '2021-05-19 20:56:29');
INSERT INTO `sys_log` VALUES ('640', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '1', '192.168.43.34', '2021-05-19 21:07:12');
INSERT INTO `sys_log` VALUES ('641', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '19', '1', '192.168.43.34', '2021-05-19 21:07:17');
INSERT INTO `sys_log` VALUES ('642', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '15', '2', '192.168.43.34', '2021-05-19 21:07:24');
INSERT INTO `sys_log` VALUES ('643', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '2', '192.168.43.34', '2021-05-19 21:07:35');
INSERT INTO `sys_log` VALUES ('644', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '1', '192.168.43.34', '2021-05-19 21:07:48');
INSERT INTO `sys_log` VALUES ('645', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '2', '192.168.43.34', '2021-05-19 21:07:57');
INSERT INTO `sys_log` VALUES ('646', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '2', '192.168.43.34', '2021-05-19 21:08:01');
INSERT INTO `sys_log` VALUES ('647', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '2', '192.168.43.34', '2021-05-19 21:08:05');
INSERT INTO `sys_log` VALUES ('648', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '2', '192.168.43.34', '2021-05-19 21:08:07');
INSERT INTO `sys_log` VALUES ('649', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '2', '192.168.43.34', '2021-05-19 21:11:05');
INSERT INTO `sys_log` VALUES ('650', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '1', '192.168.43.34', '2021-05-19 21:11:11');
INSERT INTO `sys_log` VALUES ('651', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '2', '192.168.43.34', '2021-05-19 21:11:15');
INSERT INTO `sys_log` VALUES ('652', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '1', '192.168.43.34', '2021-05-19 21:11:21');
INSERT INTO `sys_log` VALUES ('653', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '2', '192.168.43.34', '2021-05-19 21:12:02');
INSERT INTO `sys_log` VALUES ('654', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '19', '1', '192.168.43.34', '2021-05-19 21:12:06');
INSERT INTO `sys_log` VALUES ('655', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '15', '2', '192.168.43.34', '2021-05-19 21:12:12');
INSERT INTO `sys_log` VALUES ('656', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '19', '2', '192.168.43.34', '2021-05-19 21:12:16');
INSERT INTO `sys_log` VALUES ('657', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '20', '1', '192.168.43.34', '2021-05-19 21:12:21');
INSERT INTO `sys_log` VALUES ('658', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '1', '192.168.43.34', '2021-05-19 21:12:25');
INSERT INTO `sys_log` VALUES ('659', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '20', '1', '192.168.43.34', '2021-05-19 21:12:27');
INSERT INTO `sys_log` VALUES ('660', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '23', '2', '192.168.43.34', '2021-05-19 21:12:36');
INSERT INTO `sys_log` VALUES ('661', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '15', '2', '192.168.43.34', '2021-05-19 21:12:48');
INSERT INTO `sys_log` VALUES ('662', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '17', '2', '192.168.43.34', '2021-05-19 21:12:54');
INSERT INTO `sys_log` VALUES ('663', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '19', '1', '192.168.43.34', '2021-05-19 21:12:58');
INSERT INTO `sys_log` VALUES ('664', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '2', '192.168.43.34', '2021-05-19 21:15:42');
INSERT INTO `sys_log` VALUES ('665', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '2', '192.168.43.34', '2021-05-19 21:15:44');
INSERT INTO `sys_log` VALUES ('666', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '1', '192.168.43.34', '2021-05-19 21:15:46');
INSERT INTO `sys_log` VALUES ('667', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '2', '192.168.43.34', '2021-05-19 21:15:52');
INSERT INTO `sys_log` VALUES ('668', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '1', '192.168.43.34', '2021-05-19 21:15:55');
INSERT INTO `sys_log` VALUES ('669', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '1', '192.168.43.34', '2021-05-19 21:15:57');
INSERT INTO `sys_log` VALUES ('670', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '2', '192.168.43.34', '2021-05-19 21:17:39');
INSERT INTO `sys_log` VALUES ('671', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '1', '192.168.43.34', '2021-05-19 21:17:42');
INSERT INTO `sys_log` VALUES ('672', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '2', '192.168.43.34', '2021-05-19 21:17:43');
INSERT INTO `sys_log` VALUES ('673', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '1', '192.168.43.34', '2021-05-19 21:17:45');
INSERT INTO `sys_log` VALUES ('674', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '4', '192.168.43.34', '2021-05-20 13:05:47');
INSERT INTO `sys_log` VALUES ('675', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '3', '192.168.43.34', '2021-05-20 13:05:52');
INSERT INTO `sys_log` VALUES ('676', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '3', '192.168.43.34', '2021-05-20 13:06:01');
INSERT INTO `sys_log` VALUES ('677', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '15', '3', '192.168.43.34', '2021-05-20 13:06:15');
INSERT INTO `sys_log` VALUES ('678', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '19', '2', '192.168.43.34', '2021-05-20 13:06:29');
INSERT INTO `sys_log` VALUES ('679', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '3', '192.168.43.34', '2021-05-20 13:12:27');
INSERT INTO `sys_log` VALUES ('680', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '3', '192.168.43.34', '2021-05-20 13:12:32');
INSERT INTO `sys_log` VALUES ('681', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '23', '2', '192.168.43.34', '2021-05-20 13:12:53');
INSERT INTO `sys_log` VALUES ('682', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '20', '3', '192.168.43.34', '2021-05-20 13:13:01');
INSERT INTO `sys_log` VALUES ('683', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '17', '2', '192.168.43.34', '2021-05-20 13:13:05');
INSERT INTO `sys_log` VALUES ('684', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '15', '2', '192.168.43.34', '2021-05-20 13:13:13');
INSERT INTO `sys_log` VALUES ('685', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '3', '192.168.43.34', '2021-05-20 13:15:33');
INSERT INTO `sys_log` VALUES ('686', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '15', '11', '192.168.43.34', '2021-05-20 13:31:13');
INSERT INTO `sys_log` VALUES ('687', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '15', '3', '192.168.43.34', '2021-05-20 13:32:16');
INSERT INTO `sys_log` VALUES ('688', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '3', '192.168.43.34', '2021-05-20 13:32:40');
INSERT INTO `sys_log` VALUES ('689', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '3', '192.168.43.34', '2021-05-20 13:57:05');
INSERT INTO `sys_log` VALUES ('690', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '3', '192.168.43.34', '2021-05-20 13:57:10');
INSERT INTO `sys_log` VALUES ('691', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '3', '192.168.43.34', '2021-05-20 13:57:16');
INSERT INTO `sys_log` VALUES ('692', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '15', '2', '192.168.43.34', '2021-05-20 13:57:24');
INSERT INTO `sys_log` VALUES ('693', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '19', '3', '192.168.43.34', '2021-05-20 13:57:32');
INSERT INTO `sys_log` VALUES ('694', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '2', '192.168.43.34', '2021-05-20 13:57:40');
INSERT INTO `sys_log` VALUES ('695', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '3', '192.168.43.34', '2021-05-20 13:58:38');
INSERT INTO `sys_log` VALUES ('696', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '1', '192.168.43.34', '2021-05-20 13:58:41');
INSERT INTO `sys_log` VALUES ('697', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '1', '192.168.43.34', '2021-05-20 13:58:45');
INSERT INTO `sys_log` VALUES ('698', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '1', '192.168.43.34', '2021-05-20 13:58:47');
INSERT INTO `sys_log` VALUES ('699', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '2', '192.168.43.34', '2021-05-20 13:58:53');
INSERT INTO `sys_log` VALUES ('700', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '2', '192.168.43.34', '2021-05-20 14:08:10');
INSERT INTO `sys_log` VALUES ('701', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '15', '1', '192.168.43.34', '2021-05-20 14:08:17');
INSERT INTO `sys_log` VALUES ('702', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '2', '192.168.43.34', '2021-05-20 14:08:38');
INSERT INTO `sys_log` VALUES ('703', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '2', '192.168.43.34', '2021-05-20 14:08:41');
INSERT INTO `sys_log` VALUES ('704', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '11', '192.168.43.34', '2021-05-20 15:35:37');
INSERT INTO `sys_log` VALUES ('705', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '3', '192.168.43.34', '2021-05-20 15:35:40');
INSERT INTO `sys_log` VALUES ('706', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '2', '192.168.43.34', '2021-05-20 15:35:46');
INSERT INTO `sys_log` VALUES ('707', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '23', '4', '192.168.43.34', '2021-05-20 15:35:49');
INSERT INTO `sys_log` VALUES ('708', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '17', '3', '192.168.43.34', '2021-05-20 15:35:52');
INSERT INTO `sys_log` VALUES ('709', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '15', '3', '192.168.43.34', '2021-05-20 15:35:56');
INSERT INTO `sys_log` VALUES ('710', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '19', '3', '192.168.43.34', '2021-05-20 15:35:59');
INSERT INTO `sys_log` VALUES ('711', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '20', '3', '192.168.43.34', '2021-05-20 15:36:03');
INSERT INTO `sys_log` VALUES ('712', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '2', '192.168.43.34', '2021-05-20 15:36:10');
INSERT INTO `sys_log` VALUES ('713', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '2', '192.168.43.34', '2021-05-20 15:36:22');
INSERT INTO `sys_log` VALUES ('714', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '23', '2', '192.168.43.34', '2021-05-20 15:37:19');
INSERT INTO `sys_log` VALUES ('715', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '1', '192.168.43.34', '2021-05-20 16:35:36');
INSERT INTO `sys_log` VALUES ('716', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '19', '2', '192.168.43.34', '2021-05-20 16:35:42');
INSERT INTO `sys_log` VALUES ('717', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '15', '2', '192.168.43.34', '2021-05-20 16:35:46');
INSERT INTO `sys_log` VALUES ('718', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '20', '2', '192.168.43.34', '2021-05-20 16:35:52');
INSERT INTO `sys_log` VALUES ('719', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '19', '1', '192.168.43.34', '2021-05-20 16:35:57');
INSERT INTO `sys_log` VALUES ('720', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '2', '192.168.43.34', '2021-05-20 16:36:08');
INSERT INTO `sys_log` VALUES ('721', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '15', '2', '192.168.43.34', '2021-05-20 16:38:25');
INSERT INTO `sys_log` VALUES ('722', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '1', '192.168.43.34', '2021-05-20 16:38:28');
INSERT INTO `sys_log` VALUES ('723', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '19', '2', '192.168.43.34', '2021-05-20 16:38:33');
INSERT INTO `sys_log` VALUES ('724', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '2', '192.168.43.34', '2021-05-20 16:38:43');
INSERT INTO `sys_log` VALUES ('725', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '2', '192.168.43.34', '2021-05-20 16:38:51');
INSERT INTO `sys_log` VALUES ('726', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '2', '192.168.43.34', '2021-05-20 16:38:56');
INSERT INTO `sys_log` VALUES ('727', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '2', '192.168.43.34', '2021-05-20 16:39:00');
INSERT INTO `sys_log` VALUES ('728', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '20', '3', '192.168.43.34', '2021-05-20 16:39:18');
INSERT INTO `sys_log` VALUES ('729', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '15', '2', '192.168.43.34', '2021-05-20 16:59:33');
INSERT INTO `sys_log` VALUES ('730', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '19', '3', '192.168.43.34', '2021-05-20 16:59:45');
INSERT INTO `sys_log` VALUES ('731', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '3', '192.168.43.34', '2021-05-20 16:59:50');
INSERT INTO `sys_log` VALUES ('732', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '2', '192.168.43.34', '2021-05-20 17:00:05');
INSERT INTO `sys_log` VALUES ('733', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '2', '192.168.43.34', '2021-05-20 17:00:12');
INSERT INTO `sys_log` VALUES ('734', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '3', '192.168.43.34', '2021-05-20 17:00:22');
INSERT INTO `sys_log` VALUES ('735', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '2', '192.168.43.34', '2021-05-20 17:00:24');
INSERT INTO `sys_log` VALUES ('736', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '2', '192.168.43.34', '2021-05-20 17:00:44');
INSERT INTO `sys_log` VALUES ('737', 'admin', '删除菜单', 'com.antd.modules.sys.controller.SysMenuController.delete()', '161', '22', '192.168.43.34', '2021-05-20 17:01:36');
INSERT INTO `sys_log` VALUES ('738', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '5', '192.168.43.34', '2021-05-24 19:45:02');
INSERT INTO `sys_log` VALUES ('739', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '3', '192.168.43.34', '2021-05-24 19:45:08');
INSERT INTO `sys_log` VALUES ('740', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '15', '3', '192.168.43.34', '2021-05-24 19:45:16');
INSERT INTO `sys_log` VALUES ('741', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '19', '2', '192.168.43.34', '2021-05-24 19:45:20');
INSERT INTO `sys_log` VALUES ('742', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '3', '192.168.43.34', '2021-05-24 19:45:26');
INSERT INTO `sys_log` VALUES ('743', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '23', '3', '192.168.43.34', '2021-05-24 19:45:29');
INSERT INTO `sys_log` VALUES ('744', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '39', '4', '192.168.43.34', '2021-05-24 20:17:39');
INSERT INTO `sys_log` VALUES ('745', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '40', '3', '192.168.43.34', '2021-05-24 20:17:45');
INSERT INTO `sys_log` VALUES ('746', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '35', '3', '192.168.43.34', '2021-05-24 20:17:50');
INSERT INTO `sys_log` VALUES ('747', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '32', '2', '192.168.43.34', '2021-05-24 20:17:53');
INSERT INTO `sys_log` VALUES ('748', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '28', '3', '192.168.43.34', '2021-05-24 20:17:56');
INSERT INTO `sys_log` VALUES ('749', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '30', '3', '192.168.43.34', '2021-05-24 20:17:59');
INSERT INTO `sys_log` VALUES ('750', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '3', '192.168.43.34', '2021-05-24 20:19:18');
INSERT INTO `sys_log` VALUES ('751', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '19', '2', '192.168.43.34', '2021-05-24 20:19:23');
INSERT INTO `sys_log` VALUES ('752', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '15', '3', '192.168.43.34', '2021-05-24 20:19:28');
INSERT INTO `sys_log` VALUES ('753', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '2', '192.168.43.34', '2021-05-24 20:19:45');
INSERT INTO `sys_log` VALUES ('754', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '1', '192.168.43.34', '2021-05-24 20:19:52');
INSERT INTO `sys_log` VALUES ('755', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '2', '192.168.43.34', '2021-05-24 20:20:06');
INSERT INTO `sys_log` VALUES ('756', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '3', '192.168.43.34', '2021-05-24 20:20:10');
INSERT INTO `sys_log` VALUES ('757', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '2', '192.168.43.34', '2021-05-24 20:20:12');
INSERT INTO `sys_log` VALUES ('758', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '3', '192.168.43.34', '2021-07-09 15:15:01');
INSERT INTO `sys_log` VALUES ('759', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '3', '192.168.43.34', '2021-07-09 15:15:04');
INSERT INTO `sys_log` VALUES ('760', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '15', '3', '192.168.43.34', '2021-07-09 15:15:12');
INSERT INTO `sys_log` VALUES ('761', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '19', '2', '192.168.43.34', '2021-07-09 15:15:16');
INSERT INTO `sys_log` VALUES ('762', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '2', '192.168.43.34', '2021-07-09 15:15:26');
INSERT INTO `sys_log` VALUES ('763', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '23', '2', '192.168.43.34', '2021-07-09 15:15:29');
INSERT INTO `sys_log` VALUES ('764', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '6', '127.0.0.1', '2021-07-09 16:09:54');
INSERT INTO `sys_log` VALUES ('765', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '15', '5', '127.0.0.1', '2021-07-09 16:10:12');
INSERT INTO `sys_log` VALUES ('766', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '19', '8', '127.0.0.1', '2021-07-09 16:10:20');
INSERT INTO `sys_log` VALUES ('767', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '6', '127.0.0.1', '2021-07-09 16:10:23');
INSERT INTO `sys_log` VALUES ('768', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '6', '127.0.0.1', '2021-07-09 16:12:34');
INSERT INTO `sys_log` VALUES ('769', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '39', '4', '127.0.0.1', '2021-07-09 16:12:46');
INSERT INTO `sys_log` VALUES ('770', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '4', '127.0.0.1', '2021-07-09 16:13:07');
INSERT INTO `sys_log` VALUES ('771', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '6', '127.0.0.1', '2021-07-09 16:13:46');
INSERT INTO `sys_log` VALUES ('772', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '4', '127.0.0.1', '2021-07-09 16:13:50');
INSERT INTO `sys_log` VALUES ('773', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '40', '346', '192.168.43.1', '2021-07-09 16:44:26');
INSERT INTO `sys_log` VALUES ('774', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '11', '120', '192.168.43.1', '2021-07-09 16:45:02');
INSERT INTO `sys_log` VALUES ('775', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '16', '211', '192.168.43.1', '2021-07-09 16:45:05');
INSERT INTO `sys_log` VALUES ('776', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '18', '67', '192.168.43.1', '2021-07-09 16:45:21');
INSERT INTO `sys_log` VALUES ('777', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '21', '192', '192.168.43.1', '2021-07-09 16:45:24');
INSERT INTO `sys_log` VALUES ('778', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '16', '248', '192.168.43.1', '2021-07-09 16:45:32');
INSERT INTO `sys_log` VALUES ('779', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '25', '110', '192.168.43.1', '2021-07-09 16:45:39');
INSERT INTO `sys_log` VALUES ('780', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '27', '187', '192.168.43.34', '2021-07-09 16:46:16');
INSERT INTO `sys_log` VALUES ('781', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '229', '192.168.43.34', '2021-07-09 16:46:19');
INSERT INTO `sys_log` VALUES ('782', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '25', '98', '192.168.43.1', '2021-07-09 16:46:27');
INSERT INTO `sys_log` VALUES ('783', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '26', '84', '192.168.43.34', '2021-07-09 16:46:32');
INSERT INTO `sys_log` VALUES ('784', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '40', '63', '192.168.43.1', '2021-07-09 16:46:40');
INSERT INTO `sys_log` VALUES ('785', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '34', '114', '192.168.43.1', '2021-07-09 16:46:41');
INSERT INTO `sys_log` VALUES ('786', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '31', '432', '192.168.43.1', '2021-07-09 16:46:42');
INSERT INTO `sys_log` VALUES ('787', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '29', '109', '192.168.43.1', '2021-07-09 16:46:43');
INSERT INTO `sys_log` VALUES ('788', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '25', '59', '192.168.43.1', '2021-07-09 16:46:45');
INSERT INTO `sys_log` VALUES ('789', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '7', '220', '192.168.43.1', '2021-07-09 16:46:51');
INSERT INTO `sys_log` VALUES ('790', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '8', '245', '192.168.43.1', '2021-07-09 16:46:52');
INSERT INTO `sys_log` VALUES ('791', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '16', '265', '192.168.43.1', '2021-07-09 16:47:08');
INSERT INTO `sys_log` VALUES ('792', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '18', '73', '192.168.43.1', '2021-07-09 16:47:09');
INSERT INTO `sys_log` VALUES ('793', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '21', '244', '192.168.43.1', '2021-07-09 16:47:10');
INSERT INTO `sys_log` VALUES ('794', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '18', '158', '192.168.43.1', '2021-07-09 16:47:11');
INSERT INTO `sys_log` VALUES ('795', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '16', '168', '192.168.43.1', '2021-07-09 16:47:12');
INSERT INTO `sys_log` VALUES ('796', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '18', '149', '192.168.43.1', '2021-07-09 16:47:13');
INSERT INTO `sys_log` VALUES ('797', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '16', '116', '192.168.43.1', '2021-07-09 16:47:13');
INSERT INTO `sys_log` VALUES ('798', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '18', '83', '192.168.43.1', '2021-07-09 16:47:14');
INSERT INTO `sys_log` VALUES ('799', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '18', '54', '192.168.43.1', '2021-07-09 16:47:14');
INSERT INTO `sys_log` VALUES ('800', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '16', '121', '192.168.43.1', '2021-07-09 16:47:14');
INSERT INTO `sys_log` VALUES ('801', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '16', '370', '192.168.43.1', '2021-07-09 16:47:15');
INSERT INTO `sys_log` VALUES ('802', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '40', '110', '192.168.43.1', '2021-07-09 17:07:06');
INSERT INTO `sys_log` VALUES ('803', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '25', '172', '192.168.43.1', '2021-07-09 17:07:09');
INSERT INTO `sys_log` VALUES ('804', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '25', '247', '192.168.43.1', '2021-07-09 17:07:14');
INSERT INTO `sys_log` VALUES ('805', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '21', '195', '192.168.43.1', '2021-07-09 17:07:17');
INSERT INTO `sys_log` VALUES ('806', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '18', '86', '192.168.43.1', '2021-07-09 17:07:19');
INSERT INTO `sys_log` VALUES ('807', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '16', '157', '192.168.43.1', '2021-07-09 17:07:20');
INSERT INTO `sys_log` VALUES ('808', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '21', '156', '192.168.43.1', '2021-07-09 17:07:28');
INSERT INTO `sys_log` VALUES ('809', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '36', '85', '192.168.43.34', '2021-07-09 17:07:28');
INSERT INTO `sys_log` VALUES ('810', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '18', '178', '192.168.43.1', '2021-07-09 17:07:29');
INSERT INTO `sys_log` VALUES ('811', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '16', '101', '192.168.43.1', '2021-07-09 17:07:29');
INSERT INTO `sys_log` VALUES ('812', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '14', '23', '192.168.43.1', '2021-07-09 17:07:30');
INSERT INTO `sys_log` VALUES ('813', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '24', '262', '192.168.43.1', '2021-07-09 17:07:33');
INSERT INTO `sys_log` VALUES ('814', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '35', '8', '192.168.43.34', '2021-07-09 17:07:36');
INSERT INTO `sys_log` VALUES ('815', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '35', '35', '192.168.43.34', '2021-07-09 17:07:41');
INSERT INTO `sys_log` VALUES ('816', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '22', '81', '192.168.43.34', '2021-07-09 17:07:54');
INSERT INTO `sys_log` VALUES ('817', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '16', '211', '192.168.43.1', '2021-07-09 17:08:00');
INSERT INTO `sys_log` VALUES ('818', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '18', '55', '192.168.43.1', '2021-07-09 17:08:00');
INSERT INTO `sys_log` VALUES ('819', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '21', '277', '192.168.43.1', '2021-07-09 17:08:01');
INSERT INTO `sys_log` VALUES ('820', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '16', '120', '192.168.43.1', '2021-07-09 17:08:02');
INSERT INTO `sys_log` VALUES ('821', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '16', '67', '192.168.43.1', '2021-07-09 17:08:02');
INSERT INTO `sys_log` VALUES ('822', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '23', '125', '192.168.43.34', '2021-07-09 17:08:07');
INSERT INTO `sys_log` VALUES ('823', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '11', '326', '192.168.43.1', '2021-07-09 17:08:16');
INSERT INTO `sys_log` VALUES ('824', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '9', '122', '192.168.43.1', '2021-07-09 17:08:17');
INSERT INTO `sys_log` VALUES ('825', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '21', '202', '192.168.43.1', '2021-07-09 17:08:19');
INSERT INTO `sys_log` VALUES ('826', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '18', '151', '192.168.43.1', '2021-07-09 17:08:20');
INSERT INTO `sys_log` VALUES ('827', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '16', '395', '192.168.43.1', '2021-07-09 17:08:21');
INSERT INTO `sys_log` VALUES ('828', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '16', '200', '192.168.43.1', '2021-07-09 17:08:39');
INSERT INTO `sys_log` VALUES ('829', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '18', '140', '192.168.43.1', '2021-07-09 17:08:41');
INSERT INTO `sys_log` VALUES ('830', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '21', '139', '192.168.43.1', '2021-07-09 17:08:55');
INSERT INTO `sys_log` VALUES ('831', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '18', '0:0:0:0:0:0:0:1', '2021-09-06 16:13:01');
INSERT INTO `sys_log` VALUES ('832', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '8', '127.0.0.1', '2021-09-06 16:16:46');
INSERT INTO `sys_log` VALUES ('833', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '13', '127.0.0.1', '2021-09-06 16:19:38');
INSERT INTO `sys_log` VALUES ('834', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '16', '127.0.0.1', '2021-09-06 16:34:14');
INSERT INTO `sys_log` VALUES ('835', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '11', '127.0.0.1', '2021-09-06 16:34:15');
INSERT INTO `sys_log` VALUES ('836', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '9', '127.0.0.1', '2021-09-06 16:39:06');
INSERT INTO `sys_log` VALUES ('837', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '8', '127.0.0.1', '2021-09-06 16:39:24');
INSERT INTO `sys_log` VALUES ('838', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '8', '127.0.0.1', '2021-09-06 16:47:23');
INSERT INTO `sys_log` VALUES ('839', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-06 16:47:23');
INSERT INTO `sys_log` VALUES ('840', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '21', '127.0.0.1', '2021-09-06 16:53:51');
INSERT INTO `sys_log` VALUES ('841', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-06 17:09:06');
INSERT INTO `sys_log` VALUES ('842', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '10', '127.0.0.1', '2021-09-06 17:09:53');
INSERT INTO `sys_log` VALUES ('843', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '6', '127.0.0.1', '2021-09-06 17:12:46');
INSERT INTO `sys_log` VALUES ('844', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-06 17:13:02');
INSERT INTO `sys_log` VALUES ('845', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '6', '127.0.0.1', '2021-09-06 17:13:11');
INSERT INTO `sys_log` VALUES ('846', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '9', '127.0.0.1', '2021-09-06 17:18:08');
INSERT INTO `sys_log` VALUES ('847', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '6', '127.0.0.1', '2021-09-06 17:18:23');
INSERT INTO `sys_log` VALUES ('848', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '11', '127.0.0.1', '2021-09-06 17:20:09');
INSERT INTO `sys_log` VALUES ('849', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-06 17:21:21');
INSERT INTO `sys_log` VALUES ('850', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-06 17:35:10');
INSERT INTO `sys_log` VALUES ('851', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-06 17:37:52');
INSERT INTO `sys_log` VALUES ('852', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '8', '127.0.0.1', '2021-09-06 17:38:29');
INSERT INTO `sys_log` VALUES ('853', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '6', '127.0.0.1', '2021-09-06 18:23:56');
INSERT INTO `sys_log` VALUES ('854', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '12', '127.0.0.1', '2021-09-06 18:24:35');
INSERT INTO `sys_log` VALUES ('855', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '39', '21', '0:0:0:0:0:0:0:1', '2021-09-06 18:45:31');
INSERT INTO `sys_log` VALUES ('856', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '39', '21', '0:0:0:0:0:0:0:1', '2021-09-06 18:45:31');
INSERT INTO `sys_log` VALUES ('857', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '39', '6', '0:0:0:0:0:0:0:1', '2021-09-06 18:45:34');
INSERT INTO `sys_log` VALUES ('858', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '39', '6', '0:0:0:0:0:0:0:1', '2021-09-06 18:45:48');
INSERT INTO `sys_log` VALUES ('859', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '48', '127.0.0.1', '2021-09-06 18:46:25');
INSERT INTO `sys_log` VALUES ('860', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '39', '5', '0:0:0:0:0:0:0:1', '2021-09-06 18:46:30');
INSERT INTO `sys_log` VALUES ('861', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '39', '4', '0:0:0:0:0:0:0:1', '2021-09-06 18:46:31');
INSERT INTO `sys_log` VALUES ('862', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '39', '3', '0:0:0:0:0:0:0:1', '2021-09-06 18:46:58');
INSERT INTO `sys_log` VALUES ('863', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '39', '4', '0:0:0:0:0:0:0:1', '2021-09-06 18:46:59');
INSERT INTO `sys_log` VALUES ('864', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '15', '127.0.0.1', '2021-09-06 18:47:30');
INSERT INTO `sys_log` VALUES ('865', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '10', '4', '127.0.0.1', '2021-09-06 18:47:31');
INSERT INTO `sys_log` VALUES ('866', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '11', '127.0.0.1', '2021-09-06 18:47:54');
INSERT INTO `sys_log` VALUES ('867', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '10', '5', '127.0.0.1', '2021-09-06 18:48:04');
INSERT INTO `sys_log` VALUES ('868', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '10', '5', '127.0.0.1', '2021-09-06 18:48:15');
INSERT INTO `sys_log` VALUES ('869', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '12', '6', '127.0.0.1', '2021-09-06 18:48:16');
INSERT INTO `sys_log` VALUES ('870', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '38', '5', '127.0.0.1', '2021-09-06 18:49:40');
INSERT INTO `sys_log` VALUES ('871', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '8', '127.0.0.1', '2021-09-06 18:50:10');
INSERT INTO `sys_log` VALUES ('872', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '33', '4', '127.0.0.1', '2021-09-06 18:50:16');
INSERT INTO `sys_log` VALUES ('873', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '6', '127.0.0.1', '2021-09-06 18:50:44');
INSERT INTO `sys_log` VALUES ('874', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '28', '3', '127.0.0.1', '2021-09-06 18:50:55');
INSERT INTO `sys_log` VALUES ('875', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '30', '4', '127.0.0.1', '2021-09-06 18:50:56');
INSERT INTO `sys_log` VALUES ('876', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '11', '127.0.0.1', '2021-09-06 18:51:51');
INSERT INTO `sys_log` VALUES ('877', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '10', '4', '127.0.0.1', '2021-09-06 18:51:53');
INSERT INTO `sys_log` VALUES ('878', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '15', '3', '127.0.0.1', '2021-09-06 18:51:55');
INSERT INTO `sys_log` VALUES ('879', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '17', '4', '127.0.0.1', '2021-09-06 18:51:57');
INSERT INTO `sys_log` VALUES ('880', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '28', '4', '127.0.0.1', '2021-09-06 18:52:00');
INSERT INTO `sys_log` VALUES ('881', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '6', '127.0.0.1', '2021-09-06 19:40:06');
INSERT INTO `sys_log` VALUES ('882', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '28', '4', '127.0.0.1', '2021-09-06 19:40:43');
INSERT INTO `sys_log` VALUES ('883', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '30', '4', '127.0.0.1', '2021-09-06 19:40:44');
INSERT INTO `sys_log` VALUES ('884', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '32', '3', '127.0.0.1', '2021-09-06 19:40:44');
INSERT INTO `sys_log` VALUES ('885', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-06 19:42:41');
INSERT INTO `sys_log` VALUES ('886', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-06 19:42:45');
INSERT INTO `sys_log` VALUES ('887', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '38', '5', '127.0.0.1', '2021-09-06 19:43:03');
INSERT INTO `sys_log` VALUES ('888', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '38', '4', '127.0.0.1', '2021-09-06 19:43:07');
INSERT INTO `sys_log` VALUES ('889', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-06 19:46:17');
INSERT INTO `sys_log` VALUES ('890', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '6', '127.0.0.1', '2021-09-06 19:46:20');
INSERT INTO `sys_log` VALUES ('891', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-06 19:46:29');
INSERT INTO `sys_log` VALUES ('892', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '6', '127.0.0.1', '2021-09-06 19:46:31');
INSERT INTO `sys_log` VALUES ('893', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '6', '127.0.0.1', '2021-09-06 19:46:34');
INSERT INTO `sys_log` VALUES ('894', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '17', '127.0.0.1', '2021-09-06 19:46:45');
INSERT INTO `sys_log` VALUES ('895', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '5', '127.0.0.1', '2021-09-06 19:46:54');
INSERT INTO `sys_log` VALUES ('896', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '10', '127.0.0.1', '2021-09-06 19:47:00');
INSERT INTO `sys_log` VALUES ('897', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '6', '127.0.0.1', '2021-09-06 19:47:04');
INSERT INTO `sys_log` VALUES ('898', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '6', '127.0.0.1', '2021-09-06 19:47:25');
INSERT INTO `sys_log` VALUES ('899', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '6', '127.0.0.1', '2021-09-06 19:47:41');
INSERT INTO `sys_log` VALUES ('900', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '22', '127.0.0.1', '2021-09-06 20:20:12');
INSERT INTO `sys_log` VALUES ('901', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '9', '127.0.0.1', '2021-09-06 20:20:15');
INSERT INTO `sys_log` VALUES ('902', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '9', '127.0.0.1', '2021-09-06 20:20:17');
INSERT INTO `sys_log` VALUES ('903', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '9', '127.0.0.1', '2021-09-06 20:20:20');
INSERT INTO `sys_log` VALUES ('904', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-06 20:20:22');
INSERT INTO `sys_log` VALUES ('905', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '6', '127.0.0.1', '2021-09-06 20:23:28');
INSERT INTO `sys_log` VALUES ('906', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '23', '10', '127.0.0.1', '2021-09-06 20:23:32');
INSERT INTO `sys_log` VALUES ('907', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '8', '127.0.0.1', '2021-09-06 20:23:49');
INSERT INTO `sys_log` VALUES ('908', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '9', '127.0.0.1', '2021-09-06 20:23:50');
INSERT INTO `sys_log` VALUES ('909', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-06 20:23:52');
INSERT INTO `sys_log` VALUES ('910', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '8', '127.0.0.1', '2021-09-06 20:23:54');
INSERT INTO `sys_log` VALUES ('911', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '8', '127.0.0.1', '2021-09-06 20:25:36');
INSERT INTO `sys_log` VALUES ('912', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '6', '127.0.0.1', '2021-09-06 20:25:38');
INSERT INTO `sys_log` VALUES ('913', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-06 20:25:39');
INSERT INTO `sys_log` VALUES ('914', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-06 20:25:43');
INSERT INTO `sys_log` VALUES ('915', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-06 20:25:48');
INSERT INTO `sys_log` VALUES ('916', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '19', '5', '127.0.0.1', '2021-09-06 20:25:54');
INSERT INTO `sys_log` VALUES ('917', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-06 20:27:22');
INSERT INTO `sys_log` VALUES ('918', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '6', '127.0.0.1', '2021-09-06 20:29:30');
INSERT INTO `sys_log` VALUES ('919', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-06 20:30:53');
INSERT INTO `sys_log` VALUES ('920', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '15', '8', '127.0.0.1', '2021-09-06 20:31:17');
INSERT INTO `sys_log` VALUES ('921', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '15', '4', '127.0.0.1', '2021-09-06 20:31:21');
INSERT INTO `sys_log` VALUES ('922', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '17', '3', '127.0.0.1', '2021-09-06 20:31:23');
INSERT INTO `sys_log` VALUES ('923', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '19', '2', '127.0.0.1', '2021-09-06 20:31:25');
INSERT INTO `sys_log` VALUES ('924', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-06 20:31:37');
INSERT INTO `sys_log` VALUES ('925', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-06 20:31:38');
INSERT INTO `sys_log` VALUES ('926', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '81', '127.0.0.1', '2021-09-06 21:44:55');
INSERT INTO `sys_log` VALUES ('927', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '14', '127.0.0.1', '2021-09-06 21:44:59');
INSERT INTO `sys_log` VALUES ('928', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '12', '127.0.0.1', '2021-09-06 21:45:08');
INSERT INTO `sys_log` VALUES ('929', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '82', '127.0.0.1', '2021-09-07 10:45:37');
INSERT INTO `sys_log` VALUES ('930', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '19', '127.0.0.1', '2021-09-07 10:51:38');
INSERT INTO `sys_log` VALUES ('931', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '8', '127.0.0.1', '2021-09-07 10:51:41');
INSERT INTO `sys_log` VALUES ('932', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '23', '127.0.0.1', '2021-09-11 10:41:27');
INSERT INTO `sys_log` VALUES ('933', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '11', '127.0.0.1', '2021-09-11 10:41:33');
INSERT INTO `sys_log` VALUES ('934', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '9', '127.0.0.1', '2021-09-11 10:42:02');
INSERT INTO `sys_log` VALUES ('935', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '10', '127.0.0.1', '2021-09-11 10:42:26');
INSERT INTO `sys_log` VALUES ('936', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '8', '127.0.0.1', '2021-09-11 10:42:49');
INSERT INTO `sys_log` VALUES ('937', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-11 10:43:11');
INSERT INTO `sys_log` VALUES ('938', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-11 10:43:17');
INSERT INTO `sys_log` VALUES ('939', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '8', '127.0.0.1', '2021-09-11 10:43:33');
INSERT INTO `sys_log` VALUES ('940', 'admin', '标记消息已读', 'com.antd.modules.security.controller.SecWarnMsgController.delete()', '[3]', '143', '127.0.0.1', '2021-09-11 10:49:47');
INSERT INTO `sys_log` VALUES ('941', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '10', '127.0.0.1', '2021-09-11 10:49:54');
INSERT INTO `sys_log` VALUES ('942', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '8', '127.0.0.1', '2021-09-11 11:13:34');
INSERT INTO `sys_log` VALUES ('943', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '8', '127.0.0.1', '2021-09-11 11:13:36');
INSERT INTO `sys_log` VALUES ('944', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '12', '5', '127.0.0.1', '2021-09-11 11:13:42');
INSERT INTO `sys_log` VALUES ('945', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '5', '127.0.0.1', '2021-09-11 14:24:39');
INSERT INTO `sys_log` VALUES ('946', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '12', '127.0.0.1', '2021-09-11 14:29:08');
INSERT INTO `sys_log` VALUES ('947', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '22', '4', '127.0.0.1', '2021-09-11 14:29:12');
INSERT INTO `sys_log` VALUES ('948', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '6', '127.0.0.1', '2021-09-11 14:30:07');
INSERT INTO `sys_log` VALUES ('949', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '8', '127.0.0.1', '2021-09-11 14:30:08');
INSERT INTO `sys_log` VALUES ('950', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '8', '127.0.0.1', '2021-09-11 14:30:09');
INSERT INTO `sys_log` VALUES ('951', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '7', '127.0.0.1', '2021-09-11 14:30:10');
INSERT INTO `sys_log` VALUES ('952', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '8', '127.0.0.1', '2021-09-11 14:30:11');
INSERT INTO `sys_log` VALUES ('953', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '13', '4', '127.0.0.1', '2021-09-11 22:08:26');
INSERT INTO `sys_log` VALUES ('954', 'admin', '手动发送指令', 'com.antd.modules.security.controller.SecEquipmentController.sendInstruct()', '12', '3', '127.0.0.1', '2021-09-11 22:08:30');
INSERT INTO `sys_log` VALUES ('955', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '23', '127.0.0.1', '2021-09-11 22:11:10');
INSERT INTO `sys_log` VALUES ('956', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '12', '4', '127.0.0.1', '2021-09-11 22:11:16');
INSERT INTO `sys_log` VALUES ('957', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '20', '127.0.0.1', '2021-09-18 16:36:48');
INSERT INTO `sys_log` VALUES ('958', 'admin', '手动发送UniApp端指令', 'com.antd.modules.security.controller.SecEquipmentController.uniSendInstruct()', '20', '7', '127.0.0.1', '2021-09-18 16:36:52');
INSERT INTO `sys_log` VALUES ('959', 'admin', '获取控制界面数据', 'com.antd.modules.security.controller.SecEquipmentController.uniControllerData()', null, '8', '127.0.0.1', '2021-09-18 16:37:09');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `menu_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `parent_id` bigint(20) DEFAULT NULL COMMENT '父菜单ID，一级菜单为0',
  `name` varchar(50) DEFAULT NULL COMMENT '菜单名称',
  `perms` varchar(500) DEFAULT NULL COMMENT '授权(多个用逗号分隔，如：user:list,user:create)',
  `type` int(11) DEFAULT NULL COMMENT '类型   0：目录   1：菜单   2：按钮',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=utf8 COMMENT='菜单管理';

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES ('50', '49', '查看', 'type.save', '2');
INSERT INTO `sys_menu` VALUES ('56', '46', '新增', 'user.save', '2');
INSERT INTO `sys_menu` VALUES ('57', '0', '系统管理', 'sys', '1');
INSERT INTO `sys_menu` VALUES ('58', '57', '用户管理', 'sys.user', '2');
INSERT INTO `sys_menu` VALUES ('59', '58', '查看', 'sys.user.list', '3');
INSERT INTO `sys_menu` VALUES ('60', '58', '新增', 'sys.user.save', '3');
INSERT INTO `sys_menu` VALUES ('61', '58', '修改', 'sys.user.update', '3');
INSERT INTO `sys_menu` VALUES ('62', '58', '删除', 'sys.user.delete', '3');
INSERT INTO `sys_menu` VALUES ('63', '57', '角色管理', 'sys.role', '2');
INSERT INTO `sys_menu` VALUES ('64', '57', '菜单管理', 'sys.menu', '2');
INSERT INTO `sys_menu` VALUES ('65', '63', '查看', 'sys.role.list', '3');
INSERT INTO `sys_menu` VALUES ('66', '63', '新增', 'sys.role.save', '3');
INSERT INTO `sys_menu` VALUES ('67', '63', '修改', 'sys.role.update', '3');
INSERT INTO `sys_menu` VALUES ('68', '63', '删除', 'sys.role.delete', '3');
INSERT INTO `sys_menu` VALUES ('69', '64', '查看', 'sys.menu.list', '3');
INSERT INTO `sys_menu` VALUES ('70', '64', '新增', 'sys.menu.save', '3');
INSERT INTO `sys_menu` VALUES ('71', '64', '修改', 'sys.menu.update', '3');
INSERT INTO `sys_menu` VALUES ('72', '64', '删除', 'sys.menu.delete', '3');
INSERT INTO `sys_menu` VALUES ('73', '57', '参数管理', 'sys.config', '2');
INSERT INTO `sys_menu` VALUES ('74', '57', 'sql监控', 'sys.sql', '2');
INSERT INTO `sys_menu` VALUES ('76', '57', '定时任务', 'sys.schedule', '2');
INSERT INTO `sys_menu` VALUES ('77', '76', '查看', 'sys.schedule.list', '3');
INSERT INTO `sys_menu` VALUES ('78', '73', '查看', 'sys.config.list', '3');
INSERT INTO `sys_menu` VALUES ('79', '73', '新增', 'sys.config.save', '3');
INSERT INTO `sys_menu` VALUES ('80', '73', '修改', 'sys.config.update', '3');
INSERT INTO `sys_menu` VALUES ('81', '73', '删除', 'sys.config.delete', '3');
INSERT INTO `sys_menu` VALUES ('82', '76', '新增', 'sys.schedule.save', '3');
INSERT INTO `sys_menu` VALUES ('83', '76', '修改', 'sys.schedule.update', '3');
INSERT INTO `sys_menu` VALUES ('84', '76', '删除', 'sys.schedule.delete', '3');
INSERT INTO `sys_menu` VALUES ('85', '76', '暂停', 'sys.schedule.pause', '3');
INSERT INTO `sys_menu` VALUES ('86', '76', '恢复', 'sys.schedule.resume', '3');
INSERT INTO `sys_menu` VALUES ('87', '76', '立即执行', 'sys.schedule.run', '3');
INSERT INTO `sys_menu` VALUES ('88', '57', '日志列表', 'sys.schedule.log', '2');
INSERT INTO `sys_menu` VALUES ('89', '57', '字典管理', 'sys.dict', '2');
INSERT INTO `sys_menu` VALUES ('90', '89', '查看', 'sys.dict.list', '3');
INSERT INTO `sys_menu` VALUES ('91', '89', '新增', 'sys.dict.save', '3');
INSERT INTO `sys_menu` VALUES ('92', '89', '删除', 'sys.dict.delete', '3');
INSERT INTO `sys_menu` VALUES ('93', '89', '修改', 'sys.dict.update', '3');
INSERT INTO `sys_menu` VALUES ('111', '109', '查看', 'shop.category.list', '3');
INSERT INTO `sys_menu` VALUES ('112', '109', '新增修改', 'shop.category.addOrUpdate', '3');
INSERT INTO `sys_menu` VALUES ('116', '115', '增改', 'store.manager.saveOrUpdate', '3');
INSERT INTO `sys_menu` VALUES ('117', '115', '删除', 'store.manager.delete', '3');
INSERT INTO `sys_menu` VALUES ('118', '115', '查看', 'store.manager.list', '3');
INSERT INTO `sys_menu` VALUES ('126', '0', '连接/设备管理', 'connectEquipment', '1');
INSERT INTO `sys_menu` VALUES ('127', '126', '连接管理', 'connectEquipment.connect', '2');
INSERT INTO `sys_menu` VALUES ('128', '126', '设备管理', 'connectEquipment.equipment', '2');
INSERT INTO `sys_menu` VALUES ('129', '127', '查看', 'connectEquipment.connect.list', '3');
INSERT INTO `sys_menu` VALUES ('130', '127', '增改', 'connectEquipment.connect.write', '3');
INSERT INTO `sys_menu` VALUES ('131', '127', '删除', 'connectEquipment.connect.delete', '3');
INSERT INTO `sys_menu` VALUES ('132', '57', '系统日志', 'sys.log', '2');
INSERT INTO `sys_menu` VALUES ('133', '132', '查看', 'sys.log.list', '3');
INSERT INTO `sys_menu` VALUES ('134', '128', '模块列表', 'connectEquipment.equipment.modularList', '3');
INSERT INTO `sys_menu` VALUES ('135', '128', '增改模块', 'connectEquipment.equipment.modularWrite', '3');
INSERT INTO `sys_menu` VALUES ('136', '128', '删除模块', 'connectEquipment.equipment.modularDelete', '3');
INSERT INTO `sys_menu` VALUES ('137', '128', '设备列表', 'connectEquipment.equipment.equipmentList', '3');
INSERT INTO `sys_menu` VALUES ('138', '128', '增改设备', 'connectEquipment.equipment.equipmentWrite', '3');
INSERT INTO `sys_menu` VALUES ('139', '128', '删除设备', 'connectEquipment.equipment.equipmentDelete', '3');
INSERT INTO `sys_menu` VALUES ('140', '128', '指令列表', 'connectEquipment.equipment.instructList', '3');
INSERT INTO `sys_menu` VALUES ('141', '128', '增改指令', 'connectEquipment.equipment.instructWrite', '3');
INSERT INTO `sys_menu` VALUES ('142', '128', '删除指令', 'connectEquipment.equipment.instructDelete', '3');
INSERT INTO `sys_menu` VALUES ('143', '128', '数据项列表', 'connectEquipment.equipment.dataList', '3');
INSERT INTO `sys_menu` VALUES ('144', '128', '增改数据项', 'connectEquipment.equipment.dataWrite', '3');
INSERT INTO `sys_menu` VALUES ('145', '128', '删除数据项', 'connectEquipment.equipment.dataDelete', '3');
INSERT INTO `sys_menu` VALUES ('150', '0', '其他权限', 'other', '1');
INSERT INTO `sys_menu` VALUES ('151', '150', 'socket权限', 'other.socket', '2');
INSERT INTO `sys_menu` VALUES ('152', '151', '系统提示socket', 'other.socket.sysSocket', '3');
INSERT INTO `sys_menu` VALUES ('153', '151', '数据socket权限', 'other.socket.dataSocket', '3');
INSERT INTO `sys_menu` VALUES ('154', '0', '数据管理', 'secData', '1');
INSERT INTO `sys_menu` VALUES ('155', '154', '实时数据', 'secData.realTimeData', '2');
INSERT INTO `sys_menu` VALUES ('156', '155', '查看', 'secData.realTimeData.list', '3');
INSERT INTO `sys_menu` VALUES ('157', '154', '警告消息', 'secData.warnMsg', '2');
INSERT INTO `sys_menu` VALUES ('158', '157', '查看', 'secData.warnMsg.list', '3');
INSERT INTO `sys_menu` VALUES ('159', '157', '标记已读', 'secData.warnMsg.read', '3');
INSERT INTO `sys_menu` VALUES ('160', '128', '手动发送指令', 'connectEquipment.equipment.sendInstruct', '3');

-- ----------------------------
-- Table structure for sys_oss
-- ----------------------------
DROP TABLE IF EXISTS `sys_oss`;
CREATE TABLE `sys_oss` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `url` varchar(200) DEFAULT NULL COMMENT 'URL地址',
  `create_date` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文件上传';

-- ----------------------------
-- Records of sys_oss
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `role_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `role_name` varchar(100) DEFAULT NULL COMMENT '角色名称',
  `remark` varchar(100) DEFAULT NULL COMMENT '备注',
  `shop_role` int(1) NOT NULL DEFAULT '0' COMMENT '是否是店铺角色1是0否',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='角色';

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES ('1', '超级管理员', '超级管理员角色666', '0', '2019-04-19 15:16:14');
INSERT INTO `sys_role` VALUES ('3', '普通用户', '普通用户', '1', '2019-04-28 16:30:34');
INSERT INTO `sys_role` VALUES ('5', '店铺客服', '店铺客服', '0', '2019-10-09 14:39:14');
INSERT INTO `sys_role` VALUES ('8', 'test', 'test', '1', '2021-03-08 12:42:43');

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `role_id` bigint(20) DEFAULT NULL COMMENT '角色ID',
  `menu_id` bigint(20) DEFAULT NULL COMMENT '菜单ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=716 DEFAULT CHARSET=utf8 COMMENT='角色与菜单对应关系';

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES ('352', '5', '60');
INSERT INTO `sys_role_menu` VALUES ('353', '5', '59');
INSERT INTO `sys_role_menu` VALUES ('509', '3', '62');
INSERT INTO `sys_role_menu` VALUES ('634', '1', '57');
INSERT INTO `sys_role_menu` VALUES ('635', '1', '58');
INSERT INTO `sys_role_menu` VALUES ('636', '1', '59');
INSERT INTO `sys_role_menu` VALUES ('637', '1', '60');
INSERT INTO `sys_role_menu` VALUES ('638', '1', '61');
INSERT INTO `sys_role_menu` VALUES ('639', '1', '62');
INSERT INTO `sys_role_menu` VALUES ('640', '1', '63');
INSERT INTO `sys_role_menu` VALUES ('641', '1', '65');
INSERT INTO `sys_role_menu` VALUES ('642', '1', '66');
INSERT INTO `sys_role_menu` VALUES ('643', '1', '67');
INSERT INTO `sys_role_menu` VALUES ('644', '1', '68');
INSERT INTO `sys_role_menu` VALUES ('645', '1', '64');
INSERT INTO `sys_role_menu` VALUES ('646', '1', '69');
INSERT INTO `sys_role_menu` VALUES ('647', '1', '70');
INSERT INTO `sys_role_menu` VALUES ('648', '1', '71');
INSERT INTO `sys_role_menu` VALUES ('649', '1', '72');
INSERT INTO `sys_role_menu` VALUES ('650', '1', '73');
INSERT INTO `sys_role_menu` VALUES ('651', '1', '78');
INSERT INTO `sys_role_menu` VALUES ('652', '1', '79');
INSERT INTO `sys_role_menu` VALUES ('653', '1', '80');
INSERT INTO `sys_role_menu` VALUES ('654', '1', '81');
INSERT INTO `sys_role_menu` VALUES ('655', '1', '74');
INSERT INTO `sys_role_menu` VALUES ('656', '1', '76');
INSERT INTO `sys_role_menu` VALUES ('657', '1', '77');
INSERT INTO `sys_role_menu` VALUES ('658', '1', '82');
INSERT INTO `sys_role_menu` VALUES ('659', '1', '83');
INSERT INTO `sys_role_menu` VALUES ('660', '1', '84');
INSERT INTO `sys_role_menu` VALUES ('661', '1', '85');
INSERT INTO `sys_role_menu` VALUES ('662', '1', '86');
INSERT INTO `sys_role_menu` VALUES ('663', '1', '87');
INSERT INTO `sys_role_menu` VALUES ('664', '1', '88');
INSERT INTO `sys_role_menu` VALUES ('665', '1', '89');
INSERT INTO `sys_role_menu` VALUES ('666', '1', '90');
INSERT INTO `sys_role_menu` VALUES ('667', '1', '91');
INSERT INTO `sys_role_menu` VALUES ('668', '1', '92');
INSERT INTO `sys_role_menu` VALUES ('669', '1', '93');
INSERT INTO `sys_role_menu` VALUES ('670', '1', '132');
INSERT INTO `sys_role_menu` VALUES ('671', '1', '133');
INSERT INTO `sys_role_menu` VALUES ('672', '1', '126');
INSERT INTO `sys_role_menu` VALUES ('673', '1', '127');
INSERT INTO `sys_role_menu` VALUES ('674', '1', '129');
INSERT INTO `sys_role_menu` VALUES ('675', '1', '130');
INSERT INTO `sys_role_menu` VALUES ('676', '1', '131');
INSERT INTO `sys_role_menu` VALUES ('677', '1', '128');
INSERT INTO `sys_role_menu` VALUES ('678', '1', '134');
INSERT INTO `sys_role_menu` VALUES ('679', '1', '135');
INSERT INTO `sys_role_menu` VALUES ('680', '1', '136');
INSERT INTO `sys_role_menu` VALUES ('681', '1', '137');
INSERT INTO `sys_role_menu` VALUES ('682', '1', '138');
INSERT INTO `sys_role_menu` VALUES ('683', '1', '139');
INSERT INTO `sys_role_menu` VALUES ('684', '1', '140');
INSERT INTO `sys_role_menu` VALUES ('685', '1', '141');
INSERT INTO `sys_role_menu` VALUES ('686', '1', '142');
INSERT INTO `sys_role_menu` VALUES ('687', '1', '143');
INSERT INTO `sys_role_menu` VALUES ('688', '1', '144');
INSERT INTO `sys_role_menu` VALUES ('689', '1', '145');
INSERT INTO `sys_role_menu` VALUES ('690', '1', '150');
INSERT INTO `sys_role_menu` VALUES ('691', '1', '151');
INSERT INTO `sys_role_menu` VALUES ('692', '1', '152');
INSERT INTO `sys_role_menu` VALUES ('693', '1', '153');
INSERT INTO `sys_role_menu` VALUES ('694', '8', '62');
INSERT INTO `sys_role_menu` VALUES ('695', '8', '128');
INSERT INTO `sys_role_menu` VALUES ('696', '8', '134');
INSERT INTO `sys_role_menu` VALUES ('697', '8', '135');
INSERT INTO `sys_role_menu` VALUES ('698', '8', '136');
INSERT INTO `sys_role_menu` VALUES ('699', '8', '137');
INSERT INTO `sys_role_menu` VALUES ('700', '8', '138');
INSERT INTO `sys_role_menu` VALUES ('701', '8', '139');
INSERT INTO `sys_role_menu` VALUES ('702', '8', '140');
INSERT INTO `sys_role_menu` VALUES ('703', '8', '141');
INSERT INTO `sys_role_menu` VALUES ('704', '8', '142');
INSERT INTO `sys_role_menu` VALUES ('705', '8', '143');
INSERT INTO `sys_role_menu` VALUES ('706', '8', '144');
INSERT INTO `sys_role_menu` VALUES ('707', '8', '145');
INSERT INTO `sys_role_menu` VALUES ('708', '8', '160');
INSERT INTO `sys_role_menu` VALUES ('709', '8', '59');
INSERT INTO `sys_role_menu` VALUES ('710', '8', '127');
INSERT INTO `sys_role_menu` VALUES ('711', '8', '129');
INSERT INTO `sys_role_menu` VALUES ('712', '8', '130');
INSERT INTO `sys_role_menu` VALUES ('713', '8', '131');
INSERT INTO `sys_role_menu` VALUES ('715', '8', '126');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(100) DEFAULT NULL COMMENT '密码',
  `salt` varchar(20) DEFAULT NULL COMMENT '盐',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `mobile` varchar(100) DEFAULT NULL COMMENT '手机号',
  `status` tinyint(4) DEFAULT NULL COMMENT '状态  0：禁用   1：正常',
  `dept_id` bigint(20) DEFAULT NULL COMMENT '部门ID',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8 COMMENT='系统用户';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES ('1', 'admin', 'e1153123d7d180ceeb820d577ff119876678732a68eef4e6ffc0b1f06a01f91b', 'YzcmCZNvbXocrsz9dm8e', '844899914@qq.com', '13612345678', '1', '38', '2016-11-11 11:11:11');
INSERT INTO `sys_user` VALUES ('27', 'test', '5873005bd7488a7521ded10a0f99738f08c57891c4ba429d675fe7a7688ab909', 'PFfizCQ4inDCcHA54hES', 'www@qq.com', '17803221554', '1', null, '2021-03-08 12:45:35');
INSERT INTO `sys_user` VALUES ('28', 'admin1', 'b4aa2d01ad4d98cc12aebb112afa0ae301e782abb0731cfb490cecf1cb542158', 'wXCfgb0BpIXqJb7SARNd', '8448@qq.com', '17803215100', '1', null, '2021-03-08 20:10:28');
INSERT INTO `sys_user` VALUES ('29', 'test1', 'ba2373c2eae005620746a4df5e2efca51a8e565e4e37fc41ccb431adc9d80042', 'Q3AW4PHB2fQ43jTS9Z2L', 'test1@qq.com', '17803215666', '1', null, '2021-05-12 19:46:58');

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户ID',
  `role_id` bigint(20) DEFAULT NULL COMMENT '角色ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8 COMMENT='用户与角色对应关系';

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES ('2', '17', '1');
INSERT INTO `sys_user_role` VALUES ('4', '7', '1');
INSERT INTO `sys_user_role` VALUES ('5', '18', '1');
INSERT INTO `sys_user_role` VALUES ('6', '19', '3');
INSERT INTO `sys_user_role` VALUES ('32', '20', '1');
INSERT INTO `sys_user_role` VALUES ('34', '20', '5');
INSERT INTO `sys_user_role` VALUES ('57', '1', '1');
INSERT INTO `sys_user_role` VALUES ('58', '1', '3');
INSERT INTO `sys_user_role` VALUES ('59', '1', '5');
INSERT INTO `sys_user_role` VALUES ('60', '27', '8');
INSERT INTO `sys_user_role` VALUES ('61', '28', '8');
INSERT INTO `sys_user_role` VALUES ('62', '29', '8');
