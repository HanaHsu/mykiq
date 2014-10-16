module MyWorker
  class Md5Worker
    include Sidekiq::Worker
    sidekiq_options({:queue => :md5_worker, :retry => :false}) #define the name of queue

    def perform(job_id)
      1.upto(3) do
        #md5 = Digest::MD5.file("#{File.expand_path(File.dirname(__FILE__))}/../test_file/test.mkv").hexdigest
      end

      begin
        db = SQLite3::Database.open "db/mykiq"
        db.execute "UPDATE job SET status='md5ed' WHERE Id=#{job_id}"

        puts "===================================job(#{job_id}) md5ed at #{ Time.now }==================================="

        MyWorker::FinishJobWorker.perform_async(job_id)

      rescue SQLite3::Exception => e
        puts "Exception occurred"
        puts e
      ensure
        db.close if db
      end
    end
  end
end