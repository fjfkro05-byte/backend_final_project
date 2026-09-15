const { PrismaClient } = require("@prisma/client");
const bcrypt = require("bcryptjs");

const prisma = new PrismaClient();

// Keep these `name` values in sync with frontend/src/data/teams.js
const TEAMS = [
  { name: "บุรีรัมย์ ยูไนเต็ด", shop: "Buriram United Official Store" },
  { name: "บางกอก ยูไนเต็ด", shop: "Bangkok United Official Store" },
  { name: "บีจี ปทุม ยูไนเต็ด", shop: "BG Pathum United Official Store" },
  { name: "เมืองทอง ยูไนเต็ด", shop: "Muangthong United Official Store" },
  { name: "การท่าเรือ เอฟซี", shop: "Port FC Official Store" },
  { name: "ชลบุรี เอฟซี", shop: "Chonburi FC Official Store" },
  { name: "ทรู แบงค็อก ยูไนเต็ด", shop: "True Bangkok United Official Store" },
  { name: "เชียงราย ยูไนเต็ด", shop: "Chiangrai United Official Store" },
  { name: "ราชบุรี มิตรผล เอฟซี", shop: "Ratchaburi FC Official Store" },
  { name: "นครราชสีมา มาสด้า เอฟซี", shop: "Korat FC Official Store" },
];

const PRODUCT_TEMPLATES = [
  { suffix: "เสื้อแข่งทีมเหย้า 2026", price: 1590, originalPrice: 1890, isSale: true, stock: 40 },
  { suffix: "เสื้อแข่งทีมเยือน 2026", price: 1590, originalPrice: null, isSale: false, stock: 35 },
  { suffix: "หมวกแก๊ปทีม", price: 390, originalPrice: 490, isSale: true, stock: 60 },
  { suffix: "ผ้าพันคอเชียร์", price: 350, originalPrice: null, isSale: false, stock: 80 },
];

async function main() {
  const passwordHash = await bcrypt.hash("password123", 10);

  // 1. Admin Account
  await prisma.user.upsert({
    where: { email: "admin@shop.com" },
    update: {},
    create: { name: "Admin", email: "admin@shop.com", passwordHash, role: "admin" },
  });

  // 2. Customer Account
  const customerUser = await prisma.user.upsert({
    where: { email: "customer@shop.com" },
    update: {},
    create: {
      name: "Customer One",
      email: "customer@shop.com",
      passwordHash,
      role: "customer",
    },
  });

  // สร้าง Cart ให้ Customer หากยังไม่มี
  await prisma.cart.upsert({
    where: { customerId: customerUser.id },
    update: {},
    create: { customerId: customerUser.id },
  });

  // 3. Seller Accounts, Categories, and Products
  let sellerIndex = 1;
  for (const team of TEAMS) {
    // Category (ใช้ upsert ป้องกัน Category ซ้ำ)
    const category = await prisma.category.upsert({
      where: { name: team.name },
      update: {},
      create: { name: team.name },
    });

    const sellerEmail = `seller${sellerIndex}@shop.com`;

    // Seller User
    let sellerUser = await prisma.user.findUnique({
      where: { email: sellerEmail },
      include: { seller: true },
    });

    if (!sellerUser) {
      sellerUser = await prisma.user.create({
        data: {
          name: `${team.shop} Manager`,
          email: sellerEmail,
          passwordHash,
          role: "seller",
          seller: { create: { shopName: team.shop, verified: true } },
        },
        include: { seller: true },
      });
    }

    // Products
    for (const tpl of PRODUCT_TEMPLATES) {
      const productName = `${team.name} ${tpl.suffix}`;
      
      // ค้นหาสินค้าเดิมถ้ามีอยู่แล้ว
      const existingProduct = await prisma.product.findFirst({
        where: { name: productName, sellerId: sellerUser.seller.id },
      });

      if (!existingProduct) {
        await prisma.product.create({
          data: {
            name: productName,
            description: `สินค้าลิขสิทธิ์แฟนคลับ ${team.name}`,
            price: tpl.price,
            originalPrice: tpl.originalPrice,
            isSale: tpl.isSale,
            stock: tpl.stock,
            categoryId: category.id,
            sellerId: sellerUser.seller.id,
          },
        });
      }
    }

    sellerIndex += 1;
  }

  console.log("Seed complete. Test accounts (password: password123):");
  console.log("- admin@shop.com");
  console.log("- seller1@shop.com ... seller10@shop.com (one per team, in team order below)");
  TEAMS.forEach((t, i) => console.log(`  seller${i + 1}@shop.com -> ${t.shop}`));
  console.log("- customer@shop.com");
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });