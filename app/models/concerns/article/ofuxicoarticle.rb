class Article
	module Ofuxicoarticle
		extend ActiveSupport::Concern

		included do

			def self.parse_feed_ofuxico(feed)
			    tmp_entries = feed.entries
			    entries = []
			    tmp_entries.each do |e|
			    	if parse_ofuxico_img(e.url) != nil
			    		e.image = parse_ofuxico_img(e.url)
			    		entries << e
			    		logger.info "Processing entry: '#{e.title}'"
			    		save = create_ofuxico_article(e)
			    		if save == false
			    			logger.info "Save returned: '#{save}'"
			    			logger.warn "Error saving article: '#{e.title}'"
			    		elsif save == 'exists'
			    			logger.info "Save returned: '#{save}'"
							logger.info "Skipping. Article '#{e.title}' already exists."
			    		else
			    			logger.info "Save returned: '#{save}'"
			    			logger.info "Article saved: '#{e.title}'"
			    		end
			    	else
			    		next
			    	end
			    end
			    #create_ofuxico_article(entries)
			end


			def self.parse_ofuxico_img(url)
				page = Nokogiri::HTML(open(url))
				path = page.xpath('//div[@class="img sombra"]/img').map { |link| link['src'] }.first.to_s
				if path.size > 0
					image = 'http://www.ofuxico.com.br' + path
				else
					path = page.xpath('//div[@class="foto"]/div[@class="img"]/img').map { |link| link['src'] }.first.to_s
					if path.size > 0
						image = 'http://www.ofuxico.com.br' + path
					else
						image = nil
					end
				end
			end


			private

			def self.create_ofuxico_article(entry)
				#entries.each do |entry|
				  	unless exists? :permalink => entry.url
				    	create(			
							:title 	=>	entry.title, 
							:permalink 	=>	entry.url,
							:content	=>	entry.summary,
							:source 	=>	'OFuxico',
							:published_at 	=>	entry.published,
							:image	=>	entry.image,
							:guid 	=>	'blank',
							:tag_list => entry.categories.first
						)
					else
						return 'exists'
					end
				#end
			end
		end		
	end
end