import asyncdispatch
import ./unsplash

var api = newUnsplashClient()

# get link to photo specified by id
#echo waitFor api.photoById("random_id123")

# output links from editoral page
#echo waitFor api.listPhotos()

# output link(s) to random photo(s) based on querie(s)
echo waitFor api.randomPhoto(@["car"], count = 2)