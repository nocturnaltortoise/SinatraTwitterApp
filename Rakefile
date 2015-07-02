namespace :setup do

  #if the database exists, delete it
  task :clean do
    if File.exists? 'models/database.sqlite'
      sh 'rm models/database.sqlite'
    end
  end

  task :import_schema do
    #should work on Windows

    #checks for unix-like system
    if ENV['PATH'].include?("/bin") || ENV['PATH'].include?("/home")
      sh 'sqlite3 models/database.sqlite < models/databaseSchema.sql' #BASH command
    else
      sh 'CMD /c "sqlite3 models/database.sqlite < models/databaseSchema.sql"' #runs command prompt command
    end

  end
end

task :default => ['setup:clean','setup:import_schema']
