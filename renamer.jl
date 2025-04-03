using HTTP
using JSON
using FileIO

# Change here
MICROSOFT_VISION_API_KEY = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
MICROSOFT_VISION_API_ENDPOINT = "eastus.api.cognitive.microsoft.com"

ALLOWED_IMAGE_EXTENSIONS = [".jpeg", ".jpg", ".png"]

function is_exists(path)
    if isfile(path)
        return true
    else
        println("Could not find the given file - ", path)
        return false
    end
end

function get_all_images(directory)
    if isdir(directory)
        files = readdir(directory)
        images = filter(f -> any(ext -> endswith(lowercase(f), lowercase(ext)), ALLOWED_IMAGE_EXTENSIONS), files)
        return images
    else
        println("Could not find the given directory - ", directory)
        return []
    end
end

function get_extension(file)
    _, ext = splitext(file)
    return ext
end

function rename_img(old_path, new_name, base_dir)
    if is_exists(old_path)
        ext = get_extension(old_path)
        new_path = joinpath(base_dir, new_name * ext)
        mv(old_path, new_path)
        println("Renaming ", old_path, " to ", new_path)
    end
end

function get_caption(image_file)
    headers = [
        "Content-Type" => "application/octet-stream",
        "Ocp-Apim-Subscription-Key" => MICROSOFT_VISION_API_KEY,
    ]

    params = Dict(
        "maxCandidates" => "1",
        "language" => "en",
        "model-version" => "latest",
    )

    query_string = "?" * HTTP.escapeuri(params)

    try
        data = read(image_file)
        response = HTTP.request("POST", "https://$MICROSOFT_VISION_API_ENDPOINT/vision/v3.2/describe$query_string", headers, data)
        json_data = JSON.parse(String(response.body))
        caption_text = json_data["description"]["captions"][1]["text"]
        return caption_text
    catch e
        println("Exception while communicating with vision api - ", e)
    end
end

function full_path(base, file)
    return joinpath(base, file)
end

function init(directory)
    images = get_all_images(directory)
    for image in images
        file_path = full_path(directory, image)
        println("Processing image - ", image)
        new_name = get_caption(file_path)
        if new_name !== nothing
            rename_img(file_path, new_name, directory)
        end
    end
end

function main()
    if length(ARGS) != 1
        println("Usage: julia script.jl <absolute_path_of_image_directory>")
        return
    end

    directory = ARGS[1]
    try
        init(directory)
    catch e
        println("Try again - ", e)
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end