module MyWorker
  class FinishJobWorker
    include Sidekiq::Worker
    sidekiq_options({:queue => :finish_job_worker, :retry => :false}) #define the name of queue

    def perform(job_id)
      begin
        db = SQLite3::Database.open "db/mykiq"
        db.execute "UPDATE job SET status='finished' WHERE Id=#{job_id}"

        puts "===================================job(#{job_id}) finished at #{ Time.now }==================================="

      rescue SQLite3::Exception => e
        puts "Exception occurred"
        puts e
      ensure
        db.close if db
      end
    end
  end
end