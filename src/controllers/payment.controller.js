const prisma = require("../config/prisma");

// POST /api/payments  body: { orderId, method }
async function pay(req, res, next) {
  try {
    const { orderId, method } = req.body;
    if (!orderId || !method) {
      return res.status(400).json({ message: "กรุณาระบุคำสั่งซื้อและวิธีชำระเงิน" });
    }

    const order = await prisma.order.findUnique({ where: { id: orderId } });
    if (!order) return res.status(404).json({ message: "ไม่พบคำสั่งซื้อนี้" });
    if (order.customerId !== req.user.id) {
      return res.status(403).json({ message: "คุณไม่มีสิทธิ์ชำระเงินคำสั่งซื้อนี้" });
    }

    const payment = await prisma.$transaction(async (tx) => {
      const p = await tx.payment.create({
        data: {
          orderId,
          method,
          amount: order.totalAmount,
          status: "success", // mock payment gateway: instantly succeeds
          paidAt: new Date(),
        },
      });
      await tx.order.update({ where: { id: orderId }, data: { status: "paid" } });
      return p;
    });

    res.status(201).json(payment);
  } catch (err) {
    if (err.code === "P2002") {
      return res.status(409).json({ message: "คำสั่งซื้อนี้ถูกชำระเงินแล้ว" });
    }
    next(err);
  }
}

// GET /api/payments/:orderId
async function getByOrder(req, res, next) {
  try {
    const payment = await prisma.payment.findUnique({ where: { orderId: req.params.orderId } });
    if (!payment) return res.status(404).json({ message: "ไม่พบข้อมูลการชำระเงิน" });
    res.json(payment);
  } catch (err) {
    next(err);
  }
}

module.exports = { pay, getByOrder };
