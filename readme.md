在 `plain Ruby` 環境下試用 `sidekiq` ，自定流程將 `md5 一個 test.mkv 檔案` 的 job 分給對應的 worker 執行。

`workers`：
+ start_job_worker : 負責初始化一個 job
+ md5_worker : 負責將 test.mkv 做 md5 計算
+ finish_job_worker : 負責結束 job

# mykiq
```
├─── config
│   ├─── scheduler.yml  #configure scheduled job（使用 rufus-scheduler）
│   ├─── sidekiq.yml    #sidekiq configuration
├─── db                 #sqlite DB（記錄目前 job ）
├─── lib
│   ├─── run_sidekiq.rb #run sidekiq
├─── log
├─── model
│   ├─── job.rb         #嘗試使用 AASM 記錄
├─── test_file          #files to md5, all gitignore
├─── rakefile
└─── worker             #workers to do jobs
```

[Sidekiq configuration](https://github.com/mperham/sidekiq/wiki/Advanced-Options)  
[Sidekiq Scheduler](https://github.com/Moove-it/sidekiq-scheduler)

# sidekiq notes
`Sidekiq` 預設用 `redis` 存取 job queue，跑 Sidekiq 前需要先安裝好 redis ，並開啓 redis server

## install redis
```
$ brew install redis
```

## run redis server
```
$ redis-server /usr/local/etc/redis.conf
```

## install Sidekiq
```
$ gem install sidekiq
```

## run Sidekiq
in rails environment
```
$ bundle exec sidekiq
```

in plain Ruby
```
$ RACK_ENV=production bundle exec sidekiq -r sidekiq_file_path -d -L log/sidekiq.log -C config_file_path

# -r assign rb file for sidekiq
# -d daemonize sidekiq, prefer to assign log file with -L
# -C assign config file
```

in mykiq
```
$ bundle exec sidekiq -r ./lib/run_sidekiq.rb -C ./config/sidekiq.yml
```

## Sidekiq web display
使用 `webrick` 顯示 Sidekiq 狀態
### add rakefile
在 `rakefile` 中加入 `moniter` 任務

``` ruby
task :monitor do
  # optional: Process.daemon (and take care of Process.pid to kill process later on)
  require 'sidekiq/web'
  app = Sidekiq::Web
  app.set :environment, :production
  app.set :bind, '0.0.0.0'
  app.set :port, 9494
  app.run!
end
```

### run rake task
```
$ bundle exec rake moniter
```
[Sidekiq Wiki - monitoring](https://github.com/mperham/sidekiq/wiki/Monitoring)

## stop Sidekiq
```
$ bundle exec sidekiqctl stop tmp/pids/sidekiq.pid
```

# redis notes
## enter redis cli
```
$ redis-cli
```

## show keys in redis
```
> keys *
```

## show queue content
```
> lrange queue:key_name 0 -1
```

## clean redis
```
> FLUSHDB
```
