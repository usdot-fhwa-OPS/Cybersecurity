# Cybersecurity ITS App

The Field Device Security Configuration Tool prototype will provide the ITS Vendor community with a reference design and example implementation of a mobile application and backend cloud service that can be used to guide ITS vendor customers in the secure configuration of ITS equipment. ITS vendors will be able to use the prototype to design their own custom versions of the mobile application and offer the application to their customer base.

Vendor-specific Field Device Security Configuration Tools will be used by ITS Technicians as an aid, providing them with the equipment vendor’s recommended security configuration details for the specific equipment type, connection type and intended use. The Field Device Security Configuration Tool is a mobile application that an ITS Technician can install on either an Android or iPhone device.

## Getting Started

**Step 1:**

Download or clone this repo by using the link below:

```
https://github.com/usdot-fhwa-OPS/Cybersecurity-ITS-App.git
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```


**Step 3:**

Execute the following command in console to run the project on a connected physical device.

```
flutter run
```
## Features:

* Splash
* Login
* Home
* Routing

### Libraries & Tools Used

* [go_router](https://github.com/flutter/packages/tree/main/packages/go_router)

### Folder Structure
Here is the core folder structure which flutter provides.

```
flutter-app/
|- android
|- build
|- ios
|- lib
|- test
```

Here is the folder structure we have been using in this project

```
lib/
|- models/
|- utils/
|- views/
|- widgets/
|- main.dart
```

Now, lets dive into the lib folder which has the main code for the application.

```
1- models - Contains the data layer of your project.
2- utils — Contains the utilities/common functions of your application.
3- views — Contains all the ui of your project, contains sub directory for each screen.
4- widgets — Contains the common widgets for your applications. For example, Button, TextField, BottomNavBar etc.
5- main.dart - This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.
```

### Models

All the business logic of your application will go into this directory, it represents the data layer of your application.

### Utils

Contains the common file(s) and utilities used in a project.

### Views

This directory contains all the ui of your application. Each screen is located in a separate folder making it easy to combine group of files related to that particular screen. All the screen specific widgets will be placed in `widgets` directory as shown in the example below:

```
ui/
|- login
   |- login_screen.dart
   |- widgets
      |- login_form.dart
      |- login_button.dart
```

### Widgets

Contains the common widgets that are shared across multiple screens. For example, Button, TextField etc.

```
widgets/
|- bottom_nav_bar.dart
```

### Main

This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.

```dart
import 'package:flutter/material.dart';
import 'package:cybersecurity_its_app/utils/router_configuration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
    );
  }
}

```

## Related Repositories:
 - [Cybersecurity-ITS-Frontend](https://github.com/usdot-fhwa-OPS/Cybersecurity-ITS-Frontend): The cloud-hosted user interface for Vendor users to upload and manage device configuration recommendations.
 - [ITS-Cybersecurity-ITS-Backend](https://github.com/usdot-fhwa-OPS/Cybersecurity-ITS-Backend): The backend cloud services to connect technician and vendor users.
