release: bundle exec ruby setup_db.rb
web: bundle exec thin start -R config.ru -e $RACK_ENV -p ${PORT:-5000}
