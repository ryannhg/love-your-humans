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
  self.addEventListener('push', function (e) {
    var options = {
      body: 'This notification was generated from a push!',
      vibrate: [100, 50, 100],
      data: {
        dateOfArrival: Date.now(),
        primaryKey: '2'
      },
      actions: []
    }
    e.waitUntil(
      self.registration.showNotification('Hello world!', options)
    )
  })
}
