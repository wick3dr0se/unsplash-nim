import httpclient, asyncdispatch, json, strutils

type
  Photo = object
    link*: string
  Photos = seq[Photo]

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

proc photoById*(client: AsyncHttpClient, id: string, format = "raw"): Future[Photo] {.async.} =
  var photo: Photo

  let resp = await client.unsplashGET("photos/:" & id)

  photo.link = resp["urls"][format].getStr()

  return photo

proc listPhotos*(client: AsyncHttpClient, format = "raw"): Future[seq[Photo]] {.async.} =
  var photos: Photos

  let resp = await client.unsplashGET("photos")

  for r in resp:
    var photo: Photo
    photo.link = r["urls"][format].getStr()
    photos.add(photo)

  return photos

proc randomPhoto*(client: AsyncHttpClient, queries: seq[string] = @[], count = 1, format = "raw"): Future[seq[Photo]] {.async.} =
  var photos: Photos

  let
    count = "?count=" & $count
    query = "&query=" & queries.join(",")
    resp = await client.unsplashGET("photos/random" & count & query)

  for r in resp:
    var photo: Photo
    photo.link = r["urls"][format].getStr()
    photos.add(photo)

  return photos