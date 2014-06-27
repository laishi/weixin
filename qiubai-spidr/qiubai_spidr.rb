#encoding: utf-8
# require 'mongoid'
require 'httparty'
require 'nokogiri'
require 'fileutils'
# require 'mongoid_auto_increment_id'


AGENT = 'Mozilla/5.0 (Windows; U; Windows NT 5.2) AppleWebKit/525.13 (KHTML, like Gecko) Chrome/0.2.149.27 Safari/525.13'

page = ARGV.shift || '1'
page = page.to_i

page.upto(page+100) do |p|
  puts "grep http://www.qiushibaike.com/8hr/page/#{p}?s=4674024"
  body = HTTParty.get("http://www.qiushibaike.com/8hr/page/#{p}?s=4674024", :headers => {"User-Agent" => AGENT}).body
  doc = Nokogiri::HTML(body)
  # puts doc
  index = 1
  doc.css('.article').each do |item|
    id = item["id"]
    content = item.css('.content')
    thumb = item.css('.thumb a img').first
    img = nil
    if thumb
      img = thumb['src']
    end
    puts "第#{p}页--第#{index}条"
    puts "#{content.text}, img=#{img}"
    HTTParty.get('127.0.0.1:3001/node/joke/new', {})
    index += 1
    sleep 1
  end
end
