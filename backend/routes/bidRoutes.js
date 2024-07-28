const express = require('express')
const { addBid, getBids } = require('../controllers/bidController')
const authMiddleware = require('../middleware/authMiddleware')

const router = express.Router()

// router.post('/', authMiddleware, createBid)
router.put('/', addBid)
router.get('/:id', getBids)

module.exports = router
