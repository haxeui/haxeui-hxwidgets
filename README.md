![build status](https://github.com/haxeui/haxeui-hxwidgets/actions/workflows/build-linux.yml/badge.svg)
![build status](https://github.com/haxeui/haxeui-hxwidgets/actions/workflows/build-osx.yml/badge.svg)
![build status](https://github.com/haxeui/haxeui-hxwidgets/actions/workflows/build-windows.yml/badge.svg)

# haxeui-hxwidgets
`haxeui-hxwidgets` is the `wxWidgets` backend for HaxeUI.

<p align="center">
	<img src="https://github.com/haxeui/haxeui-hxwidgets/raw/master/.github/images/screen.png" />
</p>

## Installation
 * `haxeui-hxwidgets` requires **at least Haxe 3.4.0**.
 * `haxeui-hxwidgets` has a dependency to <a href="https://github.com/haxeui/haxeui-core">`haxeui-core`</a>, and so that too must be installed.
 * `haxeui-hxwidgets` also has a dependency to <a href="https://github.com/haxeui/hxWidgets">hxWidgets</a> (the `wxWidgets` Haxe externs), please refer to the installation instructions on their <a href="https://github.com/haxeui/hxWidgets">site</a>.
 * You will also need a copy of the `wxWidgets` libraries which can be obtained <a href="https://www.wxwidgets.org/downloads">here</a>. The easiest way to install and setup the libraries is to follow the instructions <a href="https://github.com/haxeui/hxWidgets#hxwidgets">here</a>.

Installation of the haxeui can be performed by using haxelib, you will need a the haxeui-core haxelib as well as the haxeui-hxwidgets backend: 
```
haxelib install haxeui-core
haxelib install haxeui-hxwidgets
```

## Usage
The simplest method to create a new `hxWidgets` application that is HaxeUI ready is to use the CLI to create a skeleton project:

`haxelib run haxeui-core create hxwidgets`

If however you already have an existing application, then incorporating HaxeUI into that application is straightforward:

### haxelibs
As well as the `haxeui-core` and `haxeui-hxwidgets` haxelibs, you must also include (in either the IDE or your `.hxml`) the haxelib `hxWidgets`.

### Toolkit initialisation and usage
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

## hxWidgets specifics

Components in `haxeui-hxwidgets` expose a special `window` property that allows you to access the `hxWidgets` `Window`, this could then be used in other UIs that arent using HaxeUI components. 

### Initialisation options
The configuration options that may be passed to `Tookit.init()` are as follows:

```haxe
Toolkit.init({
	frame: frame      // the frame on which 'Screen' will place components
});
```


## Addtional resources
* <a href="http://haxeui.org/explorer/">component-explorer</a> - Browse HaxeUI components
* <a href="http://haxeui.org/builder/">playground</a> - Write and test HaxeUI layouts in your browser
* <a href="https://github.com/haxeui/component-examples">component-examples</a> - Various componet examples
* <a href="http://haxeui.org/api/haxe/ui/">haxeui-api</a> - The HaxeUI api docs.
* <a href="https://github.com/haxeui/haxeui-guides">haxeui-guides</a> - Set of guides to working with HaxeUI and backends.
