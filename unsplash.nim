import os, httpclient, asyncdispatch, json, strutils, strformat

let apiKey = getEnv("UNSPLASH_KEY")

const api = "https://api.unsplash.com/"

proc newUnsplashClient*(): AsyncHttpClient =
  return newAsyncHttpClient(
    headers = newHttpHeaders({
      "Accept-Version": "v1",
      "Authorization": "Client-ID " & apiKey
    })
  )

proc randomImage*(client: AsyncHttpClient, queries: seq[string] = @[], count = 1, format = "raw"): Future[seq[string]] {.async.} =
  var links: seq[string]

  let
    query = queries.join(",")
    url = api & fmt"photos/random?count={count}&query={query}"
    response = await client.getContent(url)
    jsonResponse = parseJson(response)

  for image in jsonResponse:
    links.add(image["urls"][format].getStr())

  return links