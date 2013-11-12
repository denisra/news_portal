class AddClicksToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :clicks, :integer, :default => 0
  end
end
