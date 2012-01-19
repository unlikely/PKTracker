class DevelopersController < ApplicationController
  respond_to :html, :json

  def index
    @developer = Developer.all
    respond_with @developer
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

  def asked_question
    @developer = Developer.find params[:id]
    @developer.last_question = Time.zone.now
    @developer.save
    redirect_to :back
  end

  def broke_production
    @developer = Developer.find params[:id]
    @developer.last_broke_production = Time.zone.now
    @developer.save
    redirect_to :back
  end

  def add_points
    @developer = Developer.find params[:id]
    @developer.points_accepted += params[:points].to_f
    @developer.save
    redirect_to :back
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
