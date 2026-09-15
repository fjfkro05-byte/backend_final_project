const express = require("express");
const router = express.Router();
const ctrl = require("../controllers/cart.controller");
const { authenticate, authorize } = require("../middleware/auth.middleware");

router.use(authenticate, authorize("customer"));
router.get("/", ctrl.getCart);
router.post("/items", ctrl.addItem);
router.put("/items/:itemId", ctrl.updateItem);
router.delete("/items/:itemId", ctrl.removeItem);

module.exports = router;
