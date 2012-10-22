# Public: Auto draft saving and markdown preview updating
#
# init - method which initializes the preview
# options - Options for the init method used to refine the selection (default: {}):
#             :postEditForm - The String color to restrict by (optional).
#             :updateURL - url for sending the update ajax request
#
# Returns the duplicated String.
Blog.AdminPostPreviewRender = ->
  init: (options)->
    this.postEditForm = options.postEditForm
    this.updateURL = options.updateURL
    this.preview = options.preview
    this
  start: ->
    this.updateProcessedOutput()
  updateProcessedOutput: ->
    setTimeout(this.updatePost(this), 3000);
  updatePost: (scope)->
    self = scope
    $.ajax
      type: "POST",
      url: "#{self.updateURL}.json",
      data:
        post:
          title: self.postTitle()
          content: self.postContent()
      success: (data)->
        self.updatePreview(data)
      error: (error)->
        console.log(error)
  postTitle: ->
    this.postEditForm.find('#post_title').val()
  postContent: ->
    this.postEditForm.find('#post_content').val()
  updatePreview: (data)->
    this.updateContent(data.content)
    this.updatetitle(data.title)
    this.updatePost(this)
  updatetitle: (title)->
    this.preview.find('.title').html(title)
  updateContent: (content)->
    this.preview.find('.content').html(content)
