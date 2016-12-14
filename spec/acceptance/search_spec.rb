require 'acceptance_helper'
# YYes, i know, what this test is not entirely right
feature 'user can find on booking', %q{
  User can to use form for search on ukrainian language
  User see result data
} do

    scenario 'with valid attributes', js:true do
      visit root_path

      expect(page).to have_content 'Booking'

      fill_in 'city', with: 'Чернівці'
      fill_in 'checkin', with: (Date.current + 1).strftime('%d-%m-%Y')
      fill_in 'checkout', with: (Date.current + 2).strftime('%d-%m-%Y')

      within '#searchBooking' do
        page.find('#searchSubmit').click
      end

      sleep 10

      within '#searchData' do
        save_and_open_page
        expect(page).to have_content 'Ночей 1'
      end
    end
end
