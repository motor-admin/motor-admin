sed '/development/,$d' Gemfile | tee Gemfile2

mv Gemfile2 Gemfile

bundle inst

rm -rf public/packs

RAILS_ENV=production ./bin/webpacker

../ruby-packer/bin/rubyc ./bin/motor-admin

echo

git checkout Gemfile Gemfile.lock
