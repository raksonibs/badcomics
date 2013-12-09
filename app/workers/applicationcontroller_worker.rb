class ApplicationControllerWorker
	include Sidekiq::Worker

	def perform
	end
end