const User = require('../models/user')

const addFavorites = async (req, res) => {
  const userId = req.user.id // Assuming you have user ID stored in req.user from authentication middleware
  const { productId } = req.body

  try {
    const user = await User.findById(userId)

    if (!user) {
      return res.status(404).json({ message: 'User not found' })
    }

    const productIndex = user.favorites.indexOf(productId)

    if (productIndex >= 0) {
      user.favorites.splice(productIndex, 1)
    } else {
      user.favorites.push(productId)
    }

    await user.save()

    res.json({ message: 'Favorites updated successfully' })
  } catch (err) {
    res.status(500).json({ message: err.message })
  }
}
const getProfile = async (req, res) => {
  const userId = req.user.id // Assuming you have user ID stored in req.user from authentication middleware

  try {
    const user = await User.findById(userId)
      .populate('favorites', 'title imageUrl')
      .populate('products', 'title imageUrl')
      .populate({
        path: 'bids',
        populate: {
          path: 'product',
          select: 'title imageUrl',
        },
      })

    if (!user) {
      return res.status(404).json({ message: 'User not found' })
    }

    const profile = {
      username: user.username,
      favorites: user.favorites,
      products: user.products,
      bids: user.bids,
    }

    res.json(profile)
  } catch (err) {
    res.status(500).json({ message: err.message })
  }
}

module.exports = {
  addFavorites,
  getProfile,
}
