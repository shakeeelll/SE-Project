const {
  login,
  deleteLog,
  product,
  feedback,
  salesrecord,
} = require("../Models/sidnup_schema");
const jwt = require("jsonwebtoken");

async function createuser(req, res) {
  try {
    console.log(req.body);
    const pro = await login.create(req.body);
    res.status(201).json(pro);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}
async function createproduct(req, res) {
  try {
    const pro = await product.create(req.body);
    res.status(201).json(pro);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}
async function createfeedback(req, res) {
  try {
    const pro = await feedback.create(req.body);
    res.status(200).json(pro);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}
async function createsalesrecord(req, res) {
  try {
    const pro = await salesrecord.create(req.body);
    res.status(200).json(pro);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}
async function getall(req, res) {
  try {
    const pro = await login.find({});
    res.json(pro);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}
async function allProducts(req, res) {
  try {
    const pro = await product.find({});
    res.json(pro);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}
async function admindasbhard(req, res) {
  res.json({ message: "Admin dashboard " });
}
function genrate_token(user) {
  const payload = {
    role: user.Role,
    id: user._id,
  };

  const token = jwt.sign(payload, "ssdfj$sdanh%dmnvnsd@");

  return token;
}
async function login2(req, res) {
  const { email, password } = req.body;

  try {
    const user = await login.findOne({ email });

    if (!user) return res.status(404).json({ error: "User not found" });

    if (user.password != password)
      return res.status(401).json({ error: "Invalid credentials" });

    var token = genrate_token(user);

    return res.status(200).json({
      message: "Logged in successfully",
      //email: email,       // you  may add require things to throw of this user
      fullname: user.f_name,
      Role: user.Role,
      //userid: user.id,
      //token: token,
    });
  } catch (err) {
    return res.status(500).json({ message: err });
  }
}
async function edit_user(req, res) {
  try {
    const { id } = req.params;
    const updateuser = await login.findByIdAndUpdate(id, req.body, {
      new: true,
    });
    res.json(updateuser);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}
async function edit_product(req, res) {
  try {
    const { id } = req.params;
    const updateproduct = await product.findByIdAndUpdate(id, req.body, {
      new: true,
    });
    res.json(updateproduct);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}
async function getDailySalesReport(req, res) {
  try {
    const { date } = req.query;
    const startDate = new Date(date);
    const endDate = new Date(date);
    endDate.setHours(23, 59, 59, 999);
    
    const dailySales = await salesrecord.find({
      saleDate: { $gte: startDate, $lte: endDate }
    }).exec();

    const totalSales = await salesrecord.aggregate([
      {
        $group: {
          _id: null,
          total: { $sum: '$totalPrice' }
        }
      }
    ]);

    res.status(200).json({ dailySales, totalSales: totalSales[0].total });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}


async function sale(req, res) {
  try {
    const { id } = req.params;
    console.log(id);
    const { quantity } = req.body;
    const product1 = await product.findById(id);
    if (!product1) {
      return res.status(404).json({ error: 'Product not found' });
    }
    product1.quantity -= quantity;
    await product1.save();
    // Respond with success
    res.status(200).json({ message: 'Product sold successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}
async function delete_user2(req, res) {
  try {
    const { id } = req.params;

    // Fetch the worker before deletion for logging
    const workerToDelete = await login.findById(id);
    console.log(workerToDelete);
    await deleteLog.create({
      f_name: workerToDelete.f_name,
      l_name: workerToDelete.l_name,
      Role: workerToDelete.Role,
      email: workerToDelete.email,
      deletedAt: Date.now(),
    });
    await login.findByIdAndDelete(id);
    // Log the worker deletion
    res.status(204).json({ message: "Deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}
async function delete_product(req, res) {
  try {
    const { id } = req.params;
    await product.findByIdAndDelete(id);
    res.status(204).json({ message: "Deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}
module.exports = {
  createuser,
  getall,
  edit_user,
  delete_user2,
  login2,
  admindasbhard,
  createproduct,
  allProducts,
  edit_product,
  delete_product,
  createfeedback,
  createsalesrecord,
  sale,
  getDailySalesReport,
};
