DeepNavigator
============

![Swift](https://img.shields.io/badge/Swift-2.1-orange.svg)
[![Build Status](https://travis-ci.org/wejhink/DeepNavigator.svg)](https://travis-ci.org/wejhink/DeepNavigator)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

DeepNavigator provides an elegant way to navigate through view controllers by URLs. URL patterns can be mapped by using `DeepNavigator.map(_:_:)` function.

DeepNavigator can be used for mapping URL patterns with 2 kind of types: `DeepNavigable` and `URLOpenHandler`. `DeepNavigable` is a type which defines an custom initializer and `URLOpenHandler` is a closure which can be executed. Both an initializer and a closure receive an URL and placeholder values.


At a Glance
-----------

#### Mapping URL Patterns

URL patterns can contain placeholders. Placeholders will be replaced with matching values from URLs. Use `<` and `>` to make placeholders. Placeholders can have types: `string`(default), `int`, `float`, and `path`.

Here's an example of mapping URL patterns with view controllers and a closure. View controllers should conform a protocol `DeepNavigable` to be mapped with URL patterns. See [Implementing DeepNavigable](#implementing-DeepNavigable) section for details.

```swift
Navigator.map("myapp://user/<int:id>", UserViewController.self)
Navigator.map("myapp://post/<title>", PostViewController.self)

Navigator.map("myapp://alert") { URL, values in
    print(URL.queryParameters["title"])
    print(URL.queryParameters["message"])
    return true
}
```

> **Note**: Global constant `Navigator` is a shortcut for `DeepNavigator.defaultNavigator()`.

#### Pushing, Presenting and Opening URLs

DeepNavigator can push and present view controllers and execute closures with URLs.

Provide the `from` parameter to `pushURL()` to specify the navigation controller which the new view controller will be pushed. Similarly, provide the `from` parameter to `presentURL()` to specify the view controller which the new view controller will be presented. If the `nil` is passed, which is a default value, current application's top most view controller will be used to push or present view controllers.

`presentURL()` takes an extra parameter: `wrap`. If `true` is specified, the new view controller will be wrapped with a `UINavigationController`. Default value is `false`.

```swift
Navigator.pushURL("myapp://user/123")
Navigator.presentURL("myapp://post/54321", wrap: true)

Navigator.openURL("myapp://alert?title=Hello&message=World")
```

For full documentation, see [DeepNavigator Class Reference](http://cocoadocs.org/docsets/DeepNavigator/0.6.0/Classes/DeepNavigator.html).

#### Implementing DeepNavigable

View controllers should conform a protocol `DeepNavigable` to be mapped with URLs. A protocol `DeepNavigable` defines an failable initializer with parameter: `URL` and `values`.

Parameter `URL` is an URL that is passed from `DeepNavigator.pushURL()` and `DeepNavigator.presentURL()`. Parameter `values` is a dictionary that contains URL placeholder keys and values.

```swift
final class UserViewController: UIViewController, DeepNavigable {

    init(userID: Int) {
        super.init(nibName: nil, bundle: nil)
        // Initialize here...
    }

    convenience init?(URL: DeepConvertible, values: [String : AnyObject]) {
        // Let's assume that the user id is required
        guard let userID = values["id"] as? Int else {
            return nil
        }
        self.init(userID: userID)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
```

> **Note**: `DeepConvertible` is a protocol that `NSURL` and `String` conforms.


Installation
------------

- **For iOS 8+ projects** with [Carthage](https://github.com/Carthage/Carthage):

    ```
    github "wejhink/DeepNavigator" ~> 0.6
    ```

- **For iOS 7 projects** with [CocoaSeeds](https://github.com/wejhink/CocoaSeeds):

    ```ruby
    github 'wejhink/DeepNavigator', '0.6.0', :files => 'Sources/*.swift'
    ```

- **Using [Swift Package Manager](https://swift.org/package-manager)**:

    ```swift
    import PackageDescription

    let package = Package(
        name: "MyAwesomeApp",
        dependencies: [
            .Package(url: "https://github.com/wejhink/DeepNavigator", "0.6.0"),
        ]
    )
    ```


Example
-------

You can find an example app [here](https://github.com/wejhink/DeepNavigator/tree/master/Example).

1. Build and install the example app.
2. Open Safari app
3. Enter `navigator://user/wejhink` in the URL bar.
4. The example app will be launched.


Tips and Tricks
---------------

#### Where to Map URLs

I'd prefer using separated URL map file.

```swift
struct URLNavigationMap {

    static func initialize() {
        Navigator.map("myapp://user/<int:id>", UserViewController.self)
        Navigator.map("myapp://post/<title>", PostViewController.self)

        Navigator.map("myapp://alert") { URL, values in
            print(URL.parameters["title"])
            print(URL.parameters["message"])
            self.someUtilityMethod()
            return true
        }
    }

    private static func someUtilityMethod() {
        print("This method is really useful")
    }

}
```

Then call `initialize()` at `AppDelegate`'s `application:didFinishLaunchingWithOptions:`.

```swift
@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Navigator
        URLNavigationMap.initialize()

        // Do something else...
    }
}
```


#### Implementing AppDelegate Launch Option URL

It's available to open your app with URLs if custom schemes are registered. In order to navigate to view controllers with URLs, you'll have to implement `application:didFinishLaunchingWithOptions:` method.

```swift
func application(application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // ...

    if let URL = launchOptions?[UIApplicationLaunchOptionsURLKey] as? NSURL {
        self.window?.rootViewController = Navigator.viewControllerForURL(URL)
    }
    return true
}

```


#### Implementing AppDelegate Open URL Method

You'll might want to implement custom URL open handler. Here's an example of using DeepNavigator with other URL open handlers.

```swift
func application(application: UIApplication,
                 openURL url: NSURL,
                 sourceApplication: String?,
                 annotation: AnyObject) -> Bool {
    // If you're using Facebook SDK
    let fb = FBSDKApplicationDelegate.sharedInstance()
    if fb.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation) {
        return true
    }

    // DeepNavigator Handler
    if Navigator.openURL(url) {
        return true
    }

    // DeepNavigator View Controller
    if Navigator.presentURL(url, wrap: true) != nil {
        return true
    }

    return false
}
```


#### Using with Storyboard

It's not yet available to initialize view controllers from Storyboard. However, you can map the closures alternatively.

```swift
Navigator.map("myapp://post/<int:id>") { URL, values in
    guard let postID = values["id"] as? Int,
          let postViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
          else { return false }
    Navigator.push(postViewController)
    return true
}
```

Then use `Navigator.openURL()` instead of `Navigator.pushURL()`:

```swift
Navigator.openURL("myapp://post/12345")
```


#### Setting Default Scheme

Set `scheme` property on `DeepNavigator` instance to get rid of schemes in every URLs.

```swift
Navigator.scheme = "myapp"
Navigator.map("/user/<int:id>", UserViewController.self)
Navigator.push("/user/10")
```

This is totally equivalent to:

```swift
Navigator.map("myapp://user/<int:id>", UserViewController.self)
Navigator.push("myapp://user/10")
```

Setting `scheme` property will not affect other URLs that already have schemes.

```swift
Navigator.scheme = "myapp"
Navigator.map("/user/<int:id>", UserViewController.self) // `myapp://user/<int:id>`
Navigator.map("http://<path>", MyWebViewController.self) // `http://<path>`
```


License
-------

DeepNavigator is under MIT license. See the [LICENSE](LICENSE) file for more info.
