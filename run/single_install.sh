git checkout -- .
git pull origin master
bundle exec rake assets:clean
bundle exec rake assets:precompile
bundle exec rake db:migrate RAILS_ENV=production
sudo chown -R www-data:www-data ../mos
sudo chmod -R 777 ../mos
sudo service apache2 restart

