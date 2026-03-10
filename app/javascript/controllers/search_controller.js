import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["input", "results", "annictId", "imageUrl"]

  connect() {
    this.debounceTimer = null
  }

  handleSearch(event) {
    if (this.debounceTimer) clearTimeout(this.debounceTimer)

    const keyword = event.target.value

    if (!keyword || keyword.length < 2) {
      if (this.hasResultsTarget) {
        this.resultsTarget.classList.add('hidden')
        this.resultsTarget.innerHTML = ''
      }
      return
    }

    this.debounceTimer = setTimeout(async () => {
      try {
        if (this.hasResultsTarget) {
          this.resultsTarget.innerHTML = '<div class="p-2 text-gray-500 text-sm italic">検索中...</div>'
          this.resultsTarget.classList.remove('hidden')
        }

        const response = await fetch(`/posts/search?keyword=${encodeURIComponent(keyword)}`)
        const works = await response.json()

        if (Array.isArray(works) && this.hasResultsTarget) {
          if (works.length === 0) {
            this.resultsTarget.innerHTML = '<div class="p-2 text-gray-500 text-sm">見つかりませんでした</div>'
          } else {
            this.resultsTarget.innerHTML = works.map(work => {
              const imageUrl = work.images?.recommended_url || ''
              const imgTag = imageUrl ? `<img src="${imageUrl}" class="w-10 h-10 object-cover mr-2 rounded">` : ''
              const safeTitle = work.title.replace(/'/g, "\\'")

              return `
                <div class="p-2 border-b cursor-pointer hover:bg-gray-100 flex items-center bg-white" 
                    data-action="click->search#selectWork"
                    data-title="${safeTitle}"
                    data-image-url="${imageUrl}"
                    data-annict-id="${work.id}">
                  ${imgTag}
                  <span class="text-sm text-gray-800">${work.title}</span>
                </div>
              `
            }).join('')
          }
        }
      } catch (err) {
        console.error("Search error:", err)
        if (this.hasResultsTarget) {
          this.resultsTarget.innerHTML = '<div class="p-2 text-red-500 text-sm">エラーが発生しました</div>'
        }
      }
    }, 400)
  }

  selectWork(event) {
    const item = event.currentTarget
    const title = item.dataset.title
    const imageUrl = item.dataset.imageUrl
    const annictId = item.dataset.annictId

    if (this.hasInputTarget) this.inputTarget.value = title
    if (this.hasAnnictIdTarget) this.annictIdTarget.value = annictId
    if (this.hasImageUrlTarget) this.imageUrlTarget.value = imageUrl

    if (this.hasResultsTarget) {
      this.resultsTarget.classList.add('hidden')
      this.resultsTarget.innerHTML = ''
    }
  }
}
