const express = require("express");
const router = express.Router();
const ctrl = require("../controllers/seller.controller");
const { authenticate, authorize } = require("../middleware/auth.middleware");

router.get("/me", authenticate, authorize("seller"), ctrl.getMyShop);
router.put("/me", authenticate, authorize("seller"), ctrl.updateMyShop);
router.get("/", authenticate, authorize("admin"), ctrl.getAll);
router.put("/:id/verify", authenticate, authorize("admin"), ctrl.setVerified);

module.exports = router;
