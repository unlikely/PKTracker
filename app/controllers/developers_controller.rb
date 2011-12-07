class DevelopersController < ApplicationController
  respond_to :html, :json

  def index
    @developer = Developer.all
  end

  def new
    @developer = Developer.new
  end

  def create
    @developer = Developer.new(params[:developer])
    if @developer.save
      redirect_to developer_path(@developer)
    else
      render action: 'new'
    end
  end

  def show
    @developer = Developer.find params[:id]
    respond_with @developer
  end

  def edit
    @developer = Developer.find params[:id]
  end

  def update
    @developer = Developer.find params[:id]
    @developer.update_attributes params[:developer]
    if @developer.save
      redirect_to developer_path(@developer)
    else
      render action: 'edit'
    end
  end

  def destroy
    dev = Developer.find params[:id]
    dev.destroy
    redirect_to developers_path
  end
end
