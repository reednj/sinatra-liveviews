require 'sequel'
require_relative '../config/app.config'

DB = Sequel.connect DB_CONFIG

class Sequel::Model
	def to_json(args)
		self.values.to_json(args)
	end
end

DB.create_table? :user_scores do
	primary_key :id
	Integer :user_id, :null => false
	Float :score
end

class UserScore < Sequel::Model

end
