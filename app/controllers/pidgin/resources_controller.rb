require_dependency "pidgin/application_controller"

module Pidgin
  class ResourcesController < ApplicationController
    def index
      @resources = Resource.find_all
    end

    def show
      @resource = Resource.find_by_id(params[:id])
    end
  end
end
