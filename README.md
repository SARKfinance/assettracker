Original App Design Project - README Template
===

# Asset Tracker

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview 
### Description
The SARK Finance app allows users to consolidate their investments into one portfolio for simplified performance monitoring.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Finance
- **Mobile:** 
- **Story:** Allows users to keep track of their stock investments across different brokerages/exchanges
- **Market:** Any user interested in personal finance
- **Habit:** User would typically check the app at least once a day to keep track of their investments
- **Scope:** Start out by focusing on typical investments, possibly could expand to real estate/crypto other areas?

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Users can sign up for a new account
* Users can log in
* User can add individual investments
* User can delete individual investments
* User can see more information about a specific company
* User can add/delete an investment to a watchlist

**Optional Nice-to-have Stories**

* Users can chat with other users about their investments
* Users can see daily/weekly/monthly trends about their portfolio


### 2. Screen Archetypes

* Login
   * User can press a button to sign up for a new account
   * User can log in
* Sign Up
   * User can sign up for a new account
* Main investment screen
   * User can add individual investment
   * User can delete individual investment
* Company info screen
    * User can see more information about the company
* Watchlist screen
    * User can add/delete an investment to a watchlist

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Login
* Sign up
* Main investment/home screen
* Company info screen
* Watchlist screen

**Flow Navigation** (Screen to Screen)

* Login
   * Home
   * Sign up
* Sign up
   * Home
* Main investment screen
   * Company info (tap on the individual investment to see more information)
   * Watchlist screen (swipe from right or possibly tab bar at bottom)
* Company info screen
    * Back button to main investment screen or watchlist screen
* Watchlist screen
    * Company info (tap on the individual investment to see more information)
    * Main investment screen (swipe from left or possibly tab bar at bottom

## Wireframes

### [BONUS] Digital Wireframes & Mockups
<p float="left">
  <img src="https://github.com/SARKfinance/assettracker/blob/main/Login%20Screen.png" height=350>
  <img src="https://github.com/SARKfinance/assettracker/blob/main/Sign%20up%20screen.png" height=350>
  <img src="https://github.com/SARKfinance/assettracker/blob/main/Main%20Screen%20and%20Watchlist.png" height=350>
  <img src="https://github.com/SARKfinance/assettracker/blob/main/Company%20Details%20Screen.png" height=350>
</p>


## Schema 
[This section will be completed in Unit 9]
### Models
   Investment
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the investment(default field) |
   | author        | Pointer to User| the owner of the investment |
   | name       | String   | the ticker for that stock |
   | price | Number   | the price at which the user bought the investment |
   | boughtAt     | DateTime | the date the user bought the investment |
   | brokerage     | String | the brokerage the user's investment is held at |
   
### Networking
* Login
    * (Post) Login to application

      ```
        let username = usernameField.text!
        let password = passwordField.text!
  
        PFUser.logInWithUsername(inBackground: username, password: password)
          {
          (user, error) in
          if user != nil {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
          } else {
            print("Error: \(String(describing: error?.localizedDescription))")
          }
        }

      ```

*	Sign Up
    *	(create/post) Create user

        ```
          let user = PFUser()
  
          user.username = usernameField.text
          user.password = passwordField.text

          user.signUpInBackground{(success, error) in
              if success {
                  self.performSegue(withIdentifier: "loginSegue", sender: nil)
              } else {
                  print("Error: \(String(describing: error?.localizedDescription))")
              }
          }
        ```

*	Main investment screen
    * (read/get) query investment objects based on logged in user.
      ```
      let query = PFQuery(className: "Investments")
          query.whereKey("author", equalTo: currentUser)
          query.findObjectsInBackground{
           (stocks, error) in
              if stocks != nil {
                  self.stocks = stocks!
                  self.tableView.reloadData()
                }
            }
        }
      ```
    *	(create/post) create a new investment to add to the portfolio

        ```
          let investment  = PFObject(className: "Investment")
          investment["name"] = investmentNameField.text!
          investment["price"] = investmentPriceField.text!
          investment["purchase_date"] = investmentDate.text!
          investment["brokerage"] = investmentBrokerageField.text!

        investment.saveInBackground {
          (success, error) in 
          if success {
            self.dismiss(animated: true, completion:nil)
          } else {
            print("error!")
          }
        }
        ```
  
    *	(update/put) Update specific investment option information
    *	(delete) delete investment from the portfolio

*	Company info screen
    *	(read/get) query for company information
*	Watchlist screen
    *	(create/post) add investment to watchlist.
    *	(delete) delete investment
![image](https://user-images.githubusercontent.com/71610664/157367230-735a2e36-7450-496c-a04f-6348c78ce7e3.png)

