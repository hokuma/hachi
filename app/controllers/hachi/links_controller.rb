require_dependency 'hachi/application_controller'

module Hachi
  class LinksController < ApplicationController
    before_action :fetch_link
    skip_before_action :verify_authenticity_token, only: [:client]

    def show
    end

    def client
      begin
        response = nil
        if params[:username].present? || params[:password].present?
          response = @link.send_authorization_request(params[:username], params[:password], params[:identity], params[:payload], params[:headers])
        else
          response = @link.send_request(params[:token], params[:identity], params[:payload], params[:headers])
        end
        render json: response
      rescue Excon::Errors::ClientError => error
        render json: error.response.body, status: error.response.status
      end
    end

    private

    def fetch_link
      @link = Hachi::Schema.instance.get_link params[:method], params[:href]
    end
  end
end
