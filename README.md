[![CircleCI](https://circleci.com/gh/benjy2429/circleci-build-monitor/tree/master.svg?style=shield)](https://circleci.com/gh/benjy2429/circleci-build-monitor/tree/master)

# CircleCI Build Monitor

A simple Ruby on Rails build monitor app for CircleCI projects. Inspired by the [Jenkins Build Monitor Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Build+Monitor+Plugin).

## Usage

Clone the repository

`$ git clone https://github.com/benjy2429/circleci-build-monitor.git`

Install dependencies

`$ bundle install`

Run the server

`$ rails s`

Access the build monitor at http://localhost:3000

## Configuration

### CircleCI Token

For the app to access your projects, you must create an API token on CircleCI. The app is currently designed to use your user API token which can be generated from your [account settings](https://circleci.com/account/api).

Once you have generated a token, pass it to the app in the `CIRCLECI_TOKEN` environment variable. The app will display all the projects you are watching.

### Hiding Projects

You can specify which projects you want to display using the `config/projects.yml` file.

Only the projects specified in this file will be displayed on the monitor, all other projects will be hidden. The projects must use the following format:

```
- author/repo
- author/repo
...
```

### Poll Rate

To keep the monitor up to date, it will repeatedly poll the CircleCI servers every 30 seconds. You can change the number of seconds between refreshes using the `POLL_RATE` environment variable.

## Testing

Run the unit tests

`$ rake test`

Run rubocop static code analyzer (with rules defined in `rubocop.yml`)

`$ rubocop`

Both of these tasks are required for a successful build on CircleCI. All commits pushed to the remote will trigger a new build.

## Contributing

Feel free to submit an issue if you spot a bug, or submit a pull request if you have an improvement. Ensure that all code contributions are developed on their own feature branches.
