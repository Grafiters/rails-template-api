require_relative 'geetest.rb'
module API
    module V2
        module Public
            class Base < Grape::API
                mount Public::Geetest
            end
        end
    end
end