// Elm stuff
const initializeElm = () => {
  var app = window.Elm.Main.init({
    node: document.getElementById('app'),
    flags: {
      humans: getHumans()
    }
  })

  app.ports.outgoing.subscribe(function (msg) {
    console.log('msg', msg)
    switch (msg.action) {
      case 'STORE_HUMAN':
        return storeHuman(msg.data)
      case 'UNSTORE_HUMAN':
        return removeHuman(msg.data)
      case 'SEND_NOTIFICATION':
        return sendNotification(msg.data)
    }
  })

  function storeHuman (human) {
    var humans = getHumans()
    humans = humans.concat(human)
    window.localStorage
      .setItem('humans', JSON.stringify(humans))
  }

  function removeHuman (human) {
    var humans = getHumans()
      .filter(storedHuman =>
        human.name !== storedHuman.name ||
        human.phone !== storedHuman.phone
      )
    window.localStorage
      .setItem('humans', JSON.stringify(humans))
  }

  function getHumans () {
    return JSON.parse(window.localStorage.getItem('humans')) || []
  }

  function sendNotification (notification) {
    if (window.reg) {
      window.reg.showNotification(notification.title)
    } else {
      console.info('Notifications not supported...')
    }
  }
}

// PWA Stuff
if ('serviceWorker' in navigator) {
  // Use the window load event to keep the page load performant
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js')
  })
  // Push Notifications!
  const setupNotifications = (status) => {
    if (status === 'granted') {
      navigator.serviceWorker.getRegistration()
        .then(function (reg) {
          window.reg = reg
          setTimeout(initializeElm, 500)
        })
    }
  }

  Notification.requestPermission(setupNotifications)
}
