require_dependency "hachi/application_controller"

module Hachi
  class ResourcesController < ApplicationController
    def index
      @resources = Resource.find_all
    end

    def show
      @resource = Resource.find_by_id(params[:id])
    end
  end
end
