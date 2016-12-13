class ScrapsController < ApplicationController
  require 'booking_search'
  def new
    @form = Struct.new(:city, :checkin, :checkout)
  end

  def create
    @booking = BookingSearch.perform(params[:city], params[:checkin], params[:checkout])
    render json: @booking.to_json
  end
end
