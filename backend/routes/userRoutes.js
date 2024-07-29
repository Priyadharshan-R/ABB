const express = require('express')
const router = express.Router()
const { getProfile, addFavorites } = require('../controllers/userController')
const authMiddleware = require('../middleware/authMiddleware') // Assuming you have an authentication middleware

router.get('/profile', authMiddleware, getProfile)
router.put('/users/favorites', authMiddleware, addFavorites)
// router

module.exports = router
