class Magical.Models.Post extends Backbone.Model
  paramRoot: 'post'

  defaults:
    title: null
    content: null

class Magical.Collections.PostsCollection extends Backbone.Collection
  model: Magical.Models.Post
  url: '/posts'
