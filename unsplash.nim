import httpclient, asyncdispatch, strutils

type Image = object
  extension: string

const url = "https://source.unsplash.com/"

var img: Image

proc newUnsplashClient*(): AsyncHttpClient =
  return newAsyncHttpClient()

proc unsplashRequest(client: AsyncHttpClient, endpoint: string): Future[string] {.async.} =
  let
    response = await client.get(url & endpoint)
    headers = response.headers
    format = split(headers.getOrDefault("Content-Type"), "/")
  
  img.extension = format[0]

  return await response.body

proc saveImage*(content: string, filename: string, extension = img.extension) =
  if extension.startsWith("."):
    writeFile(filename & extension, content)
  else:
    writeFile(filename & "." & extension, content)

proc dailyImage*(client: AsyncHttpClient): Future[string] {.async.} =
  return await client.unsplashRequest("daily")

proc randomImage*(client: AsyncHttpClient, queries: seq[string] = @[]): Future[string] {.async.} =
  let query = queries.join(",")

  return await client.unsplashRequest("random?" & query)

proc randomCategoryImage*(client: AsyncHttpClient, category: string): Future[string] {.async.} =
  return await client.unsplashRequest("category/" & category)

proc randomSizeImage*(client: AsyncHttpClient, size = "800x600"): Future[string] {.async.} =
  return await client.unsplashRequest(size)