import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["favouriteButton"]

    connect() {
        console.log("ItemFavouriteController connected")
    }
}