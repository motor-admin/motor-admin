FROM ruby:2.7.1

ENV RAILS_ENV=production

WORKDIR /opt/motor-admin

COPY ./Gemfile ./Gemfile.lock ./

RUN bundle config set with 'production' && bundle install

COPY . ./

CMD ["/opt/motor-admin/bin/motor-admin"]
