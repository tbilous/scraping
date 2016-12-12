require 'open-uri'
require 'nokogiri'
require 'mechanize'

module BookingSearch
  extend self

  Entry = Struct.new(:img, :title, :link, :avg_score, :review_score)

  def perform(city, checkin, checkout)
    home = agent.get('http://www.booking.com//')
    search_results = search(home, city, checkin, checkout)
    parse_results(search_results)
  end

  def search(page, city, checkin_str, checkout_str)
    checkin = Date.parse(checkin_str)
    checkout = Date.parse(checkout_str)

    search_form = page.form_with(:dom_id => 'frm')

    search_form.ss = city
    search_form = page.form_with(:dom_id => 'frm')
    search_form.checkin_month = checkin.month
    search_form.checkin_monthday = checkin.day
    search_form.checkin_year = checkin.year
    search_form.checkout_month = checkout.month
    search_form.checkout_monthday = checkout.day
    search_form.checkout_year = checkout.year

    result = search_form.submit
    translate = result.link_with(text: "\n\n \n\n\nУкраїнська\n\n\n")
    result = translate.click
    result.root.css('.sr_item')
  end

  def parse_results(entries)
    entries.map do |entry|
      Entry.new entry.css('.hotel_image').attr('src').value,
                entry.css('span.sr-hotel__name').text.strip,
                'http://www.booking.com' + entry.css('.hotel_name_link').attr('href').value.to_s,
                mb_float(entry.css('.sr_review_score').css('.average').text),
                mb_float(entry.css('.sr_review_score').css('.search-secondary-review-score').text)
    end
  end

  def agent
    Mechanize.new do |agent|
      agent.user_agent_alias = 'Mac Safari'
    end
  end

  def mb_float(val)
    val.present? ? val.to_f : nil
  end
end
# sample BookingSearch.perform("London", "15.12.2016", "17.12.2016")