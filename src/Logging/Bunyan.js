"use strict";

// module Logging.Bunyan

var bunyan = require("bunyan");

exports.createLoggerImpl = bunyan.createLogger

exports.infoImpl = function (dict) {
    return function (logger, msg) {
        return function() {
            logger.info( msg );
            return {};
        }
    }
}
