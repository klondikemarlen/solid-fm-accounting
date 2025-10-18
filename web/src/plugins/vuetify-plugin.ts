/**
 * plugins/vuetify.js
 *
 * Framework documentation: https://vuetifyjs.com`
 */

// Styles - Note that order matters here!
import "modern-normalize/modern-normalize.css"
import "vuetify/styles"

import { createVuetify } from "vuetify"

// https://vuetifyjs.com/en/introduction/why-vuetify/#feature-guides
export default createVuetify({
  theme: {
    defaultTheme: "system",
  },

  defaults: {
    // add over time
  },
})
