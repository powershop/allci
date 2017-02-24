# Quickstart

* Run a docker registry:

  ```
  docker pull registry:latest
  docker run -p 5000:5000 registry:latest
  ```

* Start a new terminal.  Check out this app, and install the bundle:

  ```
  bundle install
  bundle exec rails s
  ```

* Create and migrate the database:

  ```
  bundle exec rake db:setup
  ```

* Seed a job to build, since there's no UI yet:

  ```
  bundle exec rake db:seed
  ```

* Start a new terminal.  Check out the allci-runner repo.

* Start a runner node, pointing back to the app you started earlier:

  ```
  CI_SERVICE_URL=http://localhost:3000 ./runner.rb
  ```

* If you'd like to run a second runner node on the same machine, start another terminal and run the script again with a different `RUNNER_NAME`:

  ```
  CI_SERVICE_URL=http://localhost:3000 RUNNER_NAME=myhostname-2 ./runner.rb
  ```

You can repeat the `db:seed` step whenever you want to queue another build.
