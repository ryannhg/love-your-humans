importScripts('https://storage.googleapis.com/workbox-cdn/releases/3.6.1/workbox-sw.js')

if (workbox) {
  const urls = [
    '/',
    '/style.css',
    '/app.js',
    '/start.js',
    '/manifest.json',
    '/icons/128.png',
    '/icons/192.png',
    '/icons/512.png'
  ]

  urls.forEach(url =>
    workbox.routing.registerRoute(
      url,
      workbox.strategies.staleWhileRevalidate()
    )
  )
}
