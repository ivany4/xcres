# <center>![xcres](/../assets/xcres_banner.png?raw=true)</center>

[![Twitter: @mrackwitz](https://img.shields.io/badge/contact-@mrackwitz-blue.svg?style=flat)](https://twitter.com/mrackwitz)
[![Gem](https://img.shields.io/gem/v/xcres.svg?style=flat)](http://rubygems.org/gems/xcres)
[![Build Status](https://img.shields.io/travis/mrackwitz/xcres/master.svg?style=flat)](https://travis-ci.org/mrackwitz/xcres)
[![Code Climate](https://img.shields.io/codeclimate/github/mrackwitz/xcres.svg?style=flat)](https://codeclimate.com/github/mrackwitz/xcres)
[![Inline Docs](http://inch-ci.org/github/mrackwitz/xcres.svg?branch=master&style=flat)](http://inch-ci.org/github/mrackwitz/xcres)

`xcres` searches your Xcode project for resources and generates an index
as struct constants. So you will never have to reference a resource, without
knowing already at compile time if it exists or not.

It includes **images**, **sounds**, **.xibs**, **.storyboards**, **.bundles**, **asset catalogs** (.xcasset), **fonts**, and even **.strings** in the index.

It gives you **code autocompletion** for resources, localized string keys and interface builder reuse identifiers,
without the need of an Xcode plugin.

Especially if your app is a bit more complex, this will greatly improve your
workflow. It ensures a better quality and gives you more safety.
You will see directly when a resource is missing, when you renamed it,
or you moved it around.

Furthermore, it won't even bother you for trivial name changes like change
capitalization or converting name scheme from *train-case* or *snake_case* to
*camelCase* and vice versa.

It will warn you in Xcode on build, if certain resources or string keys can't be
references, because their name contain invalid chars, duplicates in the
*camelCase* variant with another key, or would be equal to a protected compiler
keyword.

The generated index could look like below.

While this is still **Objective-C**, `xcres` is compatible with **Swift**.
All you need to do is to add an import to the generated header to your
project's bridging header.

```objc
FOUNDATION_EXTERN const struct R {
	struct Fonts {
		/// MyFont.ttf
		__unsafe_unretained NSString *myFont;
	} Fonts;
    struct Images {
        /// doge.jpeg
        __unsafe_unretained NSString *doge;
    } Images;
    struct MediaAssets {
        struct MediaAssetsImages {
            /// AppIcon
            __unsafe_unretained NSString *app;
            /// LaunchImage
            __unsafe_unretained NSString *launch;
            /// DefaultAvatar
            __unsafe_unretained NSString *defaultAvatar;
        } Images;
        struct MediaAssetsData {
            /// CustomDataSet
            __unsafe_unretained NSString *customDataSet;
        } Data;
    } MediaAssets;
    struct Nibs {
        /// MyView
        __unsafe_unretained NSString *myView;
    } Nibs;
    struct ReuseIdenrifiers {
        struct ReuseIdentifiersMyView {
            /// DefaultCell
            __unsafe_unretained NSString *defaultCell;
        } MyView;
    } ReuseIdentifiers;
    struct Storyboards {
        /// Launch
        __unsafe_unretained NSString *launch;
    } Storyboards; 
    struct Strings {
        /// Password wrong!
        __unsafe_unretained NSString *errorTitleWrongPassword;
        /// Please enter the correct password.
        __unsafe_unretained NSString *errorMessageWrongPassword;
    } Strings;
    struct Sounds {
        /// bell.caf
        __unsafe_unretained NSString *bell;
    } Sounds;
  }
} R;
```


## Installation

`xcres` is built with Ruby and it will be installable with the default
Ruby available on OS X. You can use a Ruby Version manager, if you know
what you're doing.
Using the default Ruby install will require you to use sudo when
installing gems. (This is only an issue for the duration of the gem
installation, though.)

Install the gem on your machine:

```bash
$ [sudo] gem install xcres
```

Use the automatic integration to add a build phase to your project,
by executing the following command:

```bash
$ xcres install
```


## Usage

Reference your resources safely with the generated constants.

### Asset Catalogs

Assuming your asset catalog is named `Images.xcassets`.  
`xcres` supports multiple bundles in one project.

Instead of:

```objc
[UIImage imageNamed:@"PersonDefaultAvatar"]
```

Just write:

```objc
[UIImage imageNamed:R.MediaAssets.Images.personDefaultAvatar]
```

##### How to Add a New Resource

1. Add it to your asset catalog.
- Trigger a build. (**⌘ + B**)
- The new key will be available under
  `R.${catalogName}Assets.${keyName:camelCase}`
  and is ready for use in your code now.

### Bundles

Assuming your bundle is named `Stuff.bundle`.  
`xcres` supports multiple bundles in one project.

Instead of:

```objc
[UIImage imageNamed:@"Stuff.bundle/PersonDefaultAvatar"]
```

Just write:

```objc
[UIImage imageNamed:R.Stuff.Images.personDefaultAvatar]
```

##### How to Add a New Resource

1. Add it to your asset catalog.
- Trigger a build. (**⌘ + B**)
- The new key will be available under
  `R.${catalogName}Assets.${keyName:camelCase}`
  and is ready for use in your code now.


### Loose Images

Instead of:

```objc
[UIImage imageNamed:@"table_header_background_image"]
```

Just write:

```objc
[UIImage imageNamed:R.Images.tableHeaderBackgroundImage]
```

##### How to Add a New Loose Image

1. Drop the image in your project.
- Trigger a build. (**⌘ + B**)
- The new key will be available under `R.Images.${keyName:camelCase}`
  and is ready for use in your code now.


### Strings

Instead of:

```objc
NSLocalizedString(@"error_message_wrong_password", @"Message shown if a wrong password was entered.")
```

Just write:

```objc
NSLocalizedString(R.Strings.errorMessageWrongPassword, @"Message shown if a wrong password was entered.")
```

### Fonts

Instead of:

```objc
[UIFont fontWithName:@"Helvetica" size:15]
```

Just write:

```objc
[UIFont fontWithName:R.Fonts.helvetica size:15]
```


##### How to Add a New String

With xcres your workflow for adding new strings will change slightly.

1. Create a new string (at least) in your project's native development
  language in one of the strings files included in your target.
  (By default this will be `en.lproj/Localizable.strings`)
- Trigger a build. (**⌘ + B**)
- The new key will be available under `R.Strings.${keyName:camelCase}`
  and is ready for use in your code now.


## Known Issues & Tips

One minor drawback is that `genstrings` will not be helpful anymore.
But this tool is mostly useful in the first step, when bootstrapping
your project, until you care about internationalization and want to
provide translations.

xcres generally assumes that you don't use natural language for keys,
as this will led very fast to ambiguities. It will filter out unwanted
chars when transforming your keys to camel case notation, but it will
also warn you about those. It can be a help, if you want to migrate
your project to non-natural language keys.


## Credits

The logo was designed by [@kuchengnom](https://github.com/kuchengnom).


## License

xcres is available under MIT License.
See the LICENSE file for more info.
