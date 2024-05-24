# Notes

## Model()

- Attaching Model() macor to any model class makes it persistable and able to be utilized through SwiftData
- Converts a Swift class into a stored model that's managed by SwiftData

## Query ()

- Used to display models in a SwiftUI view.
- SwiftData performs the fetch when the view appears and tells SwiftUI about any subsequent changes to the fetched models so the view can be updated
- Fetches all instances of the attached model type

## struct Query

- A type that fetches models using the specified criteria, and manages those mdoels so they remain in sync with underlying data
- it will fetch all instances of the attached model type
- can fetch these instances with animations, filtered by critiera, and/or sorted
- has a strcut QUery that fetched models using specified criteria and manages those mdoels so they remain in sync with the underlying data
- has a struct FetchDescriptor which describes the crieria, sort order, and any additional configuration to use when performing a fetch

## ModelContainer

- An object that manages an app's schema and model storage configuration
- manages all aspects of storage and enusres it remains in a consistent and usable state
- By default a model container makes assumptions about how it configures an app's persistent storage. But this can be customized using ModelConfiguration
- An app that uses SwiftData requires at least one model container
- It's isStoredInMemoryONly property is a boolean value that determines whether the associated persistent storage is ephemeral and exists only in memory (ephemeral being lasting a short time)
- The above must refer to RAM as opposed to the storage of an SSD? Most likely want to set this to false for production

## ModelContext

- An object that enables you to fetch, insert, and delete models, and save any changes to disk
- you use a context to insert new models, track and persist changes to those models, and to delete those models when you no longer need them.
- A context understand;s the app's schema but doesn't know about any individual models until it is told to fetch some from persistent storage or required to populate new models.
- Any changes made to models exist only in memory until the context implicitly writes thme to persistent storage (or manually invoke save())

## Environment
- A property wrapper that reads a value from a view's environment
- If the value changes, SwiftUI updates any parts of the view that depend on the value
- In the case of ClubListView, it uses .\modelContext to get the path to the environment ModelContext object

## State
- Is a property wrapper type that can read and write a value manage by SwiftUI
- State acts as the single source of truth for a given value type that you store in a view hierarchy
- SwiftUI manages the property's storage, when the value changes, swiftUI updates the parts of the view hierarchy that depend on that value

## onDelete(perform:)
- SwiftUI passes a set of indicies to the closure that's relative to the dynamic view's underlying collection of data
- In my code this then calls delete items which loops through the set of inidices and deletes each one from the model context, this probably opens up the possibility to delete multiple items at a time so I can keep it for now, but can always be simplified to only delete the selected item

## Binding
- Use a binding to create a two-way connection between a property that stores data, and a view that displays and changes the data. 
- A binding connects a property to a source of truth stored elsewhere, instead of storing data directly. 
- For example, a button that toggles between play and pause can create a binding to a property of its parent view using the Binding property wrapper.

##CLLocationManager
- The central place to manage an app’s location-related behaviors. 
- Use a location-manager object to configure, start, and stop location services.
