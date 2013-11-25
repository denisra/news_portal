class Article < ActiveRecord::Base
	require 'open-uri'
	require 'nokogiri'
	include Egoarticle
	include Feedarticle
	acts_as_taggable
  acts_as_ordered_taggable_on :site

	has_attached_file :image, :styles => { :medium => "300x200>", :thumb => "100x100>", :carousel => "800x300>" }, :default_url => "/images/:style/missing.png"

	default_scope -> {order('published_at DESC')}
  scope :today, -> { where('published_at >= ?', Date.today)}
  scope :featured, -> {today.reorder(clicks: :desc).limit(5)}

  searchkick autocomplete: ['title']


	def self.update_from_webpage(feed_url)
	    if feed_url.include? 'ego'
	    	feed = Nokogiri::HTML(open(feed_url))
	    	parse_feed_ego(feed)
      end
  end

  def self.update_from_feed(feed)
		if feed.feed_url.include? 'ofuxico'
		 	source = 'OFuxico'
		elsif feed.feed_url.include? 'ig.com.br'
		 	source = 'iG Gente'
		elsif feed.feed_url.include? 'uol.com.br'
	  	source = 'UOL'
	  elsif feed.feed_url.include? 'ego'
	  	source = 'EGO'
		end
		parse_feed(feed, source)
	end


  def self.feed_updated?
    Feed.all.each do |f|
      feed = Feedzirra::Feed.fetch_and_parse(f.feed_url)
      if feed.last_modified == nil
        logger.info "Feed '#{feed.title}' has no last modified attribute."
        update_from_feed(feed)
      else
        logger.info "Feed: '#{f.title}'"
        logger.info "Local feed last modified: '#{f.last_modified}' - Feed last modified: '#{feed.last_modified}'"
        if feed.last_modified > f.last_modified
          logger.info "Processing Feed: '#{feed.title}'"
          new_articles = Feed.return_new_articles(feed, f.last_modified)
          logger.info "'#{new_articles.entries.count}' new articles."
          update_from_feed(new_articles)
          Feed.update(f.id, :last_modified => feed.last_modified)
        else
          logger.info "Feed '#{feed.title}' is already up-to-date."
        end
      end
    end
  end


	# def self.get_published_date(url, source)
	# 	if source == 'EGO'
	# 		published = ego_published(url)
	# 	end
	# 	published
	# end

	# def self.fetch_url(url)
	# 	page = Nokogiri::HTML(open(url))
	# 	page.search('a').each do |p|
	# 		unless p['href'].include? 'http'
	# 			p['href'] = 'http://ego.globo.com' + p['href']
	# 		end
	# 	end
	# 	head = page.css('head').to_html
	# 	body = page.css('#glb-materia').to_html
	# 	html = head + '<body>' + body + '</body>'
	# 	html
	# end


  
 #  private
  
	# def self.add_entries(entries, source, prefix)
	# 	entries.each do |entry|
	# 		permalink = prefix + entry.search('a').first['href']
	# 	  unless exists? :permalink => permalink
	# 	    create!(
	# 	      :title         => entry.search('a').first['title'],
	# 	      :content      => "blank content",
	# 	      :source		=> source,
	# 	      :permalink          => permalink,
	# 	      :published_at => get_published_date(permalink, source),
	# 	      :image         => entry.search('img').first['src'],
	# 	      :guid			=> "blank guid"
	# 	    )
	# 	  end
	# 	end
	# end
end
