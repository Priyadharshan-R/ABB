const nodemailer = require('nodemailer')

const sendNotification = async (userId, message) => {
  // Implementation of email or any other notification mechanism
  console.log(`Notification to user ${userId}: ${message}`)
}

module.exports = { sendNotification }
