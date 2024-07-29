// const { app } = require('../app')
// const WebSocket = require('ws')

// // Initialize WebSocket server on top of the HTTP server
// const wss = new WebSocket.Server({ server })

// wss.on('connection', (ws) => {
//   ws.on('message', (message) => {
//     console.log(`Received message => ${message}`)
//   })

//   ws.send(JSON.stringify({ message: 'Welcome to the WebSocket server!' }))
// })

// function broadcast(data) {
//   wss.clients.forEach((client) => {
//     if (client.readyState === WebSocket.OPEN) {
//       client.send(JSON.stringify(data))
//     }
//   })
// }

// // Call broadcast function whenever there's a new bid
// function newBid(bid) {
//   broadcast({ type: 'NEW_BID', bid })
// }

// module.exports = { newBid, server }
