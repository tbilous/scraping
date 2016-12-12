require 'open-uri'
require 'nokogiri'
require 'mechanize'
require 'json'

# agent
a = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
}

# url
url = 'http://www.booking.com'

# call url
page = a.get("#{url}//")

# fill form
my_form = page.form_with(:dom_id => 'frm')
my_form.checkin_month = '1'
my_form.checkin_monthday = '10'
my_form.checkin_year = '2017'
my_form.checkout_month = '1'
my_form.checkout_monthday = '12'
my_form.checkout_year = '2017'
my_form.checkout_year = '2017'
my_form.ss = 'Київ'
# submit
result = my_form.submit

# translate
link = result.link_with(:text => "\n\n \n\n\nУкраїнська\n\n\n")
uk_translate = link.click

# processing search result
items = uk_translate.css('.sr_item')

class Entry
  def initialize(img, title, link, score, place_score)
    @img = img
    @title = title
    @link = link
    @score = score
    @place_score = place_score
  end

  attr_reader :img
  attr_reader :title
  attr_reader :link
  attr_reader :score
  attr_reader :place_score
end

entries_array = []
items.each do |entry|
  img = entry.css('.hotel_image').attr('src')
  title = entry.css('.hotel_name_link').text.gsub(/\s+/, ' ').strip
  link = url + entry.css('.hotel_name_link').attr('href').to_s
  score = entry.css('.sr_review_score').css('.average').text.gsub(/\s+/, ' ').strip
  place_score = entry.css('.sr_review_score').css('.search-secondary-review-score').text.gsub(/\s+/, ' ').strip
  entries_array << Entry.new(img, title, link, score, place_score)

  entries_array.push(
      img: img,
      title: title,
      link: link,
      score: score,
      place_score: place_score
  )
end
