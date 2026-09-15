const prisma = require("../config/prisma");

async function getOrCreateCart(customerId) {
  let cart = await prisma.cart.findUnique({ where: { customerId } });
  if (!cart) cart = await prisma.cart.create({ data: { customerId } });
  return cart;
}

// GET /api/cart
async function getCart(req, res, next) {
  try {
    const cart = await getOrCreateCart(req.user.id);
    const items = await prisma.cartItem.findMany({
      where: { cartId: cart.id },
      include: { product: true },
    });
    const total = items.reduce((sum, i) => sum + Number(i.product.price) * i.quantity, 0);
    res.json({ id: cart.id, items, total });
  } catch (err) {
    next(err);
  }
}

// POST /api/cart/items  body: { productId, quantity }
async function addItem(req, res, next) {
  try {
    const { productId, quantity = 1 } = req.body;
    if (!productId) return res.status(400).json({ message: "กรุณาระบุสินค้า" });

    const product = await prisma.product.findUnique({ where: { id: productId } });
    if (!product) return res.status(404).json({ message: "ไม่พบสินค้านี้" });
    if (product.stock < quantity) {
      return res.status(400).json({ message: "สินค้าในสต๊อกไม่เพียงพอ" });
    }

    const cart = await getOrCreateCart(req.user.id);

    const item = await prisma.cartItem.upsert({
      where: { cartId_productId: { cartId: cart.id, productId } },
      update: { quantity: { increment: quantity } },
      create: { cartId: cart.id, productId, quantity },
    });
    res.status(201).json(item);
  } catch (err) {
    next(err);
  }
}

// PUT /api/cart/items/:itemId  body: { quantity }
async function updateItem(req, res, next) {
  try {
    const { quantity } = req.body;
    if (!quantity || quantity < 1) {
      return res.status(400).json({ message: "จำนวนสินค้าต้องมากกว่า 0" });
    }
    const item = await prisma.cartItem.update({
      where: { id: req.params.itemId },
      data: { quantity },
    });
    res.json(item);
  } catch (err) {
    next(err);
  }
}

// DELETE /api/cart/items/:itemId
async function removeItem(req, res, next) {
  try {
    await prisma.cartItem.delete({ where: { id: req.params.itemId } });
    res.status(204).send();
  } catch (err) {
    next(err);
  }
}

module.exports = { getCart, addItem, updateItem, removeItem };
