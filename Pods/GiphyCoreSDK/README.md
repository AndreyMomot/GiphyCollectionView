# Giphy Core SDK for Swift


The **Giphy Core SDK** is a wrapper around [Giphy API](https://github.com/Giphy/GiphyAPI).

[![Build Status](https://travis-ci.com/Giphy/giphy-ios-sdk-core.svg?token=ApviWy5Ne8UKNzA4xUNJ&branch=master)](https://travis-ci.com/Giphy/giphy-ios-sdk-core)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/GiphyCoreSDK.svg)]()
[![](https://img.shields.io/badge/OS%20X-10.9%2B-lightgrey.svg)]()
[![](https://img.shields.io/badge/iOS-7.0%2B-lightgrey.svg)]()
[![Swift Version](https://img.shields.io/badge/Swift-3.2-orange.svg)]()




[Giphy](https://www.giphy.com) is the best way to search, share, and discover GIFs on the Internet. Similar to the way other search engines work, the majority of our content comes from indexing based on the best and most popular GIFs and search terms across the web. We organize all those GIFs so you can find the good content easier and share it out through your social channels. We also feature some of our favorite GIF artists and work with brands to create and promote their original GIF content.

[![](https://media.giphy.com/media/5xaOcLOqNmWHaLeB14I/giphy.gif)]()

# Getting Started

### Supported Platforms

* iOS
* macOS
* tvOS
* watchOS

### Supported End-points

* [Search GIFs/Stickers](#search-endpoint)
* [Trending GIFs/Stickers](#trending-endpoint)
* [Translate GIFs/Stickers](#translate-endpoint)
* [Random GIFs/Stickers](#random-endpoint)
* [GIF by ID](#get-gif-by-id-endpoint)
* [GIFs by IDs](#get-gifs-by-ids-endpoint)
* [Categories for GIFs](#categories-endpoint)
* [Subcategories for GIFs](#sub-categories-endpoint)
* [GIFs for a Subcategory](#sub-category-content-endpoint)
* [Term Suggestions](#term-suggestions-endpoint)


# Setup

### CocoaPods Setup

Add the GiphyCoreSDK entry to your Podfile

```
pod 'GiphyCoreSDK'
```

Run pods to grab the GiphyCoreSDK framework

```bash
pod install
```

### Initialize Giphy SDK

```swift
let client = GPHClient(apiKey: "YOUR_API_KEY")
```

### Search Endpoint
Search all Giphy GIFs for a word or phrase. Punctuation will be stripped and ignored. 

```swift
/// Gif Search
let op = client.search("cats") { (response, error) in

    if let error = error as NSError? {
        // Do what you want with the error
    }

    if let response = response, let data = response.data, let pagination = response.pagination {
        print(response.meta)
        print(pagination)
        for result in data {
            print(result)
        }
    } else {
        print("No Results Found")
    }
}

/// Sticker Search
let op = client.search("dogs", media: .sticker) { (response, error) in
    //...
}
```

### Trending Endpoint
Fetch GIFs currently trending online. Hand curated by the Giphy editorial team. The data returned mirrors the GIFs showcased on the [Giphy](https://www.giphy.com) homepage.

```swift
/// Trending GIFs
let op = client.trending() { (response, error) in
    //...
}

/// Trending Stickers
let op = client.trending(.sticker) { (response, error) in
    //...
}
```

### Translate Endpoint
The translate API draws on search, but uses the Giphy "special sauce" to handle translating from one vocabulary to another. In this case, words and phrases to GIFs. Example implementations of translate can be found in the Giphy Slack, Hipchat, Wire, or Dasher integrations. Use a plus or url encode for phrases.

```swift
/// Translate to a GIF
let op = client.translate("cats") { (response, error) in
    //...
}

/// Translate to a Sticker
let op = client.translate("cats", media: .sticker) { (response, error) in
    //...
}
```

### Random Endpoint
Returns a random GIF, limited by tag. Excluding the tag parameter will return a random GIF from the Giphy catalog.

```swift
/// Random GIF
let op = client.random("cats") { (response, error) in

    if let error = error as NSError? {
        // Do what you want with the error
    }

    if let response = response, let data = response.data  {
        print(response.meta)
        print(data)
    } else {
        print("No Result Found")
    }
}

/// Random Sticker
let op = client.random("cats", media: .sticker) { (response, error) in
    //...
}
```

### Get GIF by ID Endpoint
Returns meta data about a GIF, by GIF id. In the below example, the GIF ID is "feqkVgjJpYtjy"

```swift
/// Gif by Id
let op = client.gifByID("feqkVgjJpYtjy") { (response, error) in
    //...
}
```

### Get GIFs by IDs Endpoint
A multiget version of the get GIF by ID endpoint. In this case the IDs are feqkVgjJpYtjy and 7rzbxdu0ZEXLy.

```swift
/// GIFs by Ids
let ids = ["feqkVgjJpYtjy", "7rzbxdu0ZEXLy"]

let op = client.gifsByIDs(ids) { (response, error) in

    if let error = error as NSError? {
        // Do what you want with the error
    }

    if let response = response, let data = response.data, let pagination = response.pagination {
        print(response.meta)
        print(pagination)
        for result in data {
            print(result)
        }
    } else {
        print("No Result Found")
    }
}
```

### Categories Endpoint
A multiget version of the get GIF by ID endpoint. In this case the IDs are feqkVgjJpYtjy and 7rzbxdu0ZEXLy.

```swift
/// Get top trending categories for GIFs.
let op = client.categoriesForGifs() { (response, error) in

    if let error = error as NSError? {
        // Do what you want with the error
    }

    if let response = response, let data = response.data, let pagination = response.pagination {
        print(response.meta)
        print(pagination)
        for result in data {
            print(result)
        }
    } else {
        print("No Top Categories Found")
    }
}
```

### Sub-Categories Endpoint
Get Sub-Categories for GIFs given a cateory. You will need this sub-category object to pull GIFs for this category.

```swift
/// Sub-Categories for a given category.
let category = "actions"

let op = client.subCategoriesForGifs(category) { (response, error) in

    if let error = error as NSError? {
        // Do what you want with the error
    }

    if let response = response, let data = response.data, let pagination = response.pagination {
        print(response.meta)
        print(pagination)
        for subcategory in data {
            print(subcategory)
        }
    } else {
        print("No Result Found")
    }
}
```

### Sub-Category Content Endpoint
Get GIFs for a given Sub-Category. 

```swift
/// Sub-Category Content
let category = "actions"
let subCategory = "cooking"

let op = client.gifsByCategory(category, subCategory: subCategory) { (response, error) in

    if let error = error as NSError? {
        // Do what you want with the error
    }

    if let response = response, let data = response.data, let pagination = response.pagination {
        print(response.meta)
        print(pagination)
        for result in data {
            print(result)
        }
    } else {
        print("No GIFs Found")
    }
}
```


### Term Suggestions Endpoint
Get term suggestions give a search term, or a substring.

```swift
/// Term Suggestions
let op = client.termSuggestions("carm") { (response, error) in

    if let error = error as NSError? {
        // Do what you want with the error
    }

    if let response = response, let data = response.data {
        print(response.meta)
        for term in data {
            print(term)
        }
    } else {
        print("No Terms Suggestions Found")
    }
}
```

