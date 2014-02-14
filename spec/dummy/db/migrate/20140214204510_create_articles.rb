class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string   "title"
      t.text     "body"
      t.integer  "author_id"
      t.datetime "published_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "slug"
      t.boolean  "visible",      default: false
    end
  end
end
