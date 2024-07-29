const mongoose = require('mongoose')
const bcrypt = require('bcryptjs')
const bidSchema = require('./bid')

const userSchema = new mongoose.Schema({
  username: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  favorites: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Product' }],
  products: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Product' }],
  bids: [{ type: [bidSchema], default: [] }],
})

userSchema.pre('save', async function (next) {
  if (!this.isModified('password')) return next()
  const salt = await bcrypt.genSalt(10)
  this.password = await bcrypt.hash(this.password, salt)
  next()
})

userSchema.methods.matchPassword = async function (password) {
  return await bcrypt.compare(password, this.password)
}

module.exports = mongoose.model('User', userSchema)
