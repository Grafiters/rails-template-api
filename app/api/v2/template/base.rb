# frozen_string_literal: true
require_relative 'forms.rb'
module API
    module V2
        module Template
            class Base < Grape::API
                mount Template::Forms
            end
        end
    end
end