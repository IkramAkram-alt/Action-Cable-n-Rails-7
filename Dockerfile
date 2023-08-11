ARG RAILS_ENV

FROM ruby:3.0.4

RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    yarn \
    postgresql-client \
    redis-server 

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

# Add the entrypoint script
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
