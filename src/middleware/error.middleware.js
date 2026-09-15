function notFound(req, res, next) {
  res.status(404).json({ message: "ไม่พบ endpoint ที่ร้องขอ" });
}

function errorHandler(err, req, res, next) {
  console.error(err);
  const status = err.statusCode || 500;
  res.status(status).json({ message: err.message || "เกิดข้อผิดพลาดในระบบ" });
}

module.exports = { notFound, errorHandler };
