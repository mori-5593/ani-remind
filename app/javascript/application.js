// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("DOMContentLoaded", () => {
  const button = document.getElementById("menu-button")
  const menu = document.getElementById("mobile-menu")

  if (button) {
    button.addEventListener("click", () => {
      menu.classList.toggle("hidden")
    })
  }
})