const prisma = require("../config/prisma");

// GET /api/reviews/product/:productId
async function getByProduct(req, res, next) {
  try {
    const reviews = await prisma.review.findMany({
      where: { productId: req.params.productId },
      include: { customer: { select: { name: true } } },
      orderBy: { createdAt: "desc" },
    });
    res.json(reviews);
  } catch (err) {
    next(err);
  }
}

// POST /api/reviews  body: { productId, rating, comment }
// Only customers who purchased the product (order item exists) may review.
async function create(req, res, next) {
  try {
    const { productId, rating, comment } = req.body;
    if (!productId || !rating || rating < 1 || rating > 5) {
      return res.status(400).json({ message: "กรุณาระบุคะแนน 1-5 และสินค้าให้ถูกต้อง" });
    }

    const purchased = await prisma.orderItem.findFirst({
      where: { productId, order: { customerId: req.user.id, status: { in: ["paid", "shipped", "completed"] } } },
    });
    if (!purchased) {
      return res.status(403).json({ message: "คุณต้องซื้อสินค้านี้ก่อนจึงจะรีวิวได้" });
    }

    const review = await prisma.review.create({
      data: { productId, customerId: req.user.id, rating, comment },
    });
    res.status(201).json(review);
  } catch (err) {
    next(err);
  }
}

// DELETE /api/reviews/:id (own review, or admin)
async function remove(req, res, next) {
  try {
    const review = await prisma.review.findUnique({ where: { id: req.params.id } });
    if (!review) return res.status(404).json({ message: "ไม่พบรีวิวนี้" });
    if (req.user.role !== "admin" && review.customerId !== req.user.id) {
      return res.status(403).json({ message: "คุณไม่มีสิทธิ์ลบรีวิวนี้" });
    }
    await prisma.review.delete({ where: { id: req.params.id } });
    res.status(204).send();
  } catch (err) {
    next(err);
  }
}

module.exports = { getByProduct, create, remove };
