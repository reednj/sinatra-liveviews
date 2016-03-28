require 'sequel'
require 'sqlite3'

DB = Sequel.sqlite './liveviews.demo.db'

DB.create_table? :user_scores do
	primary_key :id
	Integer :user_id, :null => false
	Float :score
end

class UserScore < Sequel::Model

end
