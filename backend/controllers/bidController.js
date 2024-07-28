const Bid = require('../models/bid')
const Product = require('../models/product')
const { sendNotification } = require('../utils/sendNotification')

const addBid = async (req, res) => {
  const { productId, price, username } = req.body

  try {
    const product = await Product.findById(productId)

    if (!product) {
      return res.status(404).json({ message: 'Product not found' })
    }

    if (price <= product.currentBidPrice) {
      return res
        .status(400)
        .json({ message: 'Bid price must be higher than the current price' })
    }

    const newBid = {
      price,
      username,
      time: new Date(),
    }

    product.bids.push(newBid)
    product.currentBidPrice = price

    await product.save()

    // Notify all connected clients about the new bid
    // wss.clients.forEach((client) => {
    //   if (client.readyState === WebSocket.OPEN) {
    //     client.send(JSON.stringify(newBid))
    //   }
    // })

    res.status(200).json(product)
  } catch (err) {
    res.status(400).json({ message: err.message })
  }
}

const getBids = async (req, res) => {
  try {
    const item = await Bid.findById(req.params.id)
    if (item) {
      res.json(item)
    } else {
      res.status(404).json({ message: 'Item not found' })
    }
  } catch (error) {
    res.status(500).json({ message: 'Error fetching item' })
  }
}

// const createBid = async (req, res) => {
//   const { productId, amount } = req.body

//   try {
//     const product = await Product.findById(productId).populate('bids')
//     const highestBid = product.bids.reduce(
//       (max, bid) => (bid.amount > max ? bid.amount : max),
//       0
//     )

//     if (amount <= highestBid) {
//       return res
//         .status(400)
//         .json({ message: 'Bid must be higher than the current highest bid' })
//     }

//     const bid = new Bid({
//       product: productId,
//       user: req.user.id,
//       amount,
//     })

//     await bid.save()
//     product.bids.push(bid)
//     await product.save()

//     // Send notifications to previous highest bidders
//     for (const previousBid of product.bids) {
//       if (previousBid.amount === highestBid) {
//         sendNotification(
//           previousBid.user,
//           `You have been outbid on ${product.title}`
//         )
//       }
//     }

//     res.status(201).json(bid)
//   } catch (err) {
//     res.status(400).json({ message: err.message })
//   }

module.exports = { addBid, getBids }
