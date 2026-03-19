import { Controller } from "@hotwired/stimulus"

// Filters house item cards as the user types in search.
export default class extends Controller {
  static targets = ["input", "item", "noResults", "categorySelect"]

  filter() {
    const query = this.inputTarget.value.trim().toLowerCase()
    const selectedCategory = this.categorySelectTarget.value.trim().toLowerCase()
    let visibleCount = 0

    this.itemTargets.forEach((card) => {
      const haystack = card.textContent.toLowerCase()
      const cardCategory = (card.dataset.houseSearchCategoryValue || "").toLowerCase()

      const matchesText = query === "" || haystack.includes(query)
      const matchesCategory = selectedCategory === "" || cardCategory === selectedCategory
      const isVisible = matchesText && matchesCategory

      card.hidden = !isVisible
      if (isVisible) visibleCount += 1
    })

    const showNoResults = this.itemTargets.length > 0 && visibleCount === 0
    this.noResultsTarget.classList.toggle("d-none", !showNoResults)
  }
}
