* sketch files are Zip archive
  * `__.sketch: Zip archive data, at least v2.0 to extract`

# File Structure

* document.json
* meta.json
* user.json
* **images/**
    * {MD5}.png
* **pages/**
    * {GUID}.json
* **previews/**
    * preview.png

# Pages / Artboards

In **meta.json**, it is defined in the `pagesAndArtboards` object.
In **document.json**, it is defined in the `pages` array.

EG/
```js
pagesAndArtboards: {
    // The GUID is the Page ID
    GUID: {
        name: "",
        artboards: {}
    }
}
```

# user.json

Potentially history?

# Document structure

Layers can recursively have layers (inside the `pages/{guid}.json` file);

```js
{
    // Root
    "layers": [
        {
            // Second layer
            "layers": [
                {
                    // Third layer
                    "layers": [
                        { /** etc **/ }
                    ]
                }
            ]
        }
    ]
}
```