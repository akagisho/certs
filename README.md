# Certs

Certs is a management tool of SSL certifications' expiration date.

## Setup (Ubuntu)

### 1. Install Dependencies

    $ sudo apt-get install git ruby rubygems ruby-dev libmysql-ruby libmysqlclient-dev unicorn nginx mysql-server
    $ sudo gem install rails

### 2. Setup MySQL Database

Create MySQL user.

    $ mysql -u root -p -e "CREATE USER 'certs'@'localhost' IDENTIFIED BY 'certs';"

Create MySQL database.

    $ mysql -u root -p -e 'CREATE DATABASE IF NOT EXISTS `certs` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`;'

Grant.

    $ mysql -u root -p -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, LOCK TABLES ON \`certs\`.* TO 'certs'@'localhost';"

### 3. Deploy Application

Deploy application.

    $ sudo mkdir -p /var/www
    $ sudo chown $USER /var/www
    $ cd /var/www
    $ git clone https://github.com/akagisho/certs.git
    $ cd certs
    $ bundle install --path vendor/bundle --without test development
    $ bundle exec rake db:migrate RAILS_ENV=production
    $ bundle exec rake assets:precompile RAILS_ENV=production

### 4. Start Application

Start unicorn server.

    $ unicorn_rails -c config/unicorn.rb -E production -D

Start delayed_job worker.

    $ ./script/delayed_job start

Set crontab.

    $ crontab -e
    30 4 * * * cd /var/www/certs; /usr/local/bin/rake certificates:update_expirations

### 5. Setup nginx

Make nginx's configuration file.

    $ sudo vim /etc/nginx/conf.d/certs.conf
    upstream certs {
        server unix:/tmp/certs.sock;
    }
    
    server {
        listen      80;
        server_name certs.example.com
        access_log  /var/www/certs/log/access.log;
        error_log   /var/www/certs/log/error.log;
    
        location / {
            proxy_set_header Host $http_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header Client-IP $remote_addr;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_pass http://certs;
        }
    
        location ~ ^/assets/ {
            root    /var/www/certs/public;
        }
    
        location = /robots.txt  { log_not_found off; }
        location = /favicon.ico { log_not_found off; }
    }

Fix nginx.conf.

    $ diff -u /etc/nginx/nginx.conf.orig /etc/nginx/nginx.conf
    --- /etc/nginx/nginx.conf.orig  2013-10-23 18:05:28.152611049 +0900
    +++ /etc/nginx/nginx.conf       2013-10-23 18:05:51.188610889 +0900
    @@ -20,7 +20,7 @@
            types_hash_max_size 2048;
            # server_tokens off;
    
    -       # server_names_hash_bucket_size 64;
    +       server_names_hash_bucket_size 64;
            # server_name_in_redirect off;
    
            include /etc/nginx/mime.types;

Restart nginx.

    $ sudo service nginx restart

### Complete!

Now you can use certs:

    http://certs.example.com/

