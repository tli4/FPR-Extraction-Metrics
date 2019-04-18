# FPR-Extraction-Metrics

To get started, clone the repo and then:

If working on macos: 
* `brew install postgresql`
* `bundle install`
* `rake db:migrate`
* `rake db:seed`

   * `rails server`


If deploying on Heroku: 
* `heroku create fpr-ext-met-kernelpanic --stack heroku-16`
* `git push heroku master`
* `heroku run rake db:migrate`
* `heroku run rake db:seed`

Heroku Link: https://fpr-ext-met-kernelpanic.herokuapp.com/
Heroku Demo App Admin login:
* User name: kernelpanic@csce606.com
* password: 12345678
