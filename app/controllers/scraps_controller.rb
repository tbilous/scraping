class ScrapsController < ApplicationController
  require 'booking_search'

  def new
    @booking = Struct.new(:city, :checkin, :checkout)
  end

  def create
    @booking =  BookingSearch.perform(city: params[:city], checkin: params[:checkin], checkout: params[:checkout])
  end
end
