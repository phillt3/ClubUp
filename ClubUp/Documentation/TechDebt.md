# TechDebt

This is a list of items that are currently implemented and functional but in unconventional or inefficient ways, necessitating improvement

## UserPreferences (Improved)

- Currently the userprefs utilize swift data which makes it very easy for persistence of the data, however retrieving that data requires querying a list of userprefs even though there will only ever be one. Also to check the preferences to determine on screen functionality, I am currently passing the userpref object to that page. I would rather this be something that can be accessed globally.
- Where the UserPref flags are checked to determine what UI to display, those if conditions can be condensed, streamlining exactly what is affected by the flag

## Recommended Clubs (Optimized)

Currently the calculation of which rec clubs to display, or if the section is displayed at all relies on series of loops, some nested, and some arbitrary, going through the same sets of data. Currently there is no noticeable impact on performance but this can certainly be cleaned up 

## Enum Formatting (Not Necessary)

- A small item but some enum definitions are lowercased, its a better practice to differentiate these from the rest of the code by capitalizing them.

## Update the UI (Complete)

- The design and color scheme of the UI can be improved

## MVVM Principle (Implemented)

- Although Swift Data allows for the inherit functionality of MVVM, not all of my work relies on Swift Data, it would be a good idea to implement ViewModels where they make sense

## In the detail page, when editing distance, it would be prefereable that upon the edit of one unit distance the other is automatically updated (Implemented)

## Outsource All Phrases to its own class? (Implemented and added Spanish translation)

##Ensure all views have properties that only relate to UI otherwise might be worth adding a viewmodel for them (Implemented)

##Add proper comments throughout (Complete)

##Will have to attribute background photo - https://wallpapers.com/iphone-x-golf-course-background#google_vignette

