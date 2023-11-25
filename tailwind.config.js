/** @type {import('tailwindcss').Config} **/
module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      gridTemplateRows: {
        applet: "min-content 1fr min-content"
      }
    }
  }
}
