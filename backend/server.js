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
const { errorHandler } = require('./middleware/errorMiddleware')
const cors = require('cors')

dotenv.config()

const app = express()
const port = process.env.PORT || 5000
const server = http.createServer(app)
const wss = new WebSocket.Server({ server })

wss.on('connection', (ws) => {
  ws.on('message', (message) => {
    const bidData = JSON.parse(message)
    handleNewBid(bidData)
  })
})

app.use(cors())
app.use(express.json())
app.use('/api/auth', authRoutes)
app.use('/api/products', productRoutes)
app.use('/api/bids', bidRoutes)
app.use(errorHandler)

mongoose
  .connect('mongodb://127.0.0.1:27017/genix_auctions')
  .then(() =>
    app.listen(config.PORT, () =>
      console.log(
        `Server running on port ${config.PORT} ${config.JWT_SECRET} ${config.MONGO_URI}`
      )
    )
  )
  .catch((err) => console.error(err))

// const connection = mongoose.connection
// connection.once('open', () => {
//   console.log('MongoDB database connection established successfully')
// })

// app.get('/api/data', (req, res) => {
//   res.json([
//     { id: 1, name: 'Item 1' },
//     { id: 2, name: 'Item 2' },
//   ])
// })

// app.listen(port, () => {
//   console.log(`Server is running on port: ${port}`)
// })
