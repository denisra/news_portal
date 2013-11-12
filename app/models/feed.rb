class Feed < ActiveRecord::Base

  def self.return_new_articles(feed, last_modified)
    feed.entries.each do |entry|
      if entry.published < last_modified
        feed.entries.delete(entry)
      end
    end
    feed
  end

end
