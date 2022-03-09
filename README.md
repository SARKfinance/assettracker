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
* User can see the daily changes/trends in their investment value
* User can see more information about a specific company
* User can add/delete an investment to a watchlist

**Optional Nice-to-have Stories**

* Users can chat with other users about their investments


### 2. Screen Archetypes

* Login
   * User can press a button to sign up for a new account
   * User can log in
* Sign Up
   * User can sign up for a new account
* Main investment screen
   * User can add individual investment
   * User can delete individual investment
* Trends screen
    * User can see daily changes/trends in their investment value
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
* Trends screen
* Watchlist screen

**Flow Navigation** (Screen to Screen)

* Login
   * Home
   * Sign up
* Sign up
   * Home
* Main investment screen
   * Company info (tap on the individual investment to see more information)
* Trends screen
    * None
* Company info screen
    * Back button to main investment screen or watchlist screen
* Watchlist screen
    * Company info (tap on the individual investment to see more information)

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
* Login
    * (Post) Login to application
  <code>
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
        }
  </code>

*	Sign Up
    *	(create/post) Create user

  <code>
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
  </code>

*	Main investment screen
    * (read/get) query investment objects based on logged in user.
    <code>
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
  </code>
    *	(read/get) query api based on investment object to obtain company logo and current price
    *	(create/post) create a new investment to add to the portfolio
    *	(update/put) Update specific investment option information
    *	(delete) delete investment from the portfolio
*	Trends screen
    *	(read/get) query for current investment values (price over time)
*	Company info screen
    *	(read/get) query for company information
*	Watchlist screen
    *	(create/post) add investment to watchlist.
![image](https://user-images.githubusercontent.com/71610664/157367230-735a2e36-7450-496c-a04f-6348c78ce7e3.png)

