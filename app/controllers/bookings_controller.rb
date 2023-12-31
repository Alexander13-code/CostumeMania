class BookingsController < ApplicationController
  def my_bookings
    @bookings = Booking.all
    # a rectifier par la suite : seule façon d'avoir les bookings reçus et envoyés pour la démo
  end

  def new
    @costume = Costume.find(params[:costume_id])
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.costume = Costume.find(params[:costume_id])
    @booking.client = current_user
    if @booking.save
      redirect_to my_bookings_path
    else
      # pas de gestion des erreurs par datepicker
      render :new, status: :unprocessable_entity
    end
  end

  def accept
    @booking = Booking.find(params[:id])
    @booking.status = "Accepted"
    @booking.save
    redirect_to my_bookings_path
  end

  def edit
    @booking = Booking.find(params[:id])
    @costume = @booking.costume
    @booking.client = current_user
  end

  def update
    @booking = Booking.find(params[:id])
    if @booking.update(booking_params)
      redirect_to my_bookings_path
    else
      render :update, status: :unprocessable_entity
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    redirect_to my_bookings_path, status: :see_other
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :status)
  end
end
