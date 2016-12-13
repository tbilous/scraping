require 'open-uri'
require 'nokogiri'
require 'mechanize'

# img, - photo
# :title, - name
# :district, - district of place
# :stars,   - stars
# :price,   - price
# :reinforcement, - breakfast, free cancell, etc
# :link,    - link to hotel on booking.com
# :avg_score  - customer rating
# :days  - average between dates
# sample: BookingSearch.perform("London", "15.12.2016", "17.12.2016")

module BookingSearch
  extend self

  Entry = Struct.new(:img,
                     :title,
                     :district,
                     :stars,
                     :price,
                     :reinforcement,
                     :link,
                     :avg_score,
                     :days
  )

  def perform(city, checkin, checkout)
    @timeline = timeline(checkin, checkout)
    home = agent.get('http://www.booking.com//')
    search_results = search(home, city, checkin, checkout)
    parse_pages(search_results)
  end

  def search(page, city, checkin_str, checkout_str)
    checkin = Date.parse(checkin_str)
    checkout = Date.parse(checkout_str)

    search_form = page.form_with(:dom_id => 'frm')

    search_form.ss = city
    search_form.checkin_month = checkin.month
    search_form.checkin_monthday = checkin.day
    search_form.checkin_year = checkin.year
    search_form.checkout_month = checkout.month
    search_form.checkout_monthday = checkout.day
    search_form.checkout_year = checkout.year

    search_form.submit.link_with(text: "\n\n \n\n\nУкраїнська\n\n\n").click
  end

  def parse_pages(page)
    results = []
    while page.present? do
      results << parse_results(page.root.css('.sr_item'))

      next_page = page.link_with(text: 'Наступна сторінка')

      # make sure our access pattern has enough jitter
      sleep(0.3 + rand(2) + rand) if next_page.present?

      page = next_page.present? ? next_page.click : nil
    end
    results.flatten
  end

  def parse_results(entries)
    entries.map do |entry|
      Entry.new entry.css('.hotel_image').attr('src').value,
                entry.css('span.sr-hotel__name').text.strip,
                entry.css('.district_link').text,
                clear_text(entry.css('.stars').css('.invisible_spoken').text),
                clear_price(entry.css('.roomPrice').css('.price').text.strip),
                clear_text(entry.css('.roomPrice').css('.sr_room_reinforcement').text.strip.gsub("\n", ' ').squeeze('
')),
                'http://www.booking.com' + entry.css('.hotel_name_link').attr('href').to_s,
                mb_float(entry.css('.sr_review_score').css('.average').text),
                @timeline
    end
  end

  def agent
    Mechanize.new do |agent|
      agent.user_agent_alias = 'Mac Safari'
    end
  end

  def clear_text(val)
    val.present? ? val : nil
  end

  def clear_price(val)
    val.present? ? val.gsub(/[^\d\.]+/, '').to_f : nil
  # .rstrip!
  end

  def timeline(start, finish)
    average =  ((Date.parse finish) - (Date.parse start)).to_i
    average == 0 ? average + 1 : average
  end

  def mb_float(val)
    val.present? ? val.to_f : nil
  end
end
