require './lib/model'

class App
	def main
		@score_offset = rand() * 50

		loop do
			s = insert_random
			puts s.score.round(2)
			sleep 0.34
		end
	end

	def insert_random
		s = UserScore.new
		s.user_id = (rand() * 10).to_i
		s.score = rand() * (100 - @score_offset ) + @score_offset
		s.save_changes
		return s
	end
end

App.new.main
