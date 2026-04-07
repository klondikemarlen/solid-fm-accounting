/**
 * plugins/vuetify.js
 *
 * Framework documentation: https://vuetifyjs.com`
 */

import "@/styles/layers.css"
import "vuetify/styles"
import "uno.css"

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
