const { verifyAccessToken } = require("../utils/jwt");

function authenticate(req, res, next) {
  const header = req.headers.authorization;
  if (!header || !header.startsWith("Bearer ")) {
    return res.status(401).json({ message: "ไม่พบ token กรุณาเข้าสู่ระบบ" });
  }
  const token = header.split(" ")[1];
  try {
    const decoded = verifyAccessToken(token);
    req.user = decoded; // { id, role, email }
    next();
  } catch (err) {
    return res.status(401).json({ message: "Token ไม่ถูกต้องหรือหมดอายุ" });
  }
}

function authorize(...allowedRoles) {
  return (req, res, next) => {
    if (!req.user) return res.status(401).json({ message: "กรุณาเข้าสู่ระบบ" });
    if (!allowedRoles.includes(req.user.role)) {
      return res.status(403).json({ message: "คุณไม่มีสิทธิ์เข้าถึงส่วนนี้" });
    }
    next();
  };
}

module.exports = { authenticate, authorize };
