# Skeleton for a Python - Flask app using PostgreSQL (optionally)

This document explains the requirements and some additional information about this project.

## Requirements

The software requirements for this project are the following:

* Python 3.11
* Flask 3.0.0
* Postgres 15.4

## Additional information

* The directory where the code is located by default is `src`, if you want all the code in the root directory of the repository, modify the variable `SRC_BUILD` to `.` in `docker/local/.env`. For more information, read the doc: `docker/local/README.md`
* In case you are hosting the repository in GitHub, you might want to rename the folder `.github-template` to `.github` so you can use the default settings configured (some variables must be changed in those files).
* The following configuration is set in `.github-template` folder:
    * A [Codeowners](https://docs.github.com/es/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners) file.
    * Templates for:
        * Pull requests.
        * Security notifications.
        * Issues.
        * Features.
    * Two workflows are created:
        * Testing the application is a very basic way.
        * Run linters.

## Usage

To create a local environment, you can follow the README located at `docker/local/`.
