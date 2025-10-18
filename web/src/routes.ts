import { type RouteRecordRaw } from "vue-router"

const routes: RouteRecordRaw[] = [
  {
    path: "/",
    component: () => import("@/layouts/DefaultLayout.vue"),
    children: [
      {
        path: "",
        redirect: {
          name: "DashboardPage",
        },
      },
      {
        path: "dashboard",
        name: "DashboardPage",
        component: () => import("@/pages/DashboardPage.vue"),
        meta: {
          title: "Dashboard",
        },
      },
      {
        path: "profile",
        name: "ProfilePage",
        component: () => import("@/pages/ProfilePage.vue"),
        meta: {
          title: "My Profile",
        },
      },
      {
        path: "notifications",
        name: "NotificationsPage",
        component: () => import("@/pages/NotificationsPage.vue"),
        meta: {
          title: "Notifications",
        },
      },
    ],
  },
  {
    path: "/sign-in",
    name: "SignInPage",
    component: () => import("@/pages/SignInPage.vue"),
    meta: {
      title: "Sign In",
      requiresAuth: false,
    },
  },
  {
    path: "/status",
    name: "StatusPage",
    component: () => import("@/pages/StatusPage.vue"),
    meta: {
      title: "Status",
      requiresAuth: false,
    },
  },
  {
    path: "/errors/unauthorized",
    name: "UnauthorizedPage",
    component: () => import("@/pages/UnauthorizedPage.vue"),
    meta: {
      title: "Unauthorized",
      requiresAuth: false,
    },
  },
  {
    path: "/:pathMatch(.*)*",
    name: "NotFoundPage",
    component: () => import("@/pages/NotFoundPage.vue"),
    meta: {
      title: "Not Found",
      requiresAuth: false,
    },
  },
]

export default routes
