FROM golang:1.13-buster

# Install all required packages. We need Ruby >= 2.3.1 and Python >= 2.7.0.
RUN apt-get update \
  && apt-get -y install \
    ruby-full \
    zlib1g-dev \
    python3 \
    python3-pip \
    git \
    build-essential \
    rsync \
    nodejs \
  && rm -rf /var/lib/apt/lists/*

RUN gem install bundler \
 && pip3 install Jinja2 flask

RUN mkdir /tmp/work && cd /tmp/work
WORKDIR /tmp/work

COPY config.rb Gemfile Gemfile.lock Vagrantfile /tmp/work/
RUN bundle config set path 'vendor/bundle' \
  && bundle install

COPY ./docker/install_proto.sh /tmp/install_proto.sh
RUN /tmp/install_proto.sh
RUN go get -v -u github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc

# Do some of the heavier lifting now so we already have some things cached.
RUN git clone https://github.com/lightningnetwork/lnd /tmp/apidoc/lnd \
  && cd /tmp/apidoc/lnd \
  && make
RUN git clone https://github.com/lightninglabs/loop /tmp/apidoc/loop \
  && cd /tmp/apidoc/loop \
  && go build ./...

# Copy the files last so changes won't trigger a full rebuild of the image.
COPY . /tmp/work
