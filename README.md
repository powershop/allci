# Deploying allci

These instructions will set up allci with a single master node and multiple worker nodes.  You can add extra master nodes later.

## Dependencies

* If you don't already have a docker registry, run one on your master node:

  ```
  docker pull registry:latest
  docker run -p 5000:5000 registry:latest
  ```

* If you don't already have a mysql/mariadb server, install and run one on your master node.

## AllCI web app

* Check out this repository and build the docker image:

  ```
  git clone https:://github.com/powershop/allci.git
  cd allci
  docker build -t allci .
  ```

* Create the database:

  ```
  docker run -p 3000:3000 -e ALLCI_DATABASE_SERVER=<your database server> -e ALLCI_DATABASE_USERNAME=<the database user you created> -e ALLCI_DATABASE_PASSWORD=<the database password> -e RAILS_ENV=production allci bundle exec rake db:create db:migrate
  ```

* Run the web app, giving it the name of your docker registry server, telling it to restart on failure:

  ```
  docker run -p 3000:3000 -e ALLCI_DATABASE_SERVER=<your database server> -e ALLCI_DATABASE_USERNAME=<the database user you created> -e ALLCI_DATABASE_PASSWORD=<the database password> -e RAILS_ENV=production -e REGISTRY_HOST=http://<your docker registry server>:5000 --restart allci
  ```

The docker `REGISTRY_HOST` needs to be accessible by this name on the runner nodes too, so you shouldn't use `localhost` in `REGISTRY_HOST` unless you intend to only run runners on the same node as the web app.

You can then expose the web app via your load balancers or webservers.

## AllCI runner

You can run the runner in the same node as the master node, but it's more common to run them on their own VMs or hosts.

* Check out the runner app and build the docker image:

  ```
  git clone https:://github.com/powershop/allci-runner.git
  cd allci-runner
  docker build -t allci-runner .
  ```

* Run one or more copies of the runner, pointing it back to your master node, giving it access to the docker engine so it can build and run containers, and telling it to restart on failure:

  ```
  docker run -ti -e CI_SERVICE_URL=http://<your master node>:3000 -h `hostname`-runner1 -v /var/run/docker.sock:/var/run/docker.sock --restart allci-runner
  docker run -ti -e CI_SERVICE_URL=http://<your master node>:3000 -h `hostname`-runner2 -v /var/run/docker.sock:/var/run/docker.sock --restart allci-runner
  ```

The hostnames must be unique but are otherwise arbitrary, but they should be specified so that the runner sees the same name each time the container is restarted.  If you prefer, you can let docker randomly choose the hostname, but specify the runner name using `-e RUNNER_NAME=<name>`.

How many runners you should run on each node depends on your CI jobs - if they do not parallelize themselves, you probably want one runner per core.

Repeat the above steps on each node you would like to use as an AllCI runner.

# Quickstart for developing allci

You can use the above instructions, but it is faster to run allci and the runner scripts locally, without having to docker build to run them.

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

* Make sure you have a mysql/mariadb instance running.  You can set the `ALLCI_DATABASE_SERVER` environment variable if it's not running on `localhost`.

* Create and migrate the database:

  ```
  bundle exec rake db:setup
  ```

* Seed a job to build, since there's no UI yet:

  ```
  bundle exec rake db:seed
  ```

* Start the web app:

  ```
  bundle exec rails server
  ```

* If the docker registry you want to save the images on isn't on the same machine, you can specify it using `REGISTRY_HOST`:

  ```
  REGISTRY_HOST=docker-registry.mynet:5000 bundle exec rails server
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


## Resources

Design mockup [allci-mockup.pdf](./allci-mockup.pdf)
