const prisma = require("../config/prisma");

// GET /api/categories
async function getAll(req, res, next) {
  try {
    const categories = await prisma.category.findMany({
      orderBy: { name: "asc" },
    });
    res.json(categories);
  } catch (err) {
    next(err);
  }
}

// GET /api/categories/:id
async function getById(req, res, next) {
  try {
    const category = await prisma.category.findUnique({
      where: { id: req.params.id },
    });
    if (!category) return res.status(404).json({ message: "ไม่พบหมวดหมู่นี้" });
    res.json(category);
  } catch (err) {
    next(err);
  }
}

// POST /api/categories (admin)
async function create(req, res, next) {
  try {
    const { name } = req.body;
    if (!name) return res.status(400).json({ message: "กรุณาระบุชื่อหมวดหมู่" });
    const category = await prisma.category.create({ data: { name } });
    res.status(201).json(category);
  } catch (err) {
    if (err.code === "P2002") {
      return res.status(409).json({ message: "หมวดหมู่นี้มีอยู่แล้ว" });
    }
    next(err);
  }
}

// PUT /api/categories/:id (admin)
async function update(req, res, next) {
  try {
    const { name } = req.body;
    const category = await prisma.category.update({
      where: { id: req.params.id },
      data: { name },
    });
    res.json(category);
  } catch (err) {
    next(err);
  }
}

// DELETE /api/categories/:id (admin)
async function remove(req, res, next) {
  try {
    await prisma.category.delete({ where: { id: req.params.id } });
    res.status(204).send();
  } catch (err) {
    next(err);
  }
}

module.exports = { getAll, getById, create, update, remove };
