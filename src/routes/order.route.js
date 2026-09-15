const express = require("express");
const router = express.Router();
const ctrl = require("../controllers/order.controller");
const { authenticate, authorize } = require("../middleware/auth.middleware");

router.use(authenticate);
router.post("/", authorize("customer"), ctrl.checkout);
router.get("/", ctrl.getAll);
router.get("/:id", ctrl.getById);
router.put("/:id/status", authorize("seller", "admin"), ctrl.updateStatus);

module.exports = router;
