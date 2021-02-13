class AddViewsToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :views, :long
  end
end
