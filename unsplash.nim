import httpclient, asyncdispatch, json, strutils

const api = "https://api.unsplash.com/"

proc newUnsplashClient*(apiKey: string): AsyncHttpClient =
  return newAsyncHttpClient(
    headers = newHttpHeaders({
      "Accept-Version": "v1",
      "Authorization": "Client-ID " & apiKey
    })
  )

proc unsplashGET(client: AsyncHttpClient, endpoint: string): Future[JsonNode] {.async.} =
  let
    url = api & endpoint
    response = await client.getContent(url)
    jsonResponse = parseJson(response)

  return jsonResponse

proc photoById*(client: AsyncHttpClient, id: string, format = "raw"): Future[string] {.async.} =
  let photo = await client.unsplashGET("photos/:" & id)

  return photo["urls"][format].getStr()

proc listPhotos*(client: AsyncHttpClient, format = "raw"): Future[seq[string]] {.async.} =
  var links: seq[string]
  let photos = await client.unsplashGET("photos")

  for photo in photos:
    links.add(photo["urls"][format].getStr())

  return links


proc randomPhoto*(client: AsyncHttpClient, queries: seq[string] = @[], count = 1, format = "raw"): Future[seq[string]] {.async.} =
  var links: seq[string]
  let
    count = "?count=" & $count
    query = "&query=" & queries.join(",")
    photos = await client.unsplashGET("photos/random" & count & query)

  for photo in photos:
    links.add(photo["urls"][format].getStr())

  return links