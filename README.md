# ReviewMonitor

<!--[![Build Status](https://travis-ci.org/RishabhTayal/ReviewMonitor.svg?branch=master)](https://travis-ci.org/RishabhTayal/ReviewMonitor)-->
[![Build Status](https://www.bitrise.io/app/099415a1bcf4a25a/status.svg?token=VuY22jFJYDnnR9Fmrg83EA)](https://www.bitrise.io/app/099415a1bcf4a25a)
[![Version](https://img.shields.io/github/release/RishabhTayal/ReviewMonitor.svg)](https://github.com/RishabhTayal/ReviewMonitor/releases/latest)
[![GitHub contributors](https://img.shields.io/github/contributors/RishabhTayal/ReviewMonitor.svg)](https://GitHub.com/RishabhTayal/ReviewMonitor/graphs/contributors/)
[![License](https://img.shields.io/badge/license-MIT-999999.svg)](https://github.com/RishabhTayal/ReviewMonitor/blob/master/LICENSE)
[![Contact](https://img.shields.io/badge/contact-%40Rishabh_Tayal-3a8fc1.svg)](https://twitter.com/Rishabh_Tayal)

# What is ReviewMonitor?
ReviewMonitor is an iOS app to **manage** your iTunes Connect account on the go. The Apple iTunes Connect iOS app is nice, but lacks features like:

- TestFlight build management.
- Submitting build for App Store/TestFlight review.
- View App Store reviews and respond to them.
- Support for multiple account login.

This project aims to make an iOS app which is more powerful than the Apple's official iTunes Connect app. Some features like multiple account login are already implemented.

# Why
You might ask, why do we need another app for managing iTunes Connect since there is already one by Apple. 

- [iTunes Connect](http://itunesconnect.apple.com) interface is not mobile friendly and very slow.
- iTunes Connect official app lacks features such as TestFlight management, Build management, multiple account support.

# How does it work?
The iOS app communicates with a [server](https://github.com/RishabhTayal/itc-api) hosted on Heroku, which then interacts with the Apple API. First you need to deploy and host the server on heroku. After the server is hosted, you need to specify the server path in the app in the format `https://example.herokuapp.com/`. Then the app will communicate to your hosted server and the hosted server will communicate to the Apple iTunes Connect.

**Your iTunes Connect credentails and any other sensitive information are not stored/viewed by the app.**

This happens using [fastlane](https://fastlane.tools), which is written in Ruby.

# Installation
### Server
Deploy your server and use the server url in the app. Click the Heroku button to instant deploy.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/RishabhTayal/itc-api)

# Why not on App Store?
This app won't be published on the App Store. Apple won't allow an app which asks users to login with their iTunes Connect account and use of unauthorized iTunes Connect web APIs.

![Sad](https://media.giphy.com/media/NTY1kHmcLsCsg/giphy.gif)

# Contributing
Want to see something implemented in the app? We are always looking for some contributors who can help with some more features. Read the [Contribution Guideline](https://github.com/RishabhTayal/ReviewMonitor/blob/master/.github/CONTRIBUTING.md).

Create an [issue](https://github.com/RishabhTayal/ReviewMonitor/issues/new) or [PR](https://github.com/RishabhTayal/ReviewMonitor/compare) if you are interested. 

Want to get involved in discussions? Join our [Slack channel](https://itc-manager-slack-invite.herokuapp.com)
