# frozen_string_literal: true
require 'colorize'

# json formatter for logs
module LIB
    class JSONLogFormatter < ::Logger::Formatter
        def call(severity, time, _progname, msg)
            begin
              obj = JSON.parse msg
            rescue StandardError
              obj = msg
            end
            
            if obj.is_a? Hash
              colorize_log(severity, JSON.generate(obj.merge({ time: time, level: severity }))) + "\n"
            else
              colorize_log(severity, JSON.generate(time: time, level: severity, message: msg)) + "\n"
            end
        end

        def colorize_log(level, message)
          case level.to_s.downcase
          when 'info'
            message.colorize(:green)
          when 'warn'
            message.colorize(:yellow)
          when 'error', 'fatal'
            message.colorize(:red)
          when 'debug'
            message.colorize(:cyan)
          else
            message
          end
        end
    end       
end