class Article
	module Egoarticle
		extend ActiveSupport::Concern

		included do

			def self.parse_feed_ego(feed)
				temp_entries = feed.css(".foto")
			    entries = []
			    temp_entries.each do |e|
			    	if e.search('a').first['title'] != nil
			    		entries << e
			    	end
			    end
			    create_ego_article(entries)
			end

			def self.get_published(content)
				article = Nokogiri::HTML(content)
				published = article.search('.published').first['time']
				#published
			end

			def self.fetch_url(url)
				page = Nokogiri::HTML(open(url))
				page.search('a').each do |p|
					unless p['href'].include? 'http'
						p['href'] = 'http://ego.globo.com' + p['href']
					end
				end
				page.css('.linkspatrocinados').remove
				head = page.css('head').to_html
				body = page.css('#glb-materia').to_html
				html = '<html>' + head + '<body>' + body + '</body>' + '</html>'
				#html
				#body
			end

			def self.parse_ego_img(entry)
				img_url = entry.search('img').first['src']
				img = URI.parse(img_url)
			end

			#private

			def self.create_ego_article(entries)
				entries.each do |entry|
					permalink = 'http://ego.globo.com' + entry.search('a').first['href']
					content = fetch_url(permalink)
				  	unless exists? :permalink => permalink
				    	create!(			
							:title 	=>	entry.search('a').first['title'], 
							:permalink 	=>	permalink,
							:content	=>	content,
							:source 	=>	'EGO',
							:published_at 	=>	get_published(content),
							:image	=>	parse_ego_img(entry),
							:guid 	=>	'blank'
						)
					end
				end
			end
		end		
	end
end