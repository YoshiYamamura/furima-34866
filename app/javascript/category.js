function pullDown() {

  const pullDownButton = document.getElementById("category-title")
  const pullDownLists = document.getElementById("category-area")

  pullDownButton.addEventListener('mouseover', function(){
    this.setAttribute("style", "background: lightgray;")
    pullDownLists.setAttribute("style", "display: block;")
  })

  pullDownLists.addEventListener('mouseleave', function(){
    pullDownButton.removeAttribute("style", "background: lightgray;")
    this.removeAttribute("style", "display: block;")
  })
}

window.addEventListener('load', pullDown)