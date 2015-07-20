This is a Sinatra app I helped make for an assignment with a team of other students. We used the Twitter gem (https://rubygems.org/gems/twitter) for interacting with the Twitter API, BCrypt for authentication (https://rubygems.org/gems/bcrypt), and Bootstrap for the frontend design (http://getbootstrap.com/). We used an SQLite database for user details and storing the user's followers and other commonly reused data, to avoid exceeding the API request limit. Cucumber was used for Acceptance testing to the user stories we agreed with the client.

Below is some of the original readme, with instructions for getting the project running for development if you wish:

## File Structure

- erb files go in the views folder
- css and js goes in the public folder
- extra controller files go in the controllers folder
- all files involving testing/cucumber go in the features folder
- database files go in the models folder
- everything else doesn't go in a folder

## TO RUN WEBSITE

1. Please ensure to run 'rake' while in the project's directory
2. Ensure all required gems in bundler are installed
3. Run website.rb
4. For testing purposes, login information is:
    email: 123@gmail.com
    password: 123

## Database creation/editing

Don't edit the .sqlite database directly, instead, edit the databaseSchema.sql file, and regenerate the database by
running 'rake' the directory of the project.

If you get a merge conflict related to the .sqlite database, just re-run rake.

If you need something to run before the ruby script is executed (usually once when the server is started for the first time),
consider adding it to the Rakefile.

## Testing

Due to issues with Capybara and javascript, the scenarios involving javascript use Selenium as a javascript driver - you need Firefox
installed on the system where cucumber is being run.

Please be aware that running tests on all the feature files can take up to 5 minutes to complete.

To ensure tests are run correctly, please carry out the following before running cucumber:

1. run 'rake' in the project directory
2. run the website and press the 'Follow' button on the automatic following page
