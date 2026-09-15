const prisma = require("../config/prisma");

// POST /api/orders  body: { addressId }
// Checkout: turns cart into an order. Uses a transaction for ACID
// correctness across stock deduction, order creation, and cart clearing.
async function checkout(req, res, next) {
  try {
    const { addressId } = req.body;
    if (!addressId) return res.status(400).json({ message: "กรุณาเลือกที่อยู่จัดส่ง" });

    const address = await prisma.address.findUnique({ where: { id: addressId } });
    if (!address || address.userId !== req.user.id) {
      return res.status(400).json({ message: "ที่อยู่จัดส่งไม่ถูกต้อง" });
    }

    const cart = await prisma.cart.findUnique({
      where: { customerId: req.user.id },
      include: { items: { include: { product: true } } },
    });
    if (!cart || cart.items.length === 0) {
      return res.status(400).json({ message: "ตะกร้าสินค้าว่างเปล่า" });
    }

    const order = await prisma.$transaction(async (tx) => {
      for (const item of cart.items) {
        if (item.product.stock < item.quantity) {
          throw Object.assign(new Error(`สินค้า "${item.product.name}" มีไม่เพียงพอในสต๊อก`), {
            statusCode: 400,
          });
        }
      }

      const totalAmount = cart.items.reduce(
        (sum, i) => sum + Number(i.product.price) * i.quantity,
        0
      );

      const newOrder = await tx.order.create({
        data: {
          customerId: req.user.id,
          addressId,
          totalAmount,
          status: "pending",
          items: {
            create: cart.items.map((i) => ({
              productId: i.productId,
              quantity: i.quantity,
              price: i.product.price,
            })),
          },
        },
        include: { items: true },
      });

      for (const item of cart.items) {
        await tx.product.update({
          where: { id: item.productId },
          data: { stock: { decrement: item.quantity } },
        });
      }

      await tx.cartItem.deleteMany({ where: { cartId: cart.id } });

      return newOrder;
    });

    res.status(201).json(order);
  } catch (err) {
    next(err);
  }
}

// GET /api/orders (own orders for customer, seller sees orders containing their products, admin sees all)
async function getAll(req, res, next) {
  try {
    let where = {};
    if (req.user.role === "customer") {
      where = { customerId: req.user.id };
    } else if (req.user.role === "seller") {
      const seller = await prisma.seller.findUnique({ where: { userId: req.user.id } });
      where = { items: { some: { product: { sellerId: seller?.id } } } };
    }
    // admin: no filter, sees all

    const orders = await prisma.order.findMany({
      where,
      include: { items: { include: { product: true } }, payment: true, address: true },
      orderBy: { createdAt: "desc" },
    });
    res.json(orders);
  } catch (err) {
    next(err);
  }
}

// GET /api/orders/:id
async function getById(req, res, next) {
  try {
    const order = await prisma.order.findUnique({
      where: { id: req.params.id },
      include: { items: { include: { product: true } }, payment: true, address: true, customer: { select: { name: true, email: true } } },
    });
    if (!order) return res.status(404).json({ message: "ไม่พบคำสั่งซื้อนี้" });

    if (req.user.role === "customer" && order.customerId !== req.user.id) {
      return res.status(403).json({ message: "คุณไม่มีสิทธิ์ดูคำสั่งซื้อนี้" });
    }
    res.json(order);
  } catch (err) {
    next(err);
  }
}

// PUT /api/orders/:id/status  body: { status }  (seller updates shipping status, admin any)
async function updateStatus(req, res, next) {
  try {
    const { status } = req.body;
    const allowed = ["pending", "paid", "shipped", "completed", "cancelled"];
    if (!allowed.includes(status)) {
      return res.status(400).json({ message: "สถานะไม่ถูกต้อง" });
    }
    const order = await prisma.order.update({
      where: { id: req.params.id },
      data: { status },
    });
    res.json(order);
  } catch (err) {
    next(err);
  }
}

module.exports = { checkout, getAll, getById, updateStatus };
