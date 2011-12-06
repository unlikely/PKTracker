class DevelopersController < ApplicationController
  def index
    @developer = Developer.all
  end

  def new
    @developer = Developer.new
  end

  def create
    @developer = Developer.new(params[:developer])
    if @developer.save
      redirect_to developer_path
    else
      render action: 'new'
    end
  end

  def show
    @developer = Developer.find params[:id]
  end
end
