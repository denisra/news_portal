namespace :parse_feed do
  desc "TODO"
  task ego: :environment do
  end

  desc "TODO"
  task gente: :environment do
  end

  desc "TODO"
  task uol: :environment do
  end

  desc "TODO"
  task ofuxico: :environment do
  end

  desc "Parse all feeds"
  task all_feeds: :environment do
    puts Article.feed_updated?
  end

end
