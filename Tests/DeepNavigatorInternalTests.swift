// The MIT License (MIT)
//
// Copyright (c) 2016 Jhink Solutions (jhink.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import XCTest
@testable import DeepNavigator

class DeepNavigatorInternalTests: XCTestCase {

    func testMatchURL() {
        {
            XCTAssertNil(DeepNavigator.matchURL("myapp://user/1", from: []))
        }();
        {
            XCTAssertNil(DeepNavigator.matchURL("myapp://user/1", from: ["myapp://comment/<id>"]))
        }();
        {
            XCTAssertNil(DeepNavigator.matchURL("myapp://user/1", from: ["myapp://user/<id>/hello"]))
        }();
        {
            XCTAssertNil(DeepNavigator.matchURL("/user/1", scheme: "myapp", from: []))
        }();
        {
            XCTAssertNil(DeepNavigator.matchURL("/user/1", scheme: "myapp", from: ["myapp://comment/<id>"]))
        }();
        {
            XCTAssertNil(DeepNavigator.matchURL("/user/1", scheme: "myapp", from: ["myapp://user/<id>/hello"]))
        }();
        {
            XCTAssertNil(DeepNavigator.matchURL("myapp://user/1", scheme: "myapp", from: []))
        }();
        {
            XCTAssertNil(DeepNavigator.matchURL("myapp://user/1", scheme: "myapp", from: ["myapp://comment/<id>"]))
        }();
        {
            XCTAssertNil(DeepNavigator.matchURL("myapp://user/1", scheme: "myapp", from: ["myapp://user/<id>/hello"]))
        }();
        {
            let from = ["myapp://hello"]
            let (URLPattern, values) = DeepNavigator.matchURL("myapp://hello", from: from)!
            XCTAssertEqual(URLPattern, "myapp://hello")
            XCTAssertEqual(values.count, 0)

            let scheme = DeepNavigator.matchURL("/hello", scheme: "myapp", from: from)!
            XCTAssertEqual(URLPattern, scheme.0)
            XCTAssertEqual(values as! [String: String], scheme.1 as! [String: String])
        }();
        {
            let from = ["myapp://user/<id>"]
            let (URLPattern, values) = DeepNavigator.matchURL("myapp://user/1", from: from)!
            XCTAssertEqual(URLPattern, "myapp://user/<id>")
            XCTAssertEqual(values as! [String: String], ["id": "1"])

            let scheme = DeepNavigator.matchURL("/user/1", scheme: "myapp", from: from)!
            XCTAssertEqual(URLPattern, scheme.0)
            XCTAssertEqual(values as! [String: String], scheme.1 as! [String: String])
        }();
        {
            let from = ["myapp://user/<id>", "myapp://user/<id>/hello"]
            let (URLPattern, values) = DeepNavigator.matchURL("myapp://user/1", from: from)!
            XCTAssertEqual(URLPattern, "myapp://user/<id>")
            XCTAssertEqual(values as! [String: String], ["id": "1"])

            let scheme = DeepNavigator.matchURL("/user/1", scheme: "myapp", from: from)!
            XCTAssertEqual(URLPattern, scheme.0)
            XCTAssertEqual(values as! [String: String], scheme.1 as! [String: String])
        }();
        {
            let from = ["myapp://user/<id>", "myapp://user/<id>/<object>"]
            let (URLPattern, values) = DeepNavigator.matchURL("myapp://user/1/posts", from: from)!
            XCTAssertEqual(URLPattern, "myapp://user/<id>/<object>")
            XCTAssertEqual(values as! [String: String], ["id": "1", "object": "posts"])

            let scheme = DeepNavigator.matchURL("/user/1/posts", scheme: "myapp", from: from)!
            XCTAssertEqual(URLPattern, scheme.0)
            XCTAssertEqual(values as! [String: String], scheme.1 as! [String: String])
        }();
        {
            let from = ["myapp://alert"]
            let (URLPattern, values) = DeepNavigator.matchURL("myapp://alert?title=hello&message=world", from: from)!
            XCTAssertEqual(URLPattern, "myapp://alert")
            XCTAssertEqual(values.count, 0)

            let scheme = DeepNavigator.matchURL("/alert?title=hello&message=world", scheme: "myapp", from: from)!
            XCTAssertEqual(URLPattern, scheme.0)
            XCTAssertEqual(values as! [String: String], scheme.1 as! [String: String])
        }();
        {
            let from = ["http://<path:url>"]
            let (URLPattern, values) = DeepNavigator.matchURL("http://jhink.com", from: from)!
            XCTAssertEqual(URLPattern, "http://<path:url>")
            XCTAssertEqual(values as! [String: String], ["url": "jhink.com"])

            let scheme = DeepNavigator.matchURL("http://jhink.com", scheme: "myapp", from: from)!
            XCTAssertEqual(URLPattern, scheme.0)
            XCTAssertEqual(values as! [String: String], scheme.1 as! [String: String])
        }();
        {
            let from = ["http://<path:url>"]
            let (URLPattern, values) = DeepNavigator.matchURL("http://jhink.com/contact", from: from)!
            XCTAssertEqual(URLPattern, "http://<path:url>")
            XCTAssertEqual(values as! [String: String], ["url": "jhink.com/contact"])

            let scheme = DeepNavigator.matchURL("http://jhink.com/contact", scheme: "myapp", from: from)!
            XCTAssertEqual(URLPattern, scheme.0)
            XCTAssertEqual(values as! [String: String], scheme.1 as! [String: String])
        }();
        {
            let from = ["http://<path:url>"]
            let (URLPattern, values) = DeepNavigator.matchURL("http://google.com/search?q=DeepNavigator", from: from)!
            XCTAssertEqual(URLPattern, "http://<path:url>")
            XCTAssertEqual(values as! [String: String], ["url": "google.com/search"])

            let scheme = DeepNavigator.matchURL("http://google.com/search?q=DeepNavigator", scheme: "myapp", from: from)!
            XCTAssertEqual(URLPattern, scheme.0)
            XCTAssertEqual(values as! [String: String], scheme.1 as! [String: String])
        }();
        {
            let from = ["http://<path:url>"]
            let (URLPattern, values) = DeepNavigator.matchURL("http://google.com/search/?q=DeepNavigator", from: from)!
            XCTAssertEqual(URLPattern, "http://<path:url>")
            XCTAssertEqual(values as! [String: String], ["url": "google.com/search"])

            let scheme = DeepNavigator.matchURL("http://google.com/search/?q=DeepNavigator",
                                               scheme: "myapp", from: from)!
            XCTAssertEqual(URLPattern, scheme.0)
            XCTAssertEqual(values as! [String: String], scheme.1 as! [String: String])
        }();
    }

