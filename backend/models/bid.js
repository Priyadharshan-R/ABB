const mongoose = require('mongoose')

const bidSchema = new mongoose.Schema({
  price: { type: Number, required: true },
  username: { type: String, required: true },
  time: { type: Date, required: true, default: Date.now },
})

module.exports = bidSchema
