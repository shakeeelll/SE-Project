const express = require("express");
const validateToke = require("../authorization_middleware/middleware");
const router = express.Router();
const productController = require("../Controllers/signup");
const { deleteLog } = require("../Models/sidnup_schema");
router.post("/signup", productController.createuser);
router.get("/signup", productController.getall);
router.put("/signup/:id", productController.edit_user);
router.delete("/signup/:id", productController.delete_user2);
router.post("/login", productController.login2);
router.post("/add-product", productController.createproduct);
router.get("/products", productController.allProducts);
router.put("/products/:id", productController.edit_product);
router.put("/sale/:id", productController.sale);
router.get("/sales-report", productController.getDailySalesReport);
router.delete("/products/:id", productController.delete_product);
router.post("/feedback", productController.createfeedback);
router.post("/salesrecord", productController.createsalesrecord);
router.get("/deletedUsers", async (req, res) => {
  try {
    const deletedUsers = await deleteLog.find({});
    res.status(200).json(deletedUsers);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});
router.get(
  "/endpoint",
  validateToke.validateToken,
  requireRoles(["admin"]),
  (req, res) => {
    console.log("API endpoint handler");
    res.send("API response");
  }
);
function requireRoles(roles) {
  return (req, res, next) => {
    const userRole = req.user.role; // Assuming you saved the user's role in req.user

    if (roles.includes(userRole)) {
      // User has one of the required roles, so allow access

      next();
    } else {
      // User does not have any of the required roles, so send a forbidden response

      res.status(403).json({ message: "Permission denied" });
    }
  };
}

module.exports = router;
