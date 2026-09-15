const bcrypt = require("bcryptjs");
const prisma = require("../config/prisma");
const {
  signAccessToken,
  signRefreshToken,
  verifyRefreshToken,
} = require("../utils/jwt");

// POST /api/auth/register
// body: { name, email, password, role? ('customer' | 'seller'), shopName? }
async function register(req, res, next) {
  try {
    const { name, email, password, role, shopName } = req.body;
    if (!name || !email || !password) {
      return res.status(400).json({ message: "กรุณากรอกข้อมูลให้ครบถ้วน" });
    }

    const existing = await prisma.user.findUnique({ where: { email } });
    if (existing) {
      return res.status(409).json({ message: "อีเมลนี้ถูกใช้งานแล้ว" });
    }

    const passwordHash = await bcrypt.hash(password, 10);
    const finalRole = role === "seller" ? "seller" : "customer";

    const user = await prisma.user.create({
      data: {
        name,
        email,
        passwordHash,
        role: finalRole,
        cart: { create: {} },
        ...(finalRole === "seller"
          ? {
              seller: {
                create: {
                  shopName: shopName || `${name}'s Shop`,
                },
              },
            }
          : {}),
      },
    });

    const payload = { id: user.id, role: user.role, email: user.email };
    const accessToken = signAccessToken(payload);
    const refreshToken = signRefreshToken(payload);

    res.status(201).json({
      user: { id: user.id, name: user.name, email: user.email, role: user.role },
      accessToken,
      refreshToken,
    });
  } catch (err) {
    next(err);
  }
}

// POST /api/auth/login
async function login(req, res, next) {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ message: "กรุณากรอกอีเมลและรหัสผ่าน" });
    }

    const user = await prisma.user.findUnique({ where: { email } });
    if (!user) {
      return res.status(401).json({ message: "อีเมลหรือรหัสผ่านไม่ถูกต้อง" });
    }

    const match = await bcrypt.compare(password, user.passwordHash);
    if (!match) {
      return res.status(401).json({ message: "อีเมลหรือรหัสผ่านไม่ถูกต้อง" });
    }

    const payload = { id: user.id, role: user.role, email: user.email };
    const accessToken = signAccessToken(payload);
    const refreshToken = signRefreshToken(payload);

    res.json({
      user: { id: user.id, name: user.name, email: user.email, role: user.role },
      accessToken,
      refreshToken,
    });
  } catch (err) {
    next(err);
  }
}

// POST /api/auth/refresh
async function refresh(req, res, next) {
  try {
    const { refreshToken } = req.body;
    if (!refreshToken) {
      return res.status(400).json({ message: "ไม่พบ refresh token" });
    }
    const decoded = verifyRefreshToken(refreshToken);
    const payload = { id: decoded.id, role: decoded.role, email: decoded.email };
    const accessToken = signAccessToken(payload);
    res.json({ accessToken });
  } catch (err) {
    return res.status(401).json({ message: "Refresh token ไม่ถูกต้องหรือหมดอายุ" });
  }
}

// GET /api/auth/me
async function me(req, res, next) {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user.id },
      select: { id: true, name: true, email: true, role: true, createdAt: true },
    });
    res.json(user);
  } catch (err) {
    next(err);
  }
}

module.exports = { register, login, refresh, me };
