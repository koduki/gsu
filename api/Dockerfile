FROM ruby

RUN gem install google-api-client googleauth sinatra
COPY --from=gcr.io/berglas/berglas:latest /bin/berglas /bin/berglas

ADD ./ /app
WORKDIR /app

CMD ["/bin/berglas", "exec", "ruby", "app.rb"]