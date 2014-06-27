#encoding: utf-8
# require 'mongoid'
require 'httparty'
require 'nokogiri'
require 'fileutils'
# require 'mongoid_auto_increment_id'

def grep body, p
  doc = Nokogiri::HTML(body)
  # puts doc
  index = 1
  doc.css('.article').each do |item|
    qdata = {from: "qiubai"}
    id = item["id"].gsub(/\d+/).first
    content = item.css('.content').text
    content = content.encode('utf-8', 'utf-8').chomp

    qdata[:base_id] = id
    qdata[:content] = content
    thumb = item.css('.thumb a img').first
    
    if thumb
      qdata[:pic_url] = thumb['src']
    end
    puts "第#{p}页--第#{index}条 "
    HTTParty.post('http://192.168.4.56:3001/node/joke/new', {query: qdata, headers: {"Content-Type" => 'utf-8'}})
    puts qdata
    index += 1
  end
end


AGENT = 'Mozilla/5.0 (Windows; U; Windows NT 5.2) AppleWebKit/525.13 (KHTML, like Gecko) Chrome/0.2.149.27 Safari/525.13'

page = ARGV.shift || '1'
page = page.to_i

page.upto(page+10000) do |p|
  puts "grep http://www.qiushibaike.com/8hr/page/#{p}?s=4674024"
  repeat_times = 0
  body = nil
  while
    begin
      body = HTTParty.get("http://www.qiushibaike.com/8hr/page/#{p}?s=4674024", :headers => {"User-Agent" => AGENT}).body
      break
    rescue => e
      if repeat_times>5 then break end
      repeat_times += 1
      sleep 5
    end
  end
  if body then grep(body, p) else p += 1 end
  sleep 5
end

