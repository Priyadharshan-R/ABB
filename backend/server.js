const express = require('express')
const mongoose = require('mongoose')
const WebSocket = require('ws')
const moment = require('moment')
const http = require('http')
const dotenv = require('dotenv')
const config = require('./config')
const authRoutes = require('./routes/authRoutes')
const productRoutes = require('./routes/productRoutes')
const bidRoutes = require('./routes/bidRoutes')
const userRoutes = require('./routes/userRoutes')
const { errorHandler } = require('./middleware/errorMiddleware')
const cors = require('cors')

dotenv.config()

const app = express()
const port = process.env.PORT || 5000
const server = http.createServer(app)

// Initialize WebSocket server on top of the HTTP server
// const wss = new WebSocket.Server({ server })

// wss.on('connection', (ws) => {
//   ws.on('message', (message) => {
//     console.log(Received message => ${message})
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

// Call broadcast function whenever there's a new bid
// function newBid(bid) {
//   broadcast({ type: 'NEW_BID', bid })
// }

app.use(cors())
app.use(express.json())
app.use('/api/auth', authRoutes)
app.use('/api/products', productRoutes)
app.use('/api/bids', bidRoutes)
app.use('/api/users', userRoutes)

app.use(errorHandler)

// Connect to MongoDB and start the server
mongoose
  .connect('mongodb://127.0.0.1:27017/genix_auctions')
  .then(() => {
    server.listen(port, () => {
      console.log(`Server running on port ${port}`)
    })
  })
  .catch((err) => console.error(err))

// module.exports = { newBid }
