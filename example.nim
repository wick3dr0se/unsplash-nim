import asyncdispatch
import ./unsplash

var api = newUnsplashClient()

#[
  without saveImage, the following procedures will return string content of the image
  extension is automatically determined and saveImage will append it to filename
]#

# save a random image based on queries to <random>.EXT
saveImage(waitFor api.randomImage(queries = @["grass", "sky"]), "random")

# save a daily image to <daily_image>.EXT
saveImage(waitFor api.dailyImage(), "daily_image")

# save a random image from specified category to <category_image>.EXT
saveImage(waitFor api.randomCategoryImage("cars"), "category_image")

# save a custom image from a request to unsplash url directly to <custom>.EXIT
saveImage(waitFor api.unsplashRequest("random?clouds,dark"), "custom")