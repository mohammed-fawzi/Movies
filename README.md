
# Movies App

##  Clip

![Alt Text](https://i.ibb.co/ZK4GHYB/Movies.gif)
https://i.ibb.co/GCNHv2x/Movies-App.gif

##  Screen Shots

<p float="left">
  <img src="https://i.ibb.co/5jFK7Xx/listView.png" width="22%" /> <img src="https://i.ibb.co/vxM6Xqq/search.png" width="22%" /><img src="https://i.ibb.co/09WC8ZJ/details.png" width="22%" /><img src="https://i.ibb.co/vxM6Xqq/search.png" width="22%" />
</p>

##  Deploy
just add your API key in 
Movies/Data/Network/EndPoints/Constants

## Technical Decisions

### 1.   Architecture

MVVM with clean Architechture

![Alt Text](https://i.ibb.co/pJ4ZrcK/Clean-architechure.jpg)

### 2.   Reusability
- Reusable local and remote sources to serve the entire app.
- As all three tabs for (Trending, Popular, Upcoming) Lists are identical in terms of the UI design and functionality, I will create a reusable (view controller, XIB, view model, use case, Repo) and create three different instances, only changing the endpoint they will communicate with.

### 3.   Dependency Management
A dependency container technique serves the whole app, unifies all creation logic in one place, and can easily be tweaked to include child containers for each module for a more modular approach and smaller files.

### 4.   Navigation
An App Coordinator is used, which starts with a root navigation controller and handles all the navigation logic. It can also be easily tweaked to include child coordinators for each module for a more modular approach and smaller files.

### 5.   Offline Support
##### -  **API Response**
As our app needs no data manipulation and just simple read operations, we can cache API responses directly without mapping them to a core data model for offline support, which offers several benefits:

1. **Reduce development effort**: directly caching API responses eliminates the need to create and maintain data models which reduces the complexity and effort needed 
2. **Faster Deployment**: as we don't need to map the data to a specific model, developers can implement caching faster and speed up time to market.
3. **Consistency**: By caching raw API responses, the cached data remains consistent with the server, minimizing the differences between the cached and live data.
4. **Simplified Data Management**: Keeping the data in its original form simplifies versioning and updates, as changes in the API do not require corresponding changes in the data models.
5. **Makes error handling a lot easier** as fewer things can go wrong

##### -  **Images**
There are different techniques we can use, but for sure, storing images directly in core data is not the best decision.
We should store them in the file system and only store their path into core data if we used the model mapping caching technique and if we need to persist this data for a long time, but as we decided to store the raw response directly, we will use the below approach.

We will use **two caching** layers to speed things up and improve the scrolling experience.

1- **Using URLCache**:
which is a native solution provided to us by Apple and will give us several benefits, such as:
- use in memory and disk cache 
- We can determine the cache size.
- integrated with the URL session by default. 
- has a default cache eviction mechanism.

2- **Using NSCache**:
used with a memory limit to store created images in memory for faster rendering.

#### 4.   Unit Testing
For unit testing, I always follow the below rules.
- **Only test public interfaces**
    - only test the public interfaces and never the private ones directly, as they should be tested via the public methods that call them.
    - Never change their access modifiers to be easier in testing, which could be tempting at first but will lead to a lot of issues and will make the test cases neither maintainable nor reliable as they will be broken with any code refactor with no changes in business requirements or functionality.
- **Isolate SUT using the convenient Test Doubles**
    - Mock and stub all the dependencies, then test each layer separately to easily spot the bug location.
- **TestFunctionName_input_output() naming convention**
    - this naming convention helps a lot in understanding the unit covered by the test case.
    - serve as a replacement for documentation, as you can read each function test case and understand all its functionalities.

#### 5.   Commits
I tend to use [conventinal commits](https://www.conventionalcommits.org/en/v1.0.0/ "conventinal commits") which leads to better readability and communication across team members.

