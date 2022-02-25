Notes App 
========
Simple Web Application with CRUD examples using Flask, SQL Alchemy ORM and Python 3.8.
 
> **Note:** Python v3.8.10 have been used to create this project. :pushpin:
> 
> Download it from here [Python v3.8.10](https://www.python.org/downloads/release/python-3810/)

## Preparing for Development
Follow these steps to start developing with this project:
1. Ensure `pip` and `pipenv` are installed
2. Clone repository: `git clone git@github.com/edenilsonpineda/notesapp`
3. `cd` into the repository
4. Create the database, running the script inside the folder `db_dump`
   1. Both Ubuntu and CentOS scripts are available. 
      1. Both Scripts install the docker engine and the required docker container with a Postgres Database

5. Activate virtualenv: `pipenv shell`
6. Install dependencies: `pipenv install`
7. Create a `.env` file inside the root folder with the following Environment Variables (Change the values accordingly to your environment)
```sh
export DB_USERNAME='username'
export DB_PASSWORD='a_secure_password'
export DB_HOST='192.168.x.x'
export DB_PORT='5432'
export FLASK_ENV='development'
export FLASK_APP='.'
```
7. Call the env file with: `source .env`
8. Make the db migration with: `flask db migrate`
9. If there's any changes in the db schema you'll need to upgrade it with the following command: `flask db upgrade`

## To Run
On the terminal with the virtualenv activated, run the following command on the project's directory:
```sh
$ flask run --host=0.0.0.0 --port=3000
```
Now you should be able to see the app on your browser, typing `http://localhost:3000/log_in` or `http://{your_ip_address}:3000/log_in`

 