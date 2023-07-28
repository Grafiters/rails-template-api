# frozen_string_literal: true
module API
    module V2
        module Template
            class Forms < Grape::API
                namespace :forms do
                    get do
                        data = {
                            message: 'running'
                        }
                        present data
                    end

                    desc 'Post Template'
                    params do
                        requires :username,
                                type: String,
                                desc: { type: 'integer' }
                        optional :password,
                                type: String,
                                desc: { type: 'integer' }
                        optional :captcha,
                                type: Hash do
                                    requires :geetest_challenge,
                                            type: String,
                                            desc: 'Geetest Challenge'
                                    requires :geetest_seccode,
                                            type: String,
                                            desc: 'Geetest Seccode'
                        end
                    end
                    post do
                        present params
                    end
                end
            end
        end
    end
end