const User = require('../models/user')
const jwt = require('jsonwebtoken')
const config = require('../config')
const { broadcast } = require('../utils/broadcast')

const register = async (req, res) => {
  const { username, email, password } = req.body

  try {
    const user = new User({ username, email, password })
    await user.save()
    console.log(config.JWT_SECRET)
    const token = jwt.sign({ id: user._id }, config.JWT_SECRET, {
      expiresIn: '1h',
    })

    res.status(201).json({ token })
  } catch (err) {
    res.status(400).json({ message: err.message })
  }
}

const login = async (req, res) => {
  const { email, password } = req.body

  try {
    const user = await User.findOne({ email })
    if (!user || !(await user.matchPassword(password))) {
      return res.status(400).json({ message: 'Invalid email or password' })
    }
    const username = user.username
    const token = jwt.sign({ id: user._id }, config.JWT_SECRET, {
      expiresIn: '1h',
    })

    res.json({ token, username })
  } catch (err) {
    res.status(400).json({ message: err.message })
  }
}

module.exports = { register, login }
