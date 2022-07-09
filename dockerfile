FROM ruby:2.7

# RUN echo 'deb https://mirrors.aliyun.com/debian/ bullseye main non-free contrib' > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y nodejs
RUN apt-get install -y npm
RUN apt-get install -y cron

RUN npm install --global yarn

# Create a dedicated user for running the application

# RUN adduser -D my-sinatra-user

# Set the user for RUN, CMD or ENTRYPOINT calls from now on

# Note that this doesn't apply to COPY or ADD, which use a --chown argument instead

# USER my-sinatra-user

# Set the base directory that will be used from now on

# WORKDIR /home/my-sinatra-user

# COPY --chown=my-sinatra-user Gemfile .


WORKDIR /opt

COPY Gemfile Gemfile.lock /opt/
RUN bundle install

COPY yarn.lock /opt/
RUN yarn

EXPOSE 3000
