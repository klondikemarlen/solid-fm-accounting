import { createApp } from "vue"

// Plugins
import vuetifyPlugin from "@/plugins/vuetify-plugin"
import auth0Plugin from "@/plugins/auth0-plugin"
import routerPlugin from "@/plugins/router-plugin"
import vueI18nPlugin from "@/plugins/vue-i18n-plugin"

import App from "@/App.vue"

const app = createApp(App)
app.use(routerPlugin).use(vuetifyPlugin).use(auth0Plugin).use(vueI18nPlugin)

app.mount("#app")
