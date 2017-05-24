# Apple Managers
A simple application that show the use of Core Data with CollectionView

## Project organization

The project contains 2 targets:

 - AppleManagers: that is representing the app 

 - ManagersAPI: a framework to taking care of retriving the data. Today from a local JSON but we can easly extends it to download from an endpoint.


A target is represented by a unique folder that contain the Info.plist file and 2 folders:

 - Sources: that should only contains .swift, .storyboard and .xib files

 - Resources: that contain the resources of the target like image assets, app launch screen storyboard, core data models, json files...


## Prerequisites

### Using Bundle (optional but better)


I use bundle to help me with the installation of gems that I use for iOS developement (like Fastlane, Danger or even Cocoapods).

#### If you don't have bundle installed

```
gem install bundler
```

#### Install and Configure the project
```
git clone git@gitlab.com:barrault01/appleManagers.git
cd appleManagers
bundle install
bundle exec pod install
open AppleManagers.xcworkspace
```

### Whithout using bundle

As I use cocoapods for dependencies you need to have at least [cocoapods](https://cocoapods.org/) installed on your computer. If not: 

```
gem install cocoapods
```

#### Install and Configure the project
```
git clone git@gitlab.com:barrault01/appleManagers.git
cd appleManagers
pod install
open AppleManagers.xcworkspace
```

## How to Test

###
If you want to run tests locally, just use Fastlane:

```
bundle exec fastlane testing
```



## SwiftLint

This project is using [SwiftLint](https://github.com/realm/SwiftLint), it's installed throught cocoapods so that you don't need to install it on your computer. 



### Observations

I know that using Core Data is over engineering in this simple case, I can only use an array to represent the apple managers. 