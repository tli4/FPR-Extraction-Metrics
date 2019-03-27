# FPR-Extraction-Metrics

To get started, clone the repo and then:

If working in macos: 
* `brew install postgresql`
* `bundle install`
* `rake db:migrate`
* `rake db:seed`

   * `rails server`


If deploying in Heroku: 
* `heroku create`
* `git push heroku master`
* `heroku run rake db:migrate`
* `heroku run rake db:seed`

   * `https://peaceful-lake-36541.herokuapp.com/` or `whatever`