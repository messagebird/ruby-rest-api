# Releasing things

In April 2025 the current way we do releases in this repo is not great. 
Fixing it for real will take some time that the team doesn't have it today. 

So here is a step by step half automated, half manual way to release a new version: 

 * Someone makes a PR that changes things for the better. 
 * The PR gets reviewed, approved and merged to `master`. 
 * Someone from the team (from now called: Marcel) decides to make a release
 * Marcel creates a new branch from master called `new-release`
 * Marcel makes a PR for that new branch. 
 * Marcel adds one of the release labels (release-major, release-minor, release-patch) to the PR. He decides to add `release-major`. 
 * Marcel reads [version.rb](https://github.com/messagebird/ruby-rest-api/blob/master/lib/messagebird/version.rb#L5) and sees that the version is `5.0.0`.
 * Marcel thinks: if I'm doing a *major* release the next one will be `6.0.0`. 
 * Marcel manually changes the versions on these files:
   * [version.rb](https://github.com/messagebird/ruby-rest-api/blob/master/lib/messagebird/version.rb#L5)
   * Gemfile.lock (not on git. not sure if it's important but :shrug: )
* Commit. Push to the `new-release` branch.
* Back to that release PR. Marcel writes a nice body on the PR. It's important to do a markdon title with `##`  somewhere. Everything after that double pound will be put on the body of the release. 
* Put the changelog in there, man. 
* Check (this PR)[https://github.com/messagebird/ruby-rest-api/pull/95] out for an example. 
* Be sure that the CI is not faling at anything. 
* Goto ruby gems
* Login using the (messagebird account)[https://rubygems.org/profiles/messagebird]. If you don't have access to it ask Jeremy, Marcel, Rene or Bob. 
* Goto (settings)[https://rubygems.org/settings/edit] 
* Change the MFA level to "UI and gem signin".
* Merge that PR
* Check that 
  * a new release got (published on github)[https://github.com/messagebird/ruby-rest-api/releases]
  * that a new release got push to the (rubygems page)[https://rubygems.org/gems/messagebird-rest]
* Great success
* Let's revert that dangerous config on rubygems
* Goto (settings)[https://rubygems.org/settings/edit] 
* Change the MFA level to "UI and API (Recommended)".
* Greatest success