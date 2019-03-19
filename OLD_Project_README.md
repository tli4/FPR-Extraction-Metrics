# CSCE606Project_Team_DeadPool

#### The customer would like us to add new features and fix some bugs in the Faculty Progress Report code.
###### 1. Exporting to Excel:
* When the data is being exported to excel, the order of the semester should be in descending order with the current semester on top.
* Also the customer would like us to change the semester format. For example, change 2016C to FA16, change 2016A to SP16 and change 2016B to SU16.

###### 2. Evaluation Data:
* Add a new column that shows the number of student that filled the evaluation form from PICA.

###### 3. Instructor List:
* Put in a button that enables user to delete or hide instructor’s name from the list (only from the list, not the database).
* If the UIN information is available, delete duplicate names with unique UINs.Show the instructor list in Alphabetical order using their last names.

###### 4. Historical Data (2001 – 2009):
* The only data available in PICA is from 2010, the customer would like us to add a feature that would enable the user to add historical data without any calculations. The calculations have already been done in the historical data to be added.

###### 5. Calculations:
* Double check the calculations are correct.

Code: https://github.com/coltonriedel/bluesky
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
   
