<p align="center">
  <img src="https://dl.dropboxusercontent.com/u/26678671/haxeui2-warning.png"/>
</p>

[![Build Status](https://travis-ci.org/haxeui/haxeui-hxwidgets.svg?branch=master)](https://travis-ci.org/haxeui/haxeui-hxwidgets)
[![Support this project on Patreon](https://dl.dropboxusercontent.com/u/26678671/patreon_button.png)](https://www.patreon.com/haxeui)
[![Code Climate](https://codeclimate.com/github/haxeui/hxWidgets/badges/gpa.svg)](https://codeclimate.com/github/haxeui/hxWidgets)
[![Issue Count](https://codeclimate.com/github/haxeui/hxWidgets/badges/issue_count.svg)](https://codeclimate.com/github/haxeui/hxWidgets)

<h2>haxeui-hxwidgets</h2>
`haxeui-hxwidgets` is the `wxWidgets` backend for HaxeUI.

<p align="center">
	<img src="https://github.com/haxeui/haxeui-hxwidgets/raw/master/screen.png" />
</p>

<h2>Installation</h2>
 * `haxeui-hxwidgets` has a dependency to <a href="https://github.com/haxeui/haxeui-core">`haxeui-core`</a>, and so that too must be installed.
 * `haxeui-hxwidgets` also has a dependency to <a href="https://github.com/haxeui/hxWidgets">hxWidgets</a> (the `wxWidgets` Haxe externs), please refer to the installation instructions on their <a href="https://github.com/haxeui/hxWidgets">site</a>.
 * You will also need a copy of the `wxWidgets` libraries which can be obtained <a href="https://www.wxwidgets.org/downloads">here</a>. The easiest way to install and setup the libraries is to follow the instructions <a href="https://github.com/haxeui/hxWidgets#hxwidgets">here</a>.

Eventually all these libs will become haxelibs, however, currently in their alpha form they do not even contain a `haxelib.json` file (for dependencies, etc) and therefore can only be used by downloading the source and using the `haxelib dev` command or by directly using the git versions using the `haxelib git` command (recommended). Eg:

```
haxelib git haxeui-core https://github.com/haxeui/haxeui-core
haxelib dev haxeui-hxwidgets path/to/expanded/source/archive
```

<h2>Usage</h2>
The simplest method to create a new `hxWidgets` application that is HaxeUI ready is to use one of the <a href="https://github.com/haxeui/haxeui-templates">haxeui-templates</a>. These templates will allow you to start a new project rapidly with HaxeUI support baked in. 

If however you already have an existing application, then incorporating HaxeUI into that application is straightforward:

<h3>haxelibs</h3>
As well as the `haxeui-core` and `haxeui-hxwidgets` haxelibs, you must also include (in either the IDE or your `.hxml`) the haxelib `hxWidgets`.

<h3>Toolkit initialisation and usage</h3>
The `hxWidgets` application itself must be initialised and an event loop started. This can be done by using code similar to:

```haxe
static function main() {
	var app = new App();
    app.init();
    
    var frame:Frame = new Frame(null, "My App");
    frame.resize(800, 600);

    frame.show();
    app.run();
    app.exit();
}
```

Initialising the toolkit requires you to add these lines somewhere _before_ you start to actually use HaxeUI in your application and _after_ the `hxWidgets` frame has been created:

```haxe
Toolkit.init({
	frame: frame      // the frame on which 'Screen' will place components
});
```

Once the toolkit is initialised you can add components using the methods specified <a href="https://github.com/haxeui/haxeui-core#adding-components-using-haxe-code">here</a>.

<h2>hxWidgets specifics</h2>

Components in `haxeui-hxwidgets` expose a special `window` property that allows you to access the `hxWidgets` `Window`, this could then be used in other UIs that arent using HaxeUI components. 

<h3>Initialisation options</h3>
The configuration options that may be passed to `Tookit.init()` are as follows:

```haxe
Toolkit.init({
	frame: frame      // the frame on which 'Screen' will place components
});
```


<h2>Addtional resources</h2>
* <a href="http://haxeui.github.io/haxeui-api/">haxeui-api</a> - The HaxeUI api docs.
* <a href="https://github.com/haxeui/haxeui-guides">haxeui-guides</a> - Set of guides to working with HaxeUI and backends.
* <a href="https://github.com/haxeui/haxeui-demo">haxeui-demo</a> - Demo application written using HaxeUI.
* <a href="https://github.com/haxeui/haxeui-templates">haxeui-templates</a> - Set of templates for IDE's to allow quick project creation.
* <a href="https://github.com/haxeui/haxeui-bdd">haxeui-bdd</a> - A behaviour driven development engine written specifically for HaxeUI (uses <a href="https://github.com/haxeui/haxe-bdd">haxe-bdd</a> which is a gherkin/cucumber inspired project).
* <a href="https://www.youtube.com/watch?v=L8J8qrR2VSg&feature=youtu.be">WWX2016 presentation</a> - A presentation given at WWX2016 regarding HaxeUI.

