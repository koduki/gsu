FROM ruby

RUN gem install google-api-client googleauth google-cloud-tasks sinatra
RUN cd /opt && curl -L https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-308.0.0-linux-x86_64.tar.gz| tar xfvz -

ADD ./ /app
WORKDIR /app

CMD ["./run.sh"]