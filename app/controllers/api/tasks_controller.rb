class Api::TasksController < ApplicationController

  def index
    @tasks = Task.search(params)
    render 'index', handlers: 'jbuilder'
  end
end
