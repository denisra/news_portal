class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.string :source
      t.text :permalink
      t.datetime :published_at

      t.timestamps
    end
  end
end
