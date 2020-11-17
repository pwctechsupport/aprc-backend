FROM ruby:2.5.3

# Install plugin
RUN apt-get update -qq && apt-get install -y build-essential vim

# Install mysql
RUN apt-get install -y default-libmysqlclient-dev

# Install imagemagick
RUN apt-get update
RUN apt-get -y install --only-upgrade imagemagick
RUN apt-get -y install libxrender1
RUN apt-get update -qq && apt-get install -y wkhtmltopdf xvfb

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - &&\
    apt-get install -y nodejs

RUN npm install -g yarn

# Clears out the local repository of retrieved package files
RUN apt-get -q clean

# Set an environment variable where the Rails app is installed to inside of Docker image
ENV APP_PATH /usr/src/app
RUN mkdir -p $APP_PATH

# Set working directory
WORKDIR $APP_PATH

# Setting env up
ENV RAILS_ENV development
ENV RACK_ENV development
ENV SECRET_KEY_BASE d4122a8a2482219aa045388d7511b43ab4506170b70d13058edba5b12d41d83c68a107dc63a03c0cf677f255f9d7c02c8d01bb662567697c0ea22328d239ea6f
# Setting local
ENV LC_ALL C.UTF-8
# Setting timezone
ENV TZ Asia/Bangkok
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# COPY Gemfile & Gemfil.lock
COPY Gemfile* $APP_PATH/
# Run bundle
RUN gem install bundler -v 2.1.4
RUN bundle install
# Adding project files
COPY . $APP_PATH/

RUN yarn install --check-files

# Build Frond-End
# RUN RAILS_ENV=$RAILS_ENV bundle exec rake assets:precompile

# EXPOSE 3000

# CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]