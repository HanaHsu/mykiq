module MyWorker
  require "sqlite3"
  require File.dirname(__FILE__) + "/create_job_worker.rb"
  require File.dirname(__FILE__) + "/md5_worker.rb"
  require File.dirname(__FILE__) + "/finish_job_worker.rb"
end