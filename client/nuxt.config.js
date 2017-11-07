// Proper way to include jQuery, Foundation & Bootstrap.
// Note that you cannot use import key here to import webpack.
// https://github.com/nuxt/nuxt.js/issues/178
const webpack = require('webpack')

// https://nuxtjs.org/api/configuration-build
module.exports = {
  /*
  ** Headers of the page
  */
  head: {
    title: 'starter',
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: 'Nuxt.js project' }
    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
      // Add cdn (not ideal).
      // { rel: 'stylesheet', href: 'https://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.css' },
      // { rel: 'stylesheet', href: 'https://cdnjs.cloudflare.com/ajax/libs/foundation/6.4.3/css/foundation.min.css' }
    ],
    // Add cdn (not ideal).
    // https://nuxtjs.org/faq/
    script: [
      // { src: 'https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.1/jquery.min.js' },
      // { src: 'https://cdnjs.cloudflare.com/ajax/libs/foundation/6.4.3/js/foundation.min.js' }
    ],
  },
  env: {
    HOST_URL: process.env.HOST_URL || 'http://127.0.0.1:8000'
  },
  build: {
    vendor: [
      // Add foundation and its dependency - jQuery.
      'jquery',
      'foundation-sites',

      // 'axios',
      // '~/plugins/axios.js',

      // Global js (a hack) - but it should have a better way!
      '~/assets/js/main.js'
    ],
    plugins: [
      // Set shortcuts as global for bootstrap.
      new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        'window.jQuery': 'jquery'
      })
    ]
  },
  // https://nuxtjs.org/guide/plugins/
  plugins: [
    // '~/plugins/axios.js',

    // Include bootstrap/ foundation-sites js on startup.
    // No need of this if you use mounted method.
    // '~/plugins/foundation-sites.js'
  ],
  /*
  ** Global CSS
  */
  css: [
    '~/assets/css/main.css',

    // include bootstrap/ foundation css
    'foundation-sites/dist/css/foundation.min.css',
    'foundation-icon-fonts/foundation-icons.css',

    // include jquery-ui css
    'jquery-ui-bundle/jquery-ui.min.css',
  ],
  /*
  ** Global JS - does not work
  */
  js: ['~/assets/js/main.js']
}
