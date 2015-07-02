Team 10 Intro to Software Engineering Project
=============================================

- Requirements Document: https://docs.google.com/a/sheffield.ac.uk/document/d/1uAKIaTQjjYKGWJCE6nhCRy6e-s1SDR7TjmlwhqhZbN0/edit?usp=sharing
- Assignment Brief: https://philmcminn.staff.shef.ac.uk/intro-to-software-engineering/team-project.pdf

- erb files go in the views folder
- css and js goes in the public folder
- extra controller files go in the controllers folder
- all files involving testing/cucumber go in the features folder
- database files go in the models folder
- everything else doesn't go in a folder

TO RUN WEBSITE
======================

1. Please ensure to run 'rake' while in the project's directory
2. Ensure all required gems in bundler are installed
3. Run website.rb
4. For assessment, login information is:
    email: 123@gmail.com
    password: 123


Database creation/editing
=========================

Don't edit the .sqlite database directly, instead, edit the databaseSchema.sql file, and regenerate the database by
running 'rake' the directory of the project.

If you get a merge conflict related to the .sqlite database, just re-run rake.

If you need something to run before the ruby script is executed (usually once when the server is started for the first time),
consider adding it to the Rakefile.

Testing
=======

Due to issues with Capybara and javascript, the scenarios involving javascript use Selenium as a javascript driver - you need Firefox
installed on the system where cucumber is being run.

Please be aware that running tests on all the feature files can take up to 5 minutes to complete.

To ensure tests are run correctly, please carry out the following before running cucumber:

1. run 'rake' in the project directory
2. run the website and press the 'Follow' button on the automatic following page
