import { ready } from "./utils"
import SimpleMDE from "simplemde"
import "simplemde/dist/simplemde.min.css"
import "../css/content-editor-overrides.css"


const requestPreview = (plainText, previewContainer) => {
  let request = new XMLHttpRequest()
  const postForm = previewContainer.closest('form')
  let formData = new FormData(postForm)

  formData.set('post[content]', plainText)

  request.addEventListener('load', function(event) {
    previewContainer.innerHTML = event.target.responseText
  })

  request.open('POST', '/pages/posts/preview', true)

  request.send(formData)
}

ready(() => {
  document.querySelectorAll('[data-simplemde]').forEach(el => {
    new SimpleMDE({
      element: el,
      previewRender: (plainText, previewContainer) => {
        requestPreview(plainText, previewContainer)

        return previewContainer.innerHTML
      },
    })
  })
})
