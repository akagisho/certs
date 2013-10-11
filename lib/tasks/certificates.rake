namespace :certificates do
  task :update_expirations => :environment do
    Certificate.all.each do |certificate|
      certificate.delay.update_expiration
    end
  end
end
