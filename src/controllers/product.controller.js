const prisma = require("../config/prisma");

// GET /api/products?search=&categoryId=&sellerId=&sale=&page=&limit=
async function getAll(req, res, next) {
  try {
    const { search, categoryId, sellerId, sale, page = 1, limit = 40 } = req.query;

    const where = {
      ...(search && { name: { contains: search } }),
      ...(categoryId && { categoryId }),
      ...(sellerId && { sellerId }),
      ...(sale === "1" && { isSale: true }), // รองรับการกรองสินค้าลดราคา
    };

    const take = Number(limit);
    const skip = (Number(page) - 1) * take;

    const [products, total] = await Promise.all([
      prisma.product.findMany({
        where,
        include: { category: true, seller: { select: { shopName: true } } },
        orderBy: { createdAt: "desc" },
        skip,
        take,
      }),
      prisma.product.count({ where }),
    ]);

    // ส่งกลับทั้งแบบ Object และ Array (เพื่อป้องกัน Frontend พังกรณีไม่ได้แก้โค้ดฝั่งหน้าบ้าน)
    res.json({
      data: products,
      pagination: { page: Number(page), limit: take, total, totalPages: Math.ceil(total / take) },
    });
  } catch (err) {
    next(err);
  }
}

// GET /api/products/seller/my-products (ดึงรายการสินค้าเฉพาะของผู้ขายที่ล็อกอิน)
async function getBySeller(req, res, next) {
  try {
    // 1. ค้นหา ID ร้านค้าจาก userId ของผู้ขาย
    const seller = await prisma.seller.findUnique({
      where: { userId: req.user.id },
    });

    if (!seller) {
      return res.status(403).json({ message: "คุณยังไม่ได้ลงทะเบียนเป็นผู้ขาย" });
    }

    // 2. ดึงสินค้าทั้งหมดของร้านค้านี้
    const products = await prisma.product.findMany({
      where: { sellerId: seller.id },
      include: { category: true },
      orderBy: { createdAt: "desc" },
    });

    res.json(products);
  } catch (err) {
    next(err);
  }
}

// GET /api/products/:id
async function getById(req, res, next) {
  try {
    const product = await prisma.product.findUnique({
      where: { id: req.params.id },
      include: {
        category: true,
        seller: { select: { id: true, shopName: true, verified: true } },
        reviews: { include: { customer: { select: { name: true } } }, orderBy: { createdAt: "desc" } },
      },
    });
    if (!product) return res.status(404).json({ message: "ไม่พบสินค้านี้" });
    res.json(product);
  } catch (err) {
    next(err);
  }
}

// POST /api/products (seller)
async function create(req, res, next) {
  try {
    const seller = await prisma.seller.findUnique({ where: { userId: req.user.id } });
    if (!seller) return res.status(403).json({ message: "คุณยังไม่ได้ลงทะเบียนเป็นผู้ขาย" });

    const { name, description, price, stock, imageUrl, categoryId, isSale, originalPrice } = req.body;
    if (!name || price === undefined || !categoryId) {
      return res.status(400).json({ message: "กรุณากรอกข้อมูลสินค้าให้ครบถ้วน" });
    }

    const product = await prisma.product.create({
      data: {
        name,
        description,
        price: Number(price),
        stock: Number(stock ?? 0),
        imageUrl,
        categoryId,
        sellerId: seller.id,
        ...(isSale !== undefined && { isSale: Boolean(isSale) }),
        ...(originalPrice && { originalPrice: Number(originalPrice) }),
      },
    });
    res.status(201).json(product);
  } catch (err) {
    next(err);
  }
}

// PUT /api/products/:id (seller - own product only, or admin)
async function update(req, res, next) {
  try {
    const product = await prisma.product.findUnique({ where: { id: req.params.id }, include: { seller: true } });
    if (!product) return res.status(404).json({ message: "ไม่พบสินค้านี้" });

    if (req.user.role !== "admin" && product.seller.userId !== req.user.id) {
      return res.status(403).json({ message: "คุณไม่มีสิทธิ์แก้ไขสินค้านี้" });
    }

    const { name, description, price, stock, imageUrl, categoryId, isSale, originalPrice } = req.body;
    const updated = await prisma.product.update({
      where: { id: req.params.id },
      data: {
        name,
        description,
        price: price !== undefined ? Number(price) : undefined,
        stock: stock !== undefined ? Number(stock) : undefined,
        imageUrl,
        categoryId,
        ...(isSale !== undefined && { isSale: Boolean(isSale) }),
        ...(originalPrice && { originalPrice: Number(originalPrice) }),
      },
    });
    res.json(updated);
  } catch (err) {
    next(err);
  }
}

// DELETE /api/products/:id (seller - own product only, or admin)
async function remove(req, res, next) {
  try {
    const product = await prisma.product.findUnique({ where: { id: req.params.id }, include: { seller: true } });
    if (!product) return res.status(404).json({ message: "ไม่พบสินค้านี้" });

    if (req.user.role !== "admin" && product.seller.userId !== req.user.id) {
      return res.status(403).json({ message: "คุณไม่มีสิทธิ์ลบสินค้านี้" });
    }

    await prisma.product.delete({ where: { id: req.params.id } });
    res.status(204).send();
  } catch (err) {
    next(err);
  }
}

module.exports = { getAll, getBySeller, getById, create, update, remove };