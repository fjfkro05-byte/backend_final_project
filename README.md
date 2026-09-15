# Backend — ระบบร้านค้าออนไลน์ (E-commerce API)

Node.js (Express) + Prisma + MySQL (XAMPP), JWT auth with role-based access control
(customer / seller / admin), matching the ER diagram in the project proposal.

## Setup (ใช้ XAMPP)

1. เปิด **XAMPP Control Panel** แล้วกด Start ที่ปุ่ม **MySQL** (ไม่ต้อง start Apache ก็ได้ เพราะ backend นี้รันด้วย Node.js เอง ไม่ใช่ PHP)
2. เปิด **phpMyAdmin** (http://localhost/phpmyadmin) แล้วสร้างฐานข้อมูลเปล่าๆ ชื่อ `ecommerce_db` (แท็บ "Databases" → พิมพ์ชื่อ → Create) — สร้างแค่ฐานข้อมูลเปล่า ไม่ต้องสร้างตารางเอง
3. ตั้งค่าไฟล์ `.env`:

```bash
npm install
cp .env.example .env
```

แก้ `DATABASE_URL` ใน `.env` ให้ตรงกับ MySQL ของ XAMPP (ปกติ user คือ `root` และไม่มี password):

```
DATABASE_URL="mysql://root:@localhost:3306/ecommerce_db"
```

4. ให้ Prisma สร้างตารางทั้งหมดในฐานข้อมูลอัตโนมัติ (ไปดูผลลัพธ์ได้ใน phpMyAdmin ทันที):

```bash
npx prisma migrate dev --name init
npm run seed               # optional: สร้าง account ทดสอบ admin/seller/customer
npm start                  # รันที่ http://localhost:4000
```

Test accounts after seeding (password: `password123`):
- admin@shop.com
- seller@shop.com
- customer@shop.com

## Structure

```
prisma/schema.prisma       Users, Sellers, Addresses, Categories, Products,
                            Carts/CartItems, Orders/OrderItems, Payments, Reviews
src/config/prisma.js        Prisma client singleton
src/utils/jwt.js            access/refresh token sign & verify
src/middleware/auth.middleware.js   authenticate() + authorize(...roles)
src/controllers/*           business logic per entity
src/routes/*                Express routers, mounted in server.js
```

## API overview

| Area       | Routes                                                        | Roles |
|------------|----------------------------------------------------------------|-------|
| Auth       | POST /api/auth/register, /login, /refresh, GET /me             | public |
| Products   | GET /api/products (search/filter/paginate), GET /:id, POST/PUT/DELETE | seller (own), admin |
| Categories | GET /api/categories                                             | public read, admin write |
| Cart       | GET/POST/PUT/DELETE /api/cart...                                | customer |
| Orders     | POST /api/orders (checkout, transactional stock deduction), GET | customer / seller / admin |
| Payments   | POST /api/payments (mock gateway → marks order paid)            | customer |
| Reviews    | GET /api/reviews/product/:id, POST (only if purchased)          | customer |
| Sellers    | GET/PUT /api/sellers/me, GET /api/sellers, PUT /:id/verify      | seller / admin |
| Users      | GET /api/users, /api/users/admin/overview, addresses            | admin / self |

Checkout (`POST /api/orders`) runs inside a single Prisma `$transaction` so stock
deduction, order/order-item creation, and cart clearing stay ACID-consistent —
matching the ACID requirement called out in section 3.1 of the proposal.
