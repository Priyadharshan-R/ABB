const mongoose = require('mongoose')
const bidSchema = require('./bid')

const productSchema = new mongoose.Schema({
  owner: { type: String, ref: 'User', required: true },
  title: { type: String, required: true },
  description: { type: String, required: true },
  imageUrl: { type: String, required: true },
  minimumBidPrice: { type: Number, required: true },
  currentBidPrice: { type: Number, required: true },
  bidEndingTime: { type: Date, required: true },
  bids: { type: [bidSchema], default: [] },
  reviews: [
    {
      username: { type: String, required: true },
      review: { type: String, required: true },
      rating: { type: Number, required: true },
    },
  ],
  winner: { type: String },
  createdAt: { type: Date, default: Date.now },
})

module.exports = mongoose.model('Product', productSchema)
