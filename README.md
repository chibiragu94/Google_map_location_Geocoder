# flutter_app

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Google Map Integration support for Both Android and iOS

## Functions
* Integrating google Map
* Use GeoCoder for getting the address using the latitude and Longitude
* Get the current location using GeoLocator
* Handling Location Permission and Service's
* Googgle map plugin is not supported in the WEB 

* ## Enable Debug support for iOS simulator
Run this cmd
```
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

* ## Google Map API and Permissions
Get Google map API key from Google console and Enable for both Android and iOS

### Android :
```
 <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
 <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="AIzaSyB2QD086sRQpjqNio7iHb-000-yZJ-DgkU"/>
```

### iOS
```
GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyB2QD086sRQpjqNio7iHb-TMY-yZJ-DgkU")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)

Permission's
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location when open.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location when in the background.</string>

```

### Plugin used
```
# Google Map's
  google_maps_flutter: ^1.0.10

  # Location
  geolocator: ^6.1.13

  # GeoCoder
  geocoder: ^0.2.1

  # Taost
  fluttertoast: ^7.1.6
```