require 'sequel'
require_relative '../config/app.config'

DB = Sequel.connect DB_CONFIG

class Sequel::Model
	def to_json(args)
		self.values.to_json(args)
	end
end

class Sequel::Dataset
	def on_count_change(&block)
		Thread.new do
			loop { await_count_change(&block) }
		end
	end

	def await_count_change
		polling_interval = 1.0
		current_count = self.count

		loop do
			break if self.count != current_count
			sleep polling_interval
		end

		yield(self)
	end
end

DB.create_table? :user_scores do
	primary_key :id
	Integer :user_id, :null => false
	Float :score
end

class UserScore < Sequel::Model

end
