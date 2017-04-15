Feature: Visit all of the Web Pages
  As a visitor to the website
  I want to see everything that I expect on all of the pages
  so I can know that the site is working

  Scenario: Touch all of the pages and check one field on each page

    When I go to the home page
    Then I should see "Start Here"

    When I go to the blog page
    Then I should see "The Hackety Blog!"

    When I go to the questions page
    Then I should see "Questions"

    When I go to the lessons page
    Then I should see "Lessons"

    When I go to the programs page
    Then I should see "Programs"

    When I go to the faq page
    Then I should see "Frequently Asked Questions"

    When I go to the support page
    Then I should see "Support Questions"
    
    When I go to the login page
    Then I should see "Sign In"

    When I go to the signup page
    Then I should see "Sign Up"

