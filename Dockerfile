# Use an official Ruby image with the specified version
FROM ruby:3.2.5

# Install dependencies for the app
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  postgresql-client \
  sqlite3 \
  && rm -rf /var/lib/apt/lists/*

# Set up the working directory
WORKDIR /rails

# Copy the Gemfile and Gemfile.lock
COPY Gemfile /rails/Gemfile
COPY Gemfile.lock /rails/Gemfile.lock

# Install Ruby gems
RUN bundle install

# Copy the rest of the application code
COPY . /rails

# Expose the port the app will run on
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]