require './lib/model'

class App
	def main
		loop do
			s = insert_random
			puts s.score.round(2)
			sleep 2
		end
	end

	def insert_random
		s = UserScore.new
		s.user_id = (rand() * 10).to_i
		s.score = rand() * 70 + 30
		s.save_changes
		return s
	end
end

App.new.main
