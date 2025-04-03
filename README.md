# Automatic Image Renamer (Julia)
<b>This repository relies on non-free services hosted by Microsoft Corporation. Use at your own risk.</b>
Basic script to bulk rename images using the Microsoft Computer Vision API captioning model, transpiled into Julia from the [sanjujosh/auto-image-renamer](https://github.com/sanjujosh/auto-image-renamer/) project that was based on [/ParhamP/altify](https://github.com/ParhamP/altify). 

## Usage

#### Get a Microsoft API Key for Free (no, I had already sold out by using GitHub...)
Sign up [here](https://azure.microsoft.com/en-gb/products/cognitive-services/computer-vision/).

#### Add your API key in the file
In `renamer.jl`, add your API Key and endpoint.

#### Run script
```
julia renamer.jl path_to_images_dir
```

...see, I can write concise and usable instructions when I copy from somebody else.

## Uses

#### Direct use
This script can be used to conveniently organise large sets of images. For personal use only.

#### Out-of-scope use
This is not designed for captioning images for supervised machine learning or for any sensitive files.
