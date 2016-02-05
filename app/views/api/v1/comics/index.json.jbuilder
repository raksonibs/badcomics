json.meta do
  json.comicsCount @comics.count
end
json.comics @comics do |image|
  json.ruby_id image.id
  json.title  image.title
  json.comic_url image.comic.url
  json.created_at image.created_at
  json.updated_at image.updated_at
end