    func testURLWithScheme() {
        XCTAssertEqual(DeepNavigator.URLWithScheme(nil, "myapp://user/1").URLStringValue, "myapp://user/1")
        XCTAssertEqual(DeepNavigator.URLWithScheme("myapp", "/user/1").URLStringValue, "myapp://user/1")
        XCTAssertEqual(DeepNavigator.URLWithScheme("", "/user/1").URLStringValue, "://user/1") // idiot
    }

    func testNormalizedURL() {
        XCTAssertEqual(DeepNavigator.normalizedURL("myapp://user/<id>/hello").URLStringValue, "myapp://user/<id>/hello")
        XCTAssertEqual(DeepNavigator.normalizedURL("myapp:///////user///<id>//hello/??/#abc=/def").URLStringValue,
            "myapp://user/<id>/hello")
        XCTAssertEqual(DeepNavigator.normalizedURL("https://<path:_>").URLStringValue, "https://<path:_>")
    }

    func testPlaceholderValueFromURLPathComponents() {
        {
            let placeholder = DeepNavigator.placeholderKeyValueFromURLPatternPathComponent(
                "<id>",
                URLPathComponents: ["123", "456"],
                atIndex: 0
            )
            XCTAssertEqual(placeholder?.0, "id")
            XCTAssertEqual(placeholder?.1 as? String, "123")
        }();
        {
            let placeholder = DeepNavigator.placeholderKeyValueFromURLPatternPathComponent(
                "<int:id>",
                URLPathComponents: ["123", "456"],
                atIndex: 0
            )
            XCTAssertEqual(placeholder?.0, "id")
            XCTAssertEqual(placeholder?.1 as? Int, 123)
        }();
        {
            let placeholder = DeepNavigator.placeholderKeyValueFromURLPatternPathComponent(
                "<int:id>",
                URLPathComponents: ["abc", "456"],
                atIndex: 0
            )
            XCTAssertNil(placeholder)
        }();
        {
            let placeholder = DeepNavigator.placeholderKeyValueFromURLPatternPathComponent(
                "<float:height>",
                URLPathComponents: ["180", "456"],
                atIndex: 0
            )
            XCTAssertEqual(placeholder?.0, "height")
            XCTAssertEqual(placeholder?.1 as? Float, 180)
        }();
        {
            let placeholder = DeepNavigator.placeholderKeyValueFromURLPatternPathComponent(
                "<float:height>",
                URLPathComponents: ["abc", "456"],
                atIndex: 0
            )
            XCTAssertNil(placeholder)
        }();
        {
            let placeholder = DeepNavigator.placeholderKeyValueFromURLPatternPathComponent(
                "<url>",
                URLPathComponents: ["jhink.com"],
                atIndex: 0
            )
            XCTAssertEqual(placeholder?.0, "url")
            XCTAssertEqual(placeholder?.1 as? String, "jhink.com")
        }();
        {
            let placeholder = DeepNavigator.placeholderKeyValueFromURLPatternPathComponent(
                "<url>",
                URLPathComponents: ["jhink.com", "contact"],
                atIndex: 0
            )
            XCTAssertEqual(placeholder?.0, "url")
            XCTAssertEqual(placeholder?.1 as? String, "jhink.com")
        }();
        {
            let placeholder = DeepNavigator.placeholderKeyValueFromURLPatternPathComponent(
                "<path:url>",
                URLPathComponents: ["jhink.com"],
                atIndex: 0
            )
            XCTAssertEqual(placeholder?.0, "url")
            XCTAssertEqual(placeholder?.1 as? String, "jhink.com")
        }();
        {
            let placeholder = DeepNavigator.placeholderKeyValueFromURLPatternPathComponent(
                "<path:url>",
                URLPathComponents: ["jhink.com", "contact"],
                atIndex: 0
            )
            XCTAssertEqual(placeholder?.0, "url")
            XCTAssertEqual(placeholder?.1 as? String, "jhink.com/contact")
        }();
        {
            let placeholder = DeepNavigator.placeholderKeyValueFromURLPatternPathComponent(
                "<path:url>",
                URLPathComponents: ["google.com", "search?q=test"],
                atIndex: 0
            )
            XCTAssertEqual(placeholder?.0, "url")
            XCTAssertEqual(placeholder?.1 as? String, "google.com/search?q=test")
        }();
        {
            let placeholder = DeepNavigator.placeholderKeyValueFromURLPatternPathComponent(
                "<path:url>",
                URLPathComponents: ["google.com", "search", "?q=test"],
                atIndex: 0
            )
            XCTAssertEqual(placeholder?.0, "url")
            XCTAssertEqual(placeholder?.1 as? String, "google.com/search/?q=test")
        }();
    }

    func testReplaceRegex() {
        XCTAssertEqual(DeepNavigator.replaceRegex("a", "0", "abc"), "0bc")
        XCTAssertEqual(DeepNavigator.replaceRegex("\\d", "A", "1234567abc098"), "AAAAAAAabcAAA")
    }

}
