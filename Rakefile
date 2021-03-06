require 'spec/rake/spectask'

task :default => :test
task :test => :spec

if !defined?(Spec)
  puts "spec targets require RSpec"
else
  desc "Run all examples"
  Spec::Rake::SpecTask.new('spec') do |t|
    t.spec_files = FileList['spec/**/*.rb']
    t.spec_opts = ['-cfs']
  end
end

namespace :db do
  desc 'auto_migrate the database (destroys data)'
  task :rebuild => :environment do
    DataMapper.auto_migrate!
  end

  desc 'Auto-upgrade the database (preserves data)'
  task :upgrade => :environment do
    DataMapper.auto_upgrade!
  end

  desc 'rebuilds the database and imports delimited alphabet data'
  task :import => :environment do
    DataMapper.auto_migrate!
    f = File.open("alphabets.csv")
    f.readlines.each do |line|
      parts = line.split(";")
      puts parts[0]
      a = Alphabet.create!(
        :name => parts[0],
        :language => parts[1],
        :notes => parts[2],
        :year => parts[3]
      )
      a.import_letters(parts[4])
    end
    
    # Save all alphabets to ensure janky-ass datamapper callbacks really get called
    Alphabet.all.map{|a| a.save }
  end

end

namespace :gems do
  desc 'Install required gems'
  task :install do
    required_gems = %w{ sinatra rspec rack-test dm-core dm-validations
      dm-aggregates haml ratpack }
    required_gems.each { |required_gem| system "sudo gem install #{required_gem}" }
  end
end

task :environment do
  require 'environment'
end
