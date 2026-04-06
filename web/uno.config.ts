import { defineConfig, presetWind4 } from "unocss"

export default defineConfig({
  presets: [presetWind4()],
  outputToCssLayers: {
    cssLayerName: layer => {
      if (layer === "default") return "utilities"
      if (layer === "preflights") return "base"
      if (layer === "shortcuts") return "components"

      return layer
    },
  },
})
