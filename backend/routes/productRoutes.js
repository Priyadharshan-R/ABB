const express = require('express')
const {
  createProduct,
  updateProduct,
  deleteProduct,
  getProducts,
  getProduct,
  getProductByOwner,
} = require('../controllers/productController')
const authMiddleware = require('../middleware/authMiddleware')

const router = express.Router()

router.post('/', createProduct)
router.put('/:id', updateProduct)
router.delete('/:id', authMiddleware, deleteProduct)
router.get('/', getProducts)
router.get('/:id', getProduct)
router.get('/u/:email', getProductByOwner)

module.exports = router
