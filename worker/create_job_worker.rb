module MyWorker
  class CreateJobWorker
    include Sidekiq::Worker
    sidekiq_options({:queue => :create_job_worker, :retry => :false}) #define the name of queue

    def perform
      begin
        db = SQLite3::Database.open "db/mykiq"
        db.execute "INSERT INTO job (status) VALUES ('start')"
        job_id = db.last_insert_row_id

        puts "===================================job(#{job_id}) created at #{ Time.now }==================================="

        MyWorker::Md5Worker.perform_async(job_id)

      rescue SQLite3::Exception => e
        puts "Exception occurred"
        puts e
      ensure
        db.close if db
      end
    end
  end
end