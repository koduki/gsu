FROM ruby

RUN gem install google-api-client googleauth sinatra

RUN mkdir -p /app
WORKDIR /app

CMD ["ruby", "app.rb", "-p", "8080", "-o", "0.0.0.0"]