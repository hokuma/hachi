require_dependency 'pidgin/application_controller'

module Pidgin
  class LinksController < ApplicationController
    before_action :fetch_link
    skip_before_action :verify_authenticity_token, only: [:client]

    def show
    end

    def client
      response = @link.send_request(params[:token], params[:identity], params[:payload])
      render json: response
    end

    private

    def fetch_link
      @link = Pidgin::Schema.instance.get_link params[:method], params[:href]
    end
  end
end
