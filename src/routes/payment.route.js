const express = require("express");
const router = express.Router();
const ctrl = require("../controllers/payment.controller");
const { authenticate, authorize } = require("../middleware/auth.middleware");

router.use(authenticate);
router.post("/", authorize("customer"), ctrl.pay);
router.get("/:orderId", ctrl.getByOrder);

module.exports = router;
