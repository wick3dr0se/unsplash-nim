import os, asyncdispatch
import ./unsplash

let apiKey = getEnv("UNSPLASH_KEY")

var api = newUnsplashClient(apiKey)

# get link to photo specified by id
#[
et photo = waitFor api.photoById("random_id123")

echo photo.link
]#

# ---

# output links from editoral page
#[
let photos = waitFor api.listPhotos()

for p in photos:
    echo(p.link)
]#

# ----

# output link(s) to random photo(s) based on querie(s)
let photos = waitFor api.randomPhoto(@["car", "red"], 3)

for p in photos:
    echo(p.link)