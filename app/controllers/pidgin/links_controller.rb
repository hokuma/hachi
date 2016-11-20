require_dependency 'pidgin/application_controller'

module Pidgin
  class LinksController < ApplicationController
    def show
      @link = Pidgin::Schema.instance.get_link params[:method], params[:href]
    end
  end
end
