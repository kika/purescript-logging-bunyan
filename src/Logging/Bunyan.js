"use strict";

// module Logging.Bunyan

var bunyan = require("bunyan");

exports.createLoggerImpl = bunyan.createLogger

exports.logImpl = function (level, logger, msg) {
    return function() {
        logger[level]( msg );
        return {};
    }
}

exports.showRecordImpl = function (record) {
    return require("util").inspect(record);
}

exports.getLogLevelImpl = function (logger) {
    return bunyan.nameFromLevel[logger.level()];
}

exports.setLogLevelImpl = function (logger, level) {
    logger.level(level);
    return logger; 
}

