const cron = require("node-cron");
const { product } = require("../Models/sidnup_schema");
const { sendEmail } = require("../Controllers/email");
async function checkstock() {
  cron.schedule("*/2000 * * * *", async () => {
    try {
      const lowStockProducts = await getProductsLowStock();

      if (lowStockProducts.length > 0) {
        const emailContent = lowStockProducts
          .map((product) => {
            return `Product ${product.name} is running low on stock (Quantity: ${product.quantity}).`;
          })
          .join("\n");
        // Send a single email with all low stock products information
        sendEmail("Low Stock Alert", emailContent);
      }
    } catch (error) {
      console.error("Error in cron job:", error);
    }
  });
}
async function getProductsLowStock() {
  try {
    const lowStockProducts = await product.find({ quantity: { $lte: 1 } }); // Adjust the query condition as needed
    return lowStockProducts;
  } catch (error) {
    console.error("Error fetching low stock products:", error);
    throw error;
  }
}
module.exports = { checkstock };
