importScripts('https://storage.googleapis.com/workbox-cdn/releases/3.6.1/workbox-sw.js')

if (workbox) {
  const revision = '1'
  const urls = [
    '/style.css',
    '/app.js',
    '/start.js',
    '/index.html'
  ]
  const revisionize = (url) => ({ url, revision })

  workbox.precaching.precacheAndRoute(
    urls.map(revisionize)
  )

  workbox.routing.registerRoute(
    '/',
    workbox.strategies.staleWhileRevalidate()
  )
  workbox.routing.registerRoute(
    '/style.css',
    workbox.strategies.staleWhileRevalidate()
  )
  workbox.routing.registerRoute(
    '/app.js',
    workbox.strategies.staleWhileRevalidate()
  )
  workbox.routing.registerRoute(
    '/start.js',
    workbox.strategies.staleWhileRevalidate()
  )
}
