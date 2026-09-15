const prisma = require("../config/prisma");

// GET /api/sellers/me  (seller's own shop)
async function getMyShop(req, res, next) {
  try {
    const seller = await prisma.seller.findUnique({
      where: { userId: req.user.id },
      include: { products: true },
    });
    if (!seller) return res.status(404).json({ message: "ไม่พบข้อมูลร้านค้า" });
    res.json(seller);
  } catch (err) {
    next(err);
  }
}

// PUT /api/sellers/me  body: { shopName, shopDescription }
async function updateMyShop(req, res, next) {
  try {
    const { shopName, shopDescription } = req.body;
    const seller = await prisma.seller.update({
      where: { userId: req.user.id },
      data: { shopName, shopDescription },
    });
    res.json(seller);
  } catch (err) {
    next(err);
  }
}

// GET /api/sellers  (admin - list all shops, e.g. to approve/suspend)
async function getAll(req, res, next) {
  try {
    const sellers = await prisma.seller.findMany({
      include: { user: { select: { name: true, email: true, createdAt: true } } },
      orderBy: { createdAt: "desc" },
    });
    res.json(sellers);
  } catch (err) {
    next(err);
  }
}

// PUT /api/sellers/:id/verify  body: { verified }  (admin approve/suspend shop)
async function setVerified(req, res, next) {
  try {
    const { verified } = req.body;
    const seller = await prisma.seller.update({
      where: { id: req.params.id },
      data: { verified: Boolean(verified) },
    });
    res.json(seller);
  } catch (err) {
    next(err);
  }
}

module.exports = { getMyShop, updateMyShop, getAll, setVerified };
