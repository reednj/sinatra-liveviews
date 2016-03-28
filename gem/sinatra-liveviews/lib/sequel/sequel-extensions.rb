# we don't actually want this to be dependent on sequel, so only add
# the extensions if its already been included in the app
if defined? Sequel

	class Sequel::Dataset
		def on_count_change
			Thread.new do
				loop do 
					await_count_change
					yield(self)
				end
			end
		end

		def await_count_change
			polling_interval = 1.5
			current_count = self.count

			loop do
				break if self.count != current_count
				sleep polling_interval
			end
			
		end
	end

end