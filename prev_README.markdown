# CSCE-606 Project: Faculty Reports

[![Build Status](https://travis-ci.org/rebelScrum606/faculty-report-preparation.svg?branch=master)](https://travis-ci.org/rebelScrum606/faculty-report-preparation)

To get started, clone the repo and then:

If working in cloud9: 
* `bundle install`
* `rake db:migrate`
* `rake db:seed`

   * `rails server -p $PORT -b $IP `


If deploying in Heroku: 
* `heroku create`
* `git push heroku master`
* `heroku run rake db:migrate`
* `heroku run rake db:seed`

   * `https://peaceful-lake-36541.herokuapp.com/` or `whatever`
   