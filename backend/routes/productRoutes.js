const express = require('express')
const {
  createProduct,
  updateProduct,
  deleteProduct,
  getProducts,
  getProduct,
  getProductByOwner,
  winner,
  addReview,
} = require('../controllers/productController')
const authMiddleware = require('../middleware/authMiddleware')

const router = express.Router()

router.post('/', createProduct)
router.put('/:id', updateProduct)
router.delete('/:id', authMiddleware, deleteProduct)
router.get('/', getProducts)
router.get('/:id', authMiddleware, getProduct)
router.get('/u/:email', getProductByOwner)
router.put('/winner', winner)
router.put('/reviews', addReview)

module.exports = router
