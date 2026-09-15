const express = require("express");
const cors = require("cors");
require("dotenv").config();

const authRoutes = require("./src/routes/auth.route");
const productRoutes = require("./src/routes/product.route");
const categoryRoutes = require("./src/routes/category.route");
const cartRoutes = require("./src/routes/cart.route");
const orderRoutes = require("./src/routes/order.route");
const paymentRoutes = require("./src/routes/payment.route");
const reviewRoutes = require("./src/routes/review.route");
const sellerRoutes = require("./src/routes/seller.route");
const userRoutes = require("./src/routes/user.route");
const { notFound, errorHandler } = require("./src/middleware/error.middleware");

const app = express();
const PORT = process.env.PORT || 4000;

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.json({ message: "API is running" });
});

app.use("/api/auth", authRoutes);
app.use("/api/products", productRoutes);
app.use("/api/categories", categoryRoutes);
app.use("/api/cart", cartRoutes);
app.use("/api/orders", orderRoutes);
app.use("/api/payments", paymentRoutes);
app.use("/api/reviews", reviewRoutes);
app.use("/api/sellers", sellerRoutes);
app.use("/api/users", userRoutes);

app.use(notFound);
app.use(errorHandler);

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});