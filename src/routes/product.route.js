const express = require("express");
const router = express.Router();
const ctrl = require("../controllers/product.controller");
const { authenticate, authorize } = require("../middleware/auth.middleware");

router.get("/", ctrl.getAll);

router.get("/seller/my-products", authenticate, authorize("seller"), ctrl.getBySeller);


router.get("/:id", ctrl.getById);


router.post("/", authenticate, authorize("seller"), ctrl.create);


router.put("/:id", authenticate, authorize("seller", "admin"), ctrl.update);


router.delete("/:id", authenticate, authorize("seller", "admin"), ctrl.remove);

module.exports = router;