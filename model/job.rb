require 'aasm'

class Job
  include AASM

  aasm do
    state :start
    state :md5ed, :enter => :md5
    state :finished, :enter => :finish

    event :md5 do
      transitions :from => :start, :to => :md5ed
    end

    event :finish do
      transitions :from => :md5ed, :to => :finished
    end
  end

  def md5
    # begin
    #   db = SQLite3::Database.open "db/mykiq"
    #   db.execute "INSERT INTO job (status) VALUES ('start')"
    #   job_id = db.last_insert_row_id
    # rescue SQLite3::Exception => e
    #   puts "Exception occurred"
    #   puts e
    # ensure
    #   db.close if db
    # end
    puts "md5ed"
  end

  def finish
    puts "finished"
  end
end