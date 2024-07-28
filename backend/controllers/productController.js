const Product = require('../models/product')
const Bid = require('../models/bid')

const createProduct = async (req, res) => {
  const { id, title, description, imageUrl, minimumBidPrice, bidEndingTime } =
    req.body

  try {
    const product = new Product({
      owner: id,
      title,
      description,
      imageUrl,
      minimumBidPrice,
      currentBidPrice: minimumBidPrice, // Set initial current bid price to minimum bid price
      bidEndingTime,
    })

    await product.save()

    res.status(201).json({ product })
  } catch (err) {
    res.status(400).json({ message: err.message })
  }
}

const updateProduct = async (req, res) => {
  const { id } = req.params
  const {
    description,
    imageUrl,
    title,
    minimumBidPrice,
    currentBidPrice,
    bidEndingTime,
  } = req.body

  try {
    const product = await Product.findById(id)

    if (product.owner.toString() !== req.user._id.toString()) {
      return res.status(401).json({ message: 'Not authorized' })
    }

    if (!product) {
      res.status(400).json({ message: 'product not found' })
    }

    product.description = description
    product.imageUrl = imageUrl
    product.title = title
    product.minimumBidPrice = minimumBidPrice
    product.currentBidPrice = currentBidPrice
    product.bidEndingTime = bidEndingTime

    await product.save()
    res.json(product)
  } catch (err) {
    res.status(400).json({ message: err.message })
  }
}

const deleteProduct = async (req, res) => {
  const { id } = req.params

  try {
    const product = await Product.findById(id)

    if (product.owner.toString() !== req.user.id) {
      return res.status(401).json({ message: 'Not authorized' })
    }

    await product.remove()
    res.json({ message: 'Product removed' })
  } catch (err) {
    res.status(400).json({ message: err.message })
  }
}

const getProduct = async (req, res) => {
  try {
    const item = await Product.findById(req.params.id)
    if (item) {
      res.json(item)
    } else {
      res.status(404).json({ message: 'Item not found' })
    }
  } catch (error) {
    res.status(500).json({ message: 'Error fetching item' })
  }
}

const getProductByOwner = async (req, res) => {
  try {
    const ownerId = req.params.email

    if (!ownerId) {
      return res.status(400).json({ error: 'Owner ID is required' })
    }

    const products = await Product.find({ owner: ownerId })
    res.json(products)
  } catch (error) {
    console.error('Error fetching products:', error)
    res.status(500).json({ error: 'Internal server error' })
  }
}

const getProducts = async (req, res) => {
  const { page = 1, limit = 10 } = req.query // Get page and limit from query parameters

  try {
    const products = await Product.find()
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .exec()

    // Get total documents in the Product collection
    const count = await Product.countDocuments()

    res.status(200).json({
      products,
      totalPages: Math.ceil(count / limit),
      currentPage: page,
    })
  } catch (err) {
    res.status(500).json({ message: 'Server error' })
  }
}

module.exports = {
  createProduct,
  updateProduct,
  deleteProduct,
  getProducts,
  getProduct,
  getProductByOwner,
}
