const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'talhawarraich818@gmail.com', // Replace with your Gmail email address
    pass: 'Ann431gam57', // Replace with your gmal got password
  },
});

const sendEmail = (subject, text) => {
  const mailOptions = {
    from: 'talhawarraich818@gmail.com',
    to: 'talhawarraich230@gmail.com', // Replace with your admin's email address
    subject: subject,
    text: text,
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.error(error);
    } else {
      console.log('Email sent: ' + info.response);
    }
  });
};

module.exports = { sendEmail };
