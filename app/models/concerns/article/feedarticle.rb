    class Article
	module Feedarticle
		extend ActiveSupport::Concern

		included do

			def self.parse_feed(feed, source)
			    tmp_entries = feed.entries
			    entries = []
			    tmp_entries.each do |e|
            begin
			    	  page = Nokogiri::HTML(open(e.url))
            rescue OpenURI::HTTPError => error
              logger.error "'#{error.message}' - '#{e.title}'"
              next
            end
			    	e.image = parse_feed_img(page, source)
			    	if e.image != nil
			    		e.categories = parse_tags(page, source)
			    		e.author = parse_author(page, source)
              if e.published == nil
                e.published = get_published_date(page, source, e)
              end
              logger.info "Article published date: '#{e.published}'"
			    		entries << e
			    		logger.info "Processing entry: '#{e.title}'"
			    		save = create_feed_article(e, source)
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
			    #create_feed_article(entries)
			end

			def self.parse_tags(page, source)
				if source == 'EGO'
          tags = []
					page.xpath('//a[contains(@class, "autolink")]/text()').each do |tag|
            tags << tag.to_s
          end
          tags
				elsif source == 'UOL'
					tags = page.xpath('//meta[contains(@name, "news_keywords")]/@content').to_s
				elsif source == 'iG Gente'
					tags = page.xpath('//meta[contains(@name, "news_keywords")]/@content').to_s
				elsif source == 'OFuxico'
					tags = page.xpath('//meta[contains(@name, "keywords")]/@content').to_s
				end
			end

			def self.parse_author(page, source)
				author = page.xpath('//meta[contains(@property, "site_name")]/@content').first.to_s
				if author.size > 0
					author
				else
					author = source
				end
			end


      def self.get_published_date(page, source, entry)
        if entry.published == nil
          published_date = Time.now.to_s
          published_date
        end
        if source == 'EGO'
          published_date = page.xpath('//abbr[contains(@class, "published")]/@time').to_s
          published_date
        end
      end


			def self.parse_feed_img(page, source)
				if source == 'OFuxico'
					path = page.xpath('//div[@class="img sombra"]/img/@src').first.to_s
					if path.size > 0
						image = "http://ofuxico.com.br" + path
					else
						path = page.xpath('//div[@class="foto"]/div[@class="img"]/img/@src').first.to_s
						if path.size > 0
							image = "http://ofuxico.com.br" + path
						else
							image = nil
						end
          end
        elsif source == 'EGO'
          image =  page.xpath('//div[contains(@class, "foto")]/img/@src').first.to_s
				else
					image = page.xpath('//meta[contains(@property, "og:image")]/@content').first.to_s
					if image.size > 0
						image
					else
						image = nil
					end
				end
			end

			# 	if source == 'OFuxico'
			# 		path = page.xpath('//div[@class="img sombra"]/img/@src').first.to_s
			# 		if path.size > 0
			# 			image = "http://ofuxico.com.br" + path
			# 		else
			# 			path = page.xpath('//div[@class="foto"]/div[@class="img"]/img/@src').first.to_s
			# 			if path.size > 0
			# 				image = "http://ofuxico.com.br" + path
			# 			else
			# 				image = nil
			# 			end
			# 		end
			# 	elsif source == 'iG Gente'
			# 		path = page.xpath('//figure[contains(@class,"foto-legenda")]/span/img/@src').first.to_s
			# 		if path.size > 0
			# 			image = path
			# 		else
			# 			path = page.xpath('//*[contains(@id,"galleria")]/a/@href').first.to_s
			# 			if path.size > 0
			# 				image = path
			# 			else
			# 				image = nil
			# 			end
			# 		end
			# 	elsif source == 'UOL'
			# 		image = parse_uol_img(page)
			# 	end
			# end


			# def self.parse_uol_img(page)
			# 	 image = page.xpath('//meta[contains(@property, "og:image")]/@content').first.to_s

			# end



			private

			def self.create_feed_article(entry, source)
				#entries.each do |entry|
				  	unless exists? :permalink => entry.url
				    	create(			
							:title 	=>	entry.title.sanitize,
							:permalink 	=>	entry.url,
							:content	=>	entry.summary,
							:source 	=>	entry.author,
							:published_at 	=>	entry.published,
							:image	=>	entry.image,
							:guid 	=>	'blank',
							:tag_list => entry.categories,
              :site_list => entry.author
						)
					else
						return 'exists'
					end
				#end
			end
		end		
	end
end