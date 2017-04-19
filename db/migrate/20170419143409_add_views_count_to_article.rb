class AddViewsCountToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :views_count, :integer
  end
end
