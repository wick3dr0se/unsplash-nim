import asyncdispatch
import ./unsplash

var api = newUnsplashClient()

# output a link to a random image based on queries
echo waitFor api.randomImage(@["car"], count = 2)