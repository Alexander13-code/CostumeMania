require 'algolia'

class CostumesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_costume, only: %i[edit update destroy]

  def index
    if params[:query] && !params[:query].empty?
      Costume.algolia_reindex!
      @costumes = Costume.algolia_search(params[:query])
    else
      @costumes = Costume.all
    end
    users = User.geocoded
    @markers = users.map do |user|
      {
        lat: user.latitude,
        lng: user.longitude,
        info_window_html: render_to_string(partial: "users/info_window", locals: { user: user }),
        marker_html: render_to_string(partial: "users/marker", locals: { user: user })
      }
    end
  end

  def show
    @costume = Costume.find(params[:id])
    @booking = Booking.new
  end

  def new
    @costume = Costume.new
  end

  def create
    costume = Costume.new(costume_params)
    costume.owner = current_user
    if costume.save
      redirect_to costume_path(costume)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @costume.update(costume_params)
    if @costume.save
      redirect_to costume_path(@costume)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @costume.destroy
    redirect_to costumes_path, status: :see_other
  end

  def my_costumes
    @costumes = Costume.where(owner: current_user)
  end

  private

  def costume_params
    params.require(:costume).permit(:photo, :size, :price, :condition, :name, :min_duration, :age, :gender, :description)
  end

  def set_costume
    @costume = Costume.find(params[:id])
  end

  def owner?
    @costume = Costume.find(params[:id])
    @costume.owner == current_user
  end
end
