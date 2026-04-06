import { defineConfig, presetWind4 } from "unocss"

export default defineConfig({
  presets: [presetWind4()],
  outputToCssLayers: {
    cssLayerName: layer => {
      if (layer === "default") return "uno-default"
      if (layer === "preflights") return "uno-base"
      if (layer === "shortcuts") return "uno-shortcuts"
      if (layer === "theme") return "uno-theme"

      return layer
    },
  },
})
