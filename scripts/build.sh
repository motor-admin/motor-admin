sed '/development/,$d' Gemfile | tee Gemfile2

mv Gemfile2 Gemfile

bundle inst

rm -rf public/packs

SECRET_KEY_BASE=`openssl rand -hex 50` RAILS_ENV=production rake assets:precompile

../ruby-packer/bin/rubyc ./bin/motor-admin

echo

git checkout Gemfile Gemfile.lock
