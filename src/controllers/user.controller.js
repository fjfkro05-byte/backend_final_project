const prisma = require("../config/prisma");

// GET /api/users (admin - manage all users)
async function getAll(req, res, next) {
  try {
    const users = await prisma.user.findMany({
      select: { id: true, name: true, email: true, role: true, createdAt: true },
      orderBy: { createdAt: "desc" },
    });
    res.json(users);
  } catch (err) {
    next(err);
  }
}

// GET /api/users/admin/overview (admin - sales overview)
async function overview(req, res, next) {
  try {
    const [userCount, sellerCount, productCount, orderCount, revenue] = await Promise.all([
      prisma.user.count(),
      prisma.seller.count(),
      prisma.product.count(),
      prisma.order.count(),
      prisma.payment.aggregate({ _sum: { amount: true }, where: { status: "success" } }),
    ]);
    res.json({
      userCount,
      sellerCount,
      productCount,
      orderCount,
      totalRevenue: revenue._sum.amount || 0,
    });
  } catch (err) {
    next(err);
  }
}

// DELETE /api/users/:id (admin)
async function remove(req, res, next) {
  try {
    await prisma.user.delete({ where: { id: req.params.id } });
    res.status(204).send();
  } catch (err) {
    next(err);
  }
}

// -- addresses (self-service, any authenticated user) --

// GET /api/users/me/addresses
async function getMyAddresses(req, res, next) {
  try {
    const addresses = await prisma.address.findMany({ where: { userId: req.user.id } });
    res.json(addresses);
  } catch (err) {
    next(err);
  }
}

// POST /api/users/me/addresses  body: { addressLine, city, postalCode, isDefault }
async function addAddress(req, res, next) {
  try {
    const { addressLine, city, postalCode, isDefault } = req.body;
    if (!addressLine || !city || !postalCode) {
      return res.status(400).json({ message: "กรุณากรอกที่อยู่ให้ครบถ้วน" });
    }
    const address = await prisma.address.create({
      data: { userId: req.user.id, addressLine, city, postalCode, isDefault: Boolean(isDefault) },
    });
    res.status(201).json(address);
  } catch (err) {
    next(err);
  }
}

module.exports = { getAll, overview, remove, getMyAddresses, addAddress };
