const mongoose = require("mongoose");
const user_Schema = new mongoose.Schema(
  {
    f_name: String,
    l_name: String,
    Role: String,
    email: String,
    password: String,
    is_verified: String,
  },
  { timestamps: true }
);
const deleteLogSchema = new mongoose.Schema({
  f_name: String,
  l_name: String,
  Role: String,
  email: String,
  deletedAt: {
    type: Date,
  },
});
const productSchema = new mongoose.Schema({
  name: String,
  price: Number,
  quantity: Number,
  description: String,
  discount: Number,
});
const feedbackSchema = new mongoose.Schema({
  name: String,
  feedback: String,
});
const salesrecordSchema = new mongoose.Schema({
  productName: String,
  pricePerUnit: Number,
  quantity: Number,
  totalPrice: Number,
  saleDate:Date,
});

let login = mongoose.model("logins", user_Schema);
let deleteLog = mongoose.model("Deletelog", deleteLogSchema);
let product = mongoose.model("products", productSchema);
let feedback = mongoose.model("feedbacks", feedbackSchema);
let salesrecord = mongoose.model("salesrecords", salesrecordSchema);
module.exports = { login, deleteLog, product, feedback, salesrecord };
