const express = require("express");
const router = express.Router();
const ctrl = require("../controllers/review.controller");
const { authenticate, authorize } = require("../middleware/auth.middleware");

router.get("/product/:productId", ctrl.getByProduct);
router.post("/", authenticate, authorize("customer"), ctrl.create);
router.delete("/:id", authenticate, ctrl.remove);

module.exports = router;
