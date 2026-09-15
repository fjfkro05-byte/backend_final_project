const express = require("express");
const router = express.Router();
const ctrl = require("../controllers/user.controller");
const { authenticate, authorize } = require("../middleware/auth.middleware");

router.get("/me/addresses", authenticate, ctrl.getMyAddresses);
router.post("/me/addresses", authenticate, ctrl.addAddress);

router.get("/", authenticate, authorize("admin"), ctrl.getAll);
router.get("/admin/overview", authenticate, authorize("admin"), ctrl.overview);
router.delete("/:id", authenticate, authorize("admin"), ctrl.remove);

module.exports = router;
