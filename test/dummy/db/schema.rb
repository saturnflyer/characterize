ActiveRecord::Schema.define do
  create_table "users", :force => true do |t|
    t.string   "name",           :limit => 25, :null => false
    t.datetime "created_at",     :limit => 6,  :null => false
    t.datetime "updated_at",     :limit => 6,  :null => false
  end
end
