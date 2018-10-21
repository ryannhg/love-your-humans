importScripts('https://storage.googleapis.com/workbox-cdn/releases/3.6.1/workbox-sw.js')

if (workbox) {
  const revision = '5'
  const urls = [
    '/style.css',
    '/app.js',
    '/start.js',
    '/index.html',
    '/manifest.json',
    '/icons/128.png',
    '/icons/192.png',
    '/icons/512.png'
  ]
  const revisionize = (url) => ({ url, revision })

  workbox.precaching.precacheAndRoute(
    urls.map(revisionize)
  )
}
