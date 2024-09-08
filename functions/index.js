const functions = require('firebase-functions');
const nodemailer = require('nodemailer');

// Create a transporter object using the default SMTP transport
const transporter = nodemailer.createTransport({
  service: 'gmail', // or another email service provider
  auth: {
    user: 'your-email@gmail.com',
    pass: 'your-email-password'
  }
});

exports.sendOrderConfirmationEmail = functions.firestore
  .document('orders/{orderId}')
  .onCreate(async (snap, context) => {
    const order = snap.data();

    const mailOptions = {
      from: 'your-email@gmail.com',
      to: order.email,
      subject: 'Order Confirmation',
      text: `Dear ${order.name},\n\nYour order with ID ${order.id} has been placed successfully.\n\nThank you for shopping with us!\n\nBest regards,\nYour Company`
    };

    try {
      await transporter.sendMail(mailOptions);
      console.log('Order confirmation email sent successfully.');
    } catch (error) {
      console.error('Error sending email:', error);
    }
  });
