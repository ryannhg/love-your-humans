// Elm stuff

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

// PWA Stuff
if ('serviceWorker' in navigator) {
  // Use the window load event to keep the page load performant
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js')
  })
}
