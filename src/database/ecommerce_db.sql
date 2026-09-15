-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 15, 2026 at 04:53 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ecommerce_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `id` varchar(191) NOT NULL,
  `user_id` varchar(191) NOT NULL,
  `address_line` varchar(191) NOT NULL,
  `city` varchar(191) NOT NULL,
  `postal_code` varchar(191) NOT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `carts`
--

CREATE TABLE `carts` (
  `id` varchar(191) NOT NULL,
  `customer_id` varchar(191) NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `carts`
--

INSERT INTO `carts` (`id`, `customer_id`, `created_at`) VALUES
('c04c2e9d-7896-45bd-b2fc-752c1380fb55', 'ec9c9223-285b-4c50-a6a5-48f587a5111b', '2026-09-08 03:28:54.037');

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

CREATE TABLE `cart_items` (
  `id` varchar(191) NOT NULL,
  `cart_id` varchar(191) NOT NULL,
  `product_id` varchar(191) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cart_items`
--

INSERT INTO `cart_items` (`id`, `cart_id`, `product_id`, `quantity`) VALUES
('8db883fe-26ed-4b28-bd22-a86644e81002', 'c04c2e9d-7896-45bd-b2fc-752c1380fb55', '16d2a07e-44b2-4bf7-bba2-23825f149f04', 6);

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `created_at`) VALUES
('017c1e28-9b93-42f6-9e17-d332d7994933', 'ราชบุรี มิตรผล เอฟซี', '2026-09-08 03:28:56.227'),
('11594323-0a40-4e1b-a034-1b7b06f51ad2', 'บุรีรัมย์ ยูไนเต็ด', '2026-09-08 03:28:54.170'),
('16614a07-5bb3-4460-bbf7-02158cbc7133', 'ชลบุรี เอฟซี', '2026-09-08 03:28:55.612'),
('464d52d6-f4d8-437e-b3c8-1d50ded35882', 'การท่าเรือ เอฟซี', '2026-09-08 03:28:55.428'),
('5a49cd89-3df1-4019-bb70-c9d007bb8e43', 'เมืองทอง ยูไนเต็ด', '2026-09-08 03:28:55.227'),
('818815d4-e9c1-42a3-889d-98849b015327', 'บีจี ปทุม ยูไนเต็ด', '2026-09-08 03:28:55.019'),
('88b140d8-904d-4a9b-b6e0-f663f29da063', 'นครราชสีมา มาสด้า เอฟซี', '2026-09-08 03:28:56.395'),
('bf5e955a-0c92-4db1-ae74-a60c6c6596cc', 'เชียงราย ยูไนเต็ด', '2026-09-08 03:28:56.021'),
('df7b2021-78e3-4d8c-ac0e-6b17dcdbb3ae', 'ทรู แบงค็อก ยูไนเต็ด', '2026-09-08 03:28:55.846'),
('e7501fbb-57b9-4bf0-86e7-a5525167810e', 'บางกอก ยูไนเต็ด', '2026-09-08 03:28:54.511');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` varchar(191) NOT NULL,
  `customer_id` varchar(191) NOT NULL,
  `address_id` varchar(191) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('pending','paid','shipped','completed','cancelled') NOT NULL DEFAULT 'pending',
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` varchar(191) NOT NULL,
  `order_id` varchar(191) NOT NULL,
  `product_id` varchar(191) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` varchar(191) NOT NULL,
  `order_id` varchar(191) NOT NULL,
  `method` varchar(191) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `status` enum('pending','success','failed','refunded') NOT NULL DEFAULT 'pending',
  `paid_at` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` varchar(191) NOT NULL,
  `seller_id` varchar(191) NOT NULL,
  `category_id` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` varchar(191) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `image_url` varchar(191) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `is_sale` tinyint(1) NOT NULL DEFAULT 0,
  `original_price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `seller_id`, `category_id`, `name`, `description`, `price`, `stock`, `image_url`, `created_at`, `is_sale`, `original_price`) VALUES
('00b416b1-d953-4d84-8cd0-4872d59aa73f', '99b4229c-b6bf-4791-b865-fd579683abb4', '818815d4-e9c1-42a3-889d-98849b015327', 'บีจี ปทุม ยูไนเต็ด เสื้อแข่งทีมเหย้า 2026', 'สินค้าลิขสิทธิ์แฟนคลับ บีจี ปทุม ยูไนเต็ด', 1590.00, 40, 'https://down-th.img.susercontent.com/file/th-11134207-7r98o-lkq8x6vtpof2d7', '2026-09-08 03:28:55.069', 0, NULL),
('07527437-89b8-4d73-b9f9-5656190e0613', '9347423b-fa12-4088-9aba-2860cace071f', '16614a07-5bb3-4460-bbf7-02158cbc7133', 'ชลบุรี เอฟซี เสื้อแข่งทีมเหย้า 2026', 'สินค้าลิขสิทธิ์แฟนคลับ ชลบุรี เอฟซี', 1590.00, 40, 'https://down-th.img.susercontent.com/file/br-11134275-81z1k-mep7al1402df70', '2026-09-08 03:28:55.729', 0, NULL),
('09a5f519-fca7-49fd-8ebc-676a6c0d1245', 'a395a0cc-1cee-4eca-90a5-07c7c9d8de79', '88b140d8-904d-4a9b-b6e0-f663f29da063', 'นครราชสีมา มาสด้า เอฟซี หมวกแก๊ปทีม', 'สินค้าลิขสิทธิ์แฟนคลับ นครราชสีมา มาสด้า เอฟซี', 490.00, 60, 'https://i.ebayimg.com/images/g/BTwAAOSwu5hiTt0L/s-l1600.jpg', '2026-09-08 03:28:56.495', 0, NULL),
('0db8baee-22f7-4f50-8772-0e5a00151d93', 'e842795f-ec2f-4195-a5dd-eea948c6a934', '11594323-0a40-4e1b-a034-1b7b06f51ad2', 'บุรีรัมย์ ยูไนเต็ด หมวกแก๊ปทีม', 'สินค้าลิขสิทธิ์แฟนคลับ บุรีรัมย์ ยูไนเต็ด', 390.00, 60, NULL, '2026-09-15 02:45:58.495', 1, 490.00),
('139dba8f-737a-4556-a5aa-f9068db8d258', '5bbbea5b-2e32-4177-b44c-876f8388df2a', '5a49cd89-3df1-4019-bb70-c9d007bb8e43', 'เมืองทอง ยูไนเต็ด หมวกแก๊ปทีม', 'สินค้าลิขสิทธิ์แฟนคลับ เมืองทอง ยูไนเต็ด', 490.00, 60, 'https://tse1.mm.bing.net/th/id/OIP.pTW0k0NPYVyPt4yq_aNVQAHaHa?r=0&w=1600&h=1600&rs=1&pid=ImgDetMain&o=7&rm=3', '2026-09-08 03:28:55.370', 0, NULL),
('13b99b3c-c98e-4114-8cfa-e42159855e59', '66a0e55f-a4c1-4f9a-980c-c5213e92076c', 'bf5e955a-0c92-4db1-ae74-a60c6c6596cc', 'เชียงราย ยูไนเต็ด หมวกแก๊ปทีม', 'สินค้าลิขสิทธิ์แฟนคลับ เชียงราย ยูไนเต็ด', 80.00, 60, 'https://tse1.mm.bing.net/th/id/OIP.vnI-QxrRTnyBC7LHkz4iSgHaHa?r=0&rs=1&pid=ImgDetMain&o=7&rm=3', '2026-09-08 03:28:56.138', 1, NULL),
('16d2a07e-44b2-4bf7-bba2-23825f149f04', 'a395a0cc-1cee-4eca-90a5-07c7c9d8de79', '88b140d8-904d-4a9b-b6e0-f663f29da063', 'นครราชสีมา มาสด้า เอฟซี ผ้าพันคอเชียร์', 'สินค้าลิขสิทธิ์แฟนคลับ นครราชสีมา มาสด้า เอฟซี', 350.00, 80, 'https://www.portmelbournefc.com.au/wp-content/uploads/2023/08/Purple-scarf-scaled.jpg', '2026-09-08 03:28:56.512', 0, NULL),
('2564192f-8c9b-4181-952e-98fe5a51f9f4', '64b3ff2f-6968-4990-8cb8-f352378f36db', 'df7b2021-78e3-4d8c-ac0e-6b17dcdbb3ae', 'ทรู แบงค็อก ยูไนเต็ด เสื้อแข่งทีมเหย้า 2026', 'สินค้าลิขสิทธิ์แฟนคลับ ทรู แบงค็อก ยูไนเต็ด', 1590.00, 40, 'https://tse3.mm.bing.net/th/id/OIP.VcnDo5xxjv0PROxboekS4AHaJv?r=0&rs=1&pid=ImgDetMain&o=7&rm=3', '2026-09-08 03:28:55.905', 0, NULL),
('2e46a357-96ca-42e1-b5cb-12d5729c22d3', '660ddd7d-f779-4e96-8563-0a7b98078f75', '017c1e28-9b93-42f6-9e17-d332d7994933', 'ราชบุรี มิตรผล เอฟซี ผ้าพันคอเชียร์', 'สินค้าลิขสิทธิ์แฟนคลับ ราชบุรี มิตรผล เอฟซี', 350.00, 80, 'https://down-th.img.susercontent.com/file/th-11134207-7ras8-ma3pusza756621', '2026-09-08 03:28:56.371', 0, NULL),
('31e7e266-8365-4f40-90e0-5d77d48e1843', '660ddd7d-f779-4e96-8563-0a7b98078f75', '017c1e28-9b93-42f6-9e17-d332d7994933', 'ราชบุรี มิตรผล เอฟซี เสื้อแข่งทีมเยือน 2026', 'สินค้าลิขสิทธิ์แฟนคลับ ราชบุรี มิตรผล เอฟซี', 1590.00, 35, 'https://img.lazcdn.com/g/ff/kf/Sa82b5de88469464fad94cad739e8496d2.jpg_720x720q80.jpg', '2026-09-08 03:28:56.313', 1, NULL),
('3b886027-6f11-4923-93d4-8370048ccbf3', 'a395a0cc-1cee-4eca-90a5-07c7c9d8de79', '88b140d8-904d-4a9b-b6e0-f663f29da063', 'นครราชสีมา มาสด้า เอฟซี เสื้อแข่งทีมเยือน 2026', 'สินค้าลิขสิทธิ์แฟนคลับ นครราชสีมา มาสด้า เอฟซี', 1590.00, 35, 'https://tse4.mm.bing.net/th/id/OIP.InbUZxWrqVfkge5lpq6FkwHaIX?r=0&rs=1&pid=ImgDetMain&o=7&rm=3', '2026-09-08 03:28:56.470', 0, NULL),
('406d7154-1a21-4e61-9586-5c57f0eafdff', '5bbbea5b-2e32-4177-b44c-876f8388df2a', '5a49cd89-3df1-4019-bb70-c9d007bb8e43', 'เมืองทอง ยูไนเต็ด เสื้อแข่งทีมเยือน 2026', 'สินค้าลิขสิทธิ์แฟนคลับ เมืองทอง ยูไนเต็ด', 1590.00, 35, 'https://th-test-11.slatic.net/p/a70d95fe0c74fe0baffae3c96056eba3.jpg', '2026-09-08 03:28:55.338', 0, NULL),
('4711ad6c-f3f4-41f9-aa37-263851e841cf', '5e1c0be4-44cd-4173-8d65-4ca7045cf37b', '464d52d6-f4d8-437e-b3c8-1d50ded35882', 'การท่าเรือ เอฟซี ผ้าพันคอเชียร์', 'สินค้าลิขสิทธิ์แฟนคลับ การท่าเรือ เอฟซี', 350.00, 80, 'https://down-th.img.susercontent.com/file/th-11134207-7r98z-ln5w5tokuwer6e', '2026-09-08 03:28:55.586', 0, NULL),
('4a179282-313e-421c-900b-8111978cbac1', '9347423b-fa12-4088-9aba-2860cace071f', '16614a07-5bb3-4460-bbf7-02158cbc7133', 'ชลบุรี เอฟซี หมวกแก๊ปทีม', 'สินค้าลิขสิทธิ์แฟนคลับ ชลบุรี เอฟซี', 490.00, 60, 'https://down-th.img.susercontent.com/file/0fd5f2e8e667f3fbbdffe6d8a4b95ef7', '2026-09-08 03:28:55.804', 0, NULL),
('549905bf-822e-42f9-b04c-ddb044d289c7', '5e1c0be4-44cd-4173-8d65-4ca7045cf37b', '464d52d6-f4d8-437e-b3c8-1d50ded35882', 'การท่าเรือ เอฟซี เสื้อแข่งทีมเหย้า 2026', 'สินค้าลิขสิทธิ์แฟนคลับ การท่าเรือ เอฟซี', 1590.00, 40, 'https://tse4.mm.bing.net/th/id/OIP.RLBESnyI1ja8VQuY6QFoQwHaHa?r=0&rs=1&pid=ImgDetMain&o=7&rm=3', '2026-09-08 03:28:55.512', 0, NULL),
('69c51255-9800-47ea-8e5c-0a958cb35728', '66a0e55f-a4c1-4f9a-980c-c5213e92076c', 'bf5e955a-0c92-4db1-ae74-a60c6c6596cc', 'เชียงราย ยูไนเต็ด เสื้อแข่งทีมเหย้า 2026', 'สินค้าลิขสิทธิ์แฟนคลับ เชียงราย ยูไนเต็ด', 1590.00, 40, 'https://www.classicfootballshirts.co.uk/cdn-cgi/image/fit=pad,q=80,w=1000,h=1000,f=webp/pub/media/catalog/product/3/2/32b61d2c9fd280a5748f19a00a6c7bd09e0757d2196bc580652b540fff117576.jpeg', '2026-09-08 03:28:56.072', 0, NULL),
('6d0e9ee8-8e32-4eb2-91a7-f950198f0769', '75e4ae75-5094-46cd-9e6b-a877d2c44a61', 'e7501fbb-57b9-4bf0-86e7-a5525167810e', 'บางกอก ยูไนเต็ด เสื้อแข่งทีมเหย้า 2026', 'สินค้าลิขสิทธิ์แฟนคลับ บางกอก ยูไนเต็ด', 1590.00, 40, 'https://down-th.img.susercontent.com/file/th-11134207-7ra0n-mdqbpjggv9arbd_tn.webp', '2026-09-08 03:28:54.912', 1, NULL),
('74c26c80-22c2-46fc-821b-14c9f816b46a', '66a0e55f-a4c1-4f9a-980c-c5213e92076c', 'bf5e955a-0c92-4db1-ae74-a60c6c6596cc', 'เชียงราย ยูไนเต็ด ผ้าพันคอเชียร์', 'สินค้าลิขสิทธิ์แฟนคลับ เชียงราย ยูไนเต็ด', 350.00, 80, 'https://static.wixstatic.com/media/26408f_54427d42ae834a278f0430b3d0f6ab18~mv2.jpeg/v1/fill/w_980,h_735,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/26408f_54427d42ae834a278f0430b3d0f6a', '2026-09-08 03:28:56.194', 0, NULL),
('83bbe150-3770-44f0-b39b-6ac0d76bf8b6', '5e1c0be4-44cd-4173-8d65-4ca7045cf37b', '464d52d6-f4d8-437e-b3c8-1d50ded35882', 'การท่าเรือ เอฟซี เสื้อแข่งทีมเยือน 2026', 'สินค้าลิขสิทธิ์แฟนคลับ การท่าเรือ เอฟซี', 1590.00, 35, 'https://down-th.img.susercontent.com/file/th-11134207-81ztl-meitfh3oxzwjbf', '2026-09-08 03:28:55.536', 0, NULL),
('884aa068-d9c6-471e-b8b8-83a36c1899a3', '99b4229c-b6bf-4791-b865-fd579683abb4', '818815d4-e9c1-42a3-889d-98849b015327', 'บีจี ปทุม ยูไนเต็ด หมวกแก๊ปทีม', 'สินค้าลิขสิทธิ์แฟนคลับ บีจี ปทุม ยูไนเต็ด', 490.00, 60, 'https://th-test-11.slatic.net/p/20d6e507cf5d8876cc3ac9cc22282ab9.jpg', '2026-09-08 03:28:55.163', 0, NULL),
('8b993c9c-c574-4c8c-8cd6-92f550303384', '5bbbea5b-2e32-4177-b44c-876f8388df2a', '5a49cd89-3df1-4019-bb70-c9d007bb8e43', 'เมืองทอง ยูไนเต็ด ผ้าพันคอเชียร์', 'สินค้าลิขสิทธิ์แฟนคลับ เมืองทอง ยูไนเต็ด', 350.00, 80, 'https://down-th.img.susercontent.com/file/th-11134207-7r98w-lnx45u63h2lj28', '2026-09-08 03:28:55.403', 1, NULL),
('8e240b71-dd1a-4496-9c44-2386640cc0ba', '99b4229c-b6bf-4791-b865-fd579683abb4', '818815d4-e9c1-42a3-889d-98849b015327', 'บีจี ปทุม ยูไนเต็ด ผ้าพันคอเชียร์', 'สินค้าลิขสิทธิ์แฟนคลับ บีจี ปทุม ยูไนเต็ด', 350.00, 80, 'https://th.bing.com/th/id/OIP.LrnbyoMLcoxKqlYUn1LhhwHaLH?r=0&o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3', '2026-09-08 03:28:55.186', 0, NULL),
('969b26c6-f34a-45fc-a706-651b3f67616f', '9347423b-fa12-4088-9aba-2860cace071f', '16614a07-5bb3-4460-bbf7-02158cbc7133', 'ชลบุรี เอฟซี ผ้าพันคอเชียร์', 'สินค้าลิขสิทธิ์แฟนคลับ ชลบุรี เอฟซี', 350.00, 80, 'https://cf.shopee.co.th/file/th-11134207-7rasj-m1yc1cw4mgndd5', '2026-09-08 03:28:55.828', 0, NULL),
('9887fad7-88dd-4b05-ba77-f05554497f6d', '660ddd7d-f779-4e96-8563-0a7b98078f75', '017c1e28-9b93-42f6-9e17-d332d7994933', 'ราชบุรี มิตรผล เอฟซี เสื้อแข่งทีมเหย้า 2026', 'สินค้าลิขสิทธิ์แฟนคลับ ราชบุรี มิตรผล เอฟซี', 1590.00, 40, 'https://tse4.mm.bing.net/th/id/OIP.OLIbMPHAd5j-THA_aqNIUQHaIz?r=0&rs=1&pid=ImgDetMain&o=7&rm=3', '2026-09-08 03:28:56.286', 0, NULL),
('994cc7be-ae91-4333-a501-a21bc8a6ebab', '75e4ae75-5094-46cd-9e6b-a877d2c44a61', 'e7501fbb-57b9-4bf0-86e7-a5525167810e', 'บางกอก ยูไนเต็ด ผ้าพันคอเชียร์', 'สินค้าลิขสิทธิ์แฟนคลับ บางกอก ยูไนเต็ด', 350.00, 80, 'https://down-th.img.susercontent.com/file/th-11134207-81ztl-mdzuiq00qk1zea', '2026-09-08 03:28:54.995', 0, NULL),
('adbbe57f-3029-4092-a369-7a67e6496287', 'a395a0cc-1cee-4eca-90a5-07c7c9d8de79', '88b140d8-904d-4a9b-b6e0-f663f29da063', 'นครราชสีมา มาสด้า เอฟซี เสื้อแข่งทีมเหย้า 2026', 'สินค้าลิขสิทธิ์แฟนคลับ นครราชสีมา มาสด้า เอฟซี', 1590.00, 40, 'https://image.makewebeasy.net/makeweb/0/gdhtunMuW/DefaultData/nakhonratchasima_fc_third_plt_2020___yellow_38_944_4000__01_new_1.jpg', '2026-09-08 03:28:56.445', 1, NULL),
('b36e3464-6026-4d6a-a47e-695172eed634', '64b3ff2f-6968-4990-8cb8-f352378f36db', 'df7b2021-78e3-4d8c-ac0e-6b17dcdbb3ae', 'ทรู แบงค็อก ยูไนเต็ด เสื้อแข่งทีมเยือน 2026', 'สินค้าลิขสิทธิ์แฟนคลับ ทรู แบงค็อก ยูไนเต็ด', 1590.00, 35, 'https://www.football-thailand.com/wp-content/uploads/2024/02/th-11134207-7r992-lz6192veclgp52.png', '2026-09-08 03:28:55.937', 0, NULL),
('b5f56a88-2d26-4122-81c1-70084c446d17', '75e4ae75-5094-46cd-9e6b-a877d2c44a61', 'e7501fbb-57b9-4bf0-86e7-a5525167810e', 'บางกอก ยูไนเต็ด เสื้อแข่งทีมเยือน 2026', 'สินค้าลิขสิทธิ์แฟนคลับ บางกอก ยูไนเต็ด', 1590.00, 35, 'https://tse3.mm.bing.net/th/id/OIP.NsPbErrLxbMP2IfQAJranwHaHa?r=0&rs=1&pid=ImgDetMain&o=7&rm=3', '2026-09-08 03:28:54.936', 0, NULL),
('bc4a940e-21f3-4f77-9dc3-58d186bf1eba', '660ddd7d-f779-4e96-8563-0a7b98078f75', '017c1e28-9b93-42f6-9e17-d332d7994933', 'ราชบุรี มิตรผล เอฟซี หมวกแก๊ปทีม', 'สินค้าลิขสิทธิ์แฟนคลับ ราชบุรี มิตรผล เอฟซี', 490.00, 60, 'https://cf.shopee.co.th/file/id-11134207-7r990-lwye798rubffac', '2026-09-08 03:28:56.345', 0, NULL),
('bf07fad9-02fc-47fa-90c2-2d098b3ec15f', 'e842795f-ec2f-4195-a5dd-eea948c6a934', '11594323-0a40-4e1b-a034-1b7b06f51ad2', 'บุรีรัมย์ ยูไนเต็ด เสื้อแข่งทีมเหย้า 2026', 'สินค้าลิขสิทธิ์แฟนคลับ บุรีรัมย์ ยูไนเต็ด', 1590.00, 40, 'https://www.buriram.shop/api/uploads/product/94685bd4f1a26e1a176fb9e2bb5a999e-2025-08-08-18-57-30LINE_ALBUM_JERSEY20252026_250808_1.jpg', '2026-09-08 03:28:54.270', 0, NULL),
('c8f4511d-5cc3-45ca-a0a8-317459f858ac', '66a0e55f-a4c1-4f9a-980c-c5213e92076c', 'bf5e955a-0c92-4db1-ae74-a60c6c6596cc', 'เชียงราย ยูไนเต็ด เสื้อแข่งทีมเยือน 2026', 'สินค้าลิขสิทธิ์แฟนคลับ เชียงราย ยูไนเต็ด', 1590.00, 35, 'https://www.classicfootballshirts.co.uk/cdn-cgi/image/fit=pad,q=70,f=webp/pub/media/catalog/product/2/b/2b45860f188aa9999dbcd85d73353db3f9c77e2cbd6d1bdf8184524ee81253ce.jpeg', '2026-09-08 03:28:56.104', 0, NULL),
('d151eefa-5700-4507-9391-694c8eb62f37', 'e842795f-ec2f-4195-a5dd-eea948c6a934', '11594323-0a40-4e1b-a034-1b7b06f51ad2', 'แก้วเก็บอุณหภูมิขนาด Buriram United 20oz - สีดำ', 'สินค้าลิขสิทธิ์แฟนคลับ บุรีรัมย์ ยูไนเต็ด', 490.00, 60, 'https://www.buriram.shop/api/uploads/product/576ae14898ec63a2ac17af81a5c22ebe-2026-06-13-10-52-429a431ad6-12a3-480a-93bf-b6493b39a64a.jpg', '2026-09-08 03:28:54.377', 1, NULL),
('de2bb362-69b0-49f4-891a-10436a51edae', 'e842795f-ec2f-4195-a5dd-eea948c6a934', '11594323-0a40-4e1b-a034-1b7b06f51ad2', 'บุรีรัมย์ ยูไนเต็ด ผ้าพันคอเชียร์', 'สินค้าลิขสิทธิ์แฟนคลับ บุรีรัมย์ ยูไนเต็ด', 350.00, 80, 'https://www.buriram.shop/api/uploads/product/a4e21a7ec051e4158435858f9f32a39d-2025-03-16-13-21-28LINE_ALBUM_Scarf_250316_8.jpg', '2026-09-08 03:28:54.486', 0, NULL),
('e9206723-496a-46f2-98d6-b50d03a817a2', '99b4229c-b6bf-4791-b865-fd579683abb4', '818815d4-e9c1-42a3-889d-98849b015327', 'บีจี ปทุม ยูไนเต็ด เสื้อแข่งทีมเยือน 2026', 'สินค้าลิขสิทธิ์แฟนคลับ บีจี ปทุม ยูไนเต็ด', 1590.00, 35, 'https://tse1.mm.bing.net/th/id/OIP.cms1GvfhC-zNLZxTFi0qbgHaHa?r=0&rs=1&pid=ImgDetMain&o=7&rm=3', '2026-09-08 03:28:55.124', 1, NULL),
('ea56973c-ddb6-415a-be20-8923b446dd86', '5e1c0be4-44cd-4173-8d65-4ca7045cf37b', '464d52d6-f4d8-437e-b3c8-1d50ded35882', 'การท่าเรือ เอฟซี หมวกแก๊ปทีม', 'สินค้าลิขสิทธิ์แฟนคลับ การท่าเรือ เอฟซี', 490.00, 60, 'https://down-th.img.susercontent.com/file/208d546c4c5dfc8a5e4a891ead0d5a22', '2026-09-08 03:28:55.562', 1, NULL),
('eae95168-f90e-49df-85a8-d05b1203a044', '75e4ae75-5094-46cd-9e6b-a877d2c44a61', 'e7501fbb-57b9-4bf0-86e7-a5525167810e', 'บางกอก ยูไนเต็ด หมวกแก๊ปทีม', 'สินค้าลิขสิทธิ์แฟนคลับ บางกอก ยูไนเต็ด', 490.00, 60, 'https://th.bing.com/th/id/OIP.vCPqdKVM1bb8CedyeZm68QHaHa?r=0&o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3', '2026-09-08 03:28:54.961', 0, NULL),
('eff8d452-5253-4743-824e-e09e21bab6ba', 'e842795f-ec2f-4195-a5dd-eea948c6a934', '11594323-0a40-4e1b-a034-1b7b06f51ad2', 'บุรีรัมย์ ยูไนเต็ด เสื้อแข่งทีมเยือน 2026', 'สินค้าลิขสิทธิ์แฟนคลับ บุรีรัมย์ ยูไนเต็ด', 1590.00, 35, 'https://www.buriram.shop/api/uploads/product/edce5265061c480d02552cd063922438-2026-08-20-08-14-00LINE_ALBUM_JERSEY20262027_260820_7.jpg', '2026-09-08 03:28:54.320', 0, NULL),
('f1ab152f-1cfb-4461-ada7-57faca03d6ae', '9347423b-fa12-4088-9aba-2860cace071f', '16614a07-5bb3-4460-bbf7-02158cbc7133', 'ชลบุรี เอฟซี เสื้อแข่งทีมเยือน 2026', 'สินค้าลิขสิทธิ์แฟนคลับ ชลบุรี เอฟซี', 1590.00, 35, 'https://down-th.img.susercontent.com/file/th-11134275-81zte-mep7akfr0xdy97', '2026-09-08 03:28:55.753', 1, NULL),
('f54fc93b-1eaa-4662-81ad-1a70d5312f34', '64b3ff2f-6968-4990-8cb8-f352378f36db', 'df7b2021-78e3-4d8c-ac0e-6b17dcdbb3ae', 'ทรู แบงค็อก ยูไนเต็ด หมวกแก๊ปทีม', 'สินค้าลิขสิทธิ์แฟนคลับ ทรู แบงค็อก ยูไนเต็ด', 490.00, 60, 'https://tse2.mm.bing.net/th/id/OIP.1vaphqG8WNANszqbUfNufwHaF7?r=0&rs=1&pid=ImgDetMain&o=7&rm=3', '2026-09-08 03:28:55.970', 0, NULL),
('f56509c0-1f0c-4bf4-aac9-2b446e7e388d', '5bbbea5b-2e32-4177-b44c-876f8388df2a', '5a49cd89-3df1-4019-bb70-c9d007bb8e43', 'เมืองทอง ยูไนเต็ด เสื้อแข่งทีมเหย้า 2026', 'สินค้าลิขสิทธิ์แฟนคลับ เมืองทอง ยูไนเต็ด', 1590.00, 40, 'https://down-th.img.susercontent.com/file/th-11134207-81ztj-mihp1yekh0ck4a', '2026-09-08 03:28:55.304', 0, NULL),
('f767d8d9-b094-4349-87aa-c52fce02d371', '64b3ff2f-6968-4990-8cb8-f352378f36db', 'df7b2021-78e3-4d8c-ac0e-6b17dcdbb3ae', 'ทรู แบงค็อก ยูไนเต็ด ผ้าพันคอเชียร์', 'สินค้าลิขสิทธิ์แฟนคลับ ทรู แบงค็อก ยูไนเต็ด', 350.00, 80, 'https://down-th.img.susercontent.com/file/th-11134207-7rask-m2vw2bvm5ucibc.webp', '2026-09-08 03:28:55.995', 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` varchar(191) NOT NULL,
  `product_id` varchar(191) NOT NULL,
  `customer_id` varchar(191) NOT NULL,
  `rating` int(11) NOT NULL,
  `comment` varchar(191) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sellers`
--

CREATE TABLE `sellers` (
  `id` varchar(191) NOT NULL,
  `user_id` varchar(191) NOT NULL,
  `shop_name` varchar(191) NOT NULL,
  `shop_description` varchar(191) DEFAULT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sellers`
--

INSERT INTO `sellers` (`id`, `user_id`, `shop_name`, `shop_description`, `verified`, `created_at`) VALUES
('5bbbea5b-2e32-4177-b44c-876f8388df2a', '74a8ae02-ea3c-4a0a-b8e1-b870cb27bd62', 'Muangthong United Official Store', NULL, 1, '2026-09-08 03:28:55.271'),
('5e1c0be4-44cd-4173-8d65-4ca7045cf37b', 'cd27c1e5-1167-452a-9a55-55ad800cee54', 'Port FC Official Store', NULL, 1, '2026-09-08 03:28:55.478'),
('64b3ff2f-6968-4990-8cb8-f352378f36db', '4a73f49e-355a-4099-a7ec-bd77faadf6be', 'True Bangkok United Official Store', NULL, 1, '2026-09-08 03:28:55.871'),
('660ddd7d-f779-4e96-8563-0a7b98078f75', '97cc0864-71b7-4894-9a0f-083c9a04c02a', 'Ratchaburi FC Official Store', NULL, 1, '2026-09-08 03:28:56.262'),
('66a0e55f-a4c1-4f9a-980c-c5213e92076c', '4ce8b8ba-c1ad-4e15-abe1-a447b2d38f36', 'Chiangrai United Official Store', NULL, 1, '2026-09-08 03:28:56.045'),
('75e4ae75-5094-46cd-9e6b-a877d2c44a61', '9129e1e6-9150-44c3-9470-0cec8fdde7b2', 'Bangkok United Official Store', NULL, 1, '2026-09-08 03:28:54.536'),
('9347423b-fa12-4088-9aba-2860cace071f', '9e409db2-2fc2-4567-b4c0-7c3e6dcfd812', 'Chonburi FC Official Store', NULL, 1, '2026-09-08 03:28:55.703'),
('99b4229c-b6bf-4791-b865-fd579683abb4', '33621cbe-d2d6-46c3-be3d-a2e425ef249e', 'BG Pathum United Official Store', NULL, 1, '2026-09-08 03:28:55.045'),
('a395a0cc-1cee-4eca-90a5-07c7c9d8de79', '12a5c064-a525-48e7-a7d9-31bd08961656', 'Korat FC Official Store', NULL, 1, '2026-09-08 03:28:56.420'),
('e842795f-ec2f-4195-a5dd-eea948c6a934', 'bc612874-c2f0-41bf-b48e-2730d8966f86', 'Buriram United Official Store', NULL, 1, '2026-09-08 03:28:54.220');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `password_hash` varchar(191) NOT NULL,
  `role` enum('customer','seller','admin') NOT NULL DEFAULT 'customer',
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `role`, `created_at`) VALUES
('12a5c064-a525-48e7-a7d9-31bd08961656', 'Korat FC Official Store Manager', 'seller10@shop.com', '$2a$10$0PhtUltdYHupnhmrHHlPC.6AR0CkTBYFvuvG1rsdACQZA.HqFMsiG', 'seller', '2026-09-08 03:28:56.420'),
('33621cbe-d2d6-46c3-be3d-a2e425ef249e', 'BG Pathum United Official Store Manager', 'seller3@shop.com', '$2a$10$0PhtUltdYHupnhmrHHlPC.6AR0CkTBYFvuvG1rsdACQZA.HqFMsiG', 'seller', '2026-09-08 03:28:55.045'),
('4a73f49e-355a-4099-a7ec-bd77faadf6be', 'True Bangkok United Official Store Manager', 'seller7@shop.com', '$2a$10$0PhtUltdYHupnhmrHHlPC.6AR0CkTBYFvuvG1rsdACQZA.HqFMsiG', 'seller', '2026-09-08 03:28:55.871'),
('4ce8b8ba-c1ad-4e15-abe1-a447b2d38f36', 'Chiangrai United Official Store Manager', 'seller8@shop.com', '$2a$10$0PhtUltdYHupnhmrHHlPC.6AR0CkTBYFvuvG1rsdACQZA.HqFMsiG', 'seller', '2026-09-08 03:28:56.045'),
('74a8ae02-ea3c-4a0a-b8e1-b870cb27bd62', 'Muangthong United Official Store Manager', 'seller4@shop.com', '$2a$10$0PhtUltdYHupnhmrHHlPC.6AR0CkTBYFvuvG1rsdACQZA.HqFMsiG', 'seller', '2026-09-08 03:28:55.271'),
('9129e1e6-9150-44c3-9470-0cec8fdde7b2', 'Bangkok United Official Store Manager', 'seller2@shop.com', '$2a$10$0PhtUltdYHupnhmrHHlPC.6AR0CkTBYFvuvG1rsdACQZA.HqFMsiG', 'seller', '2026-09-08 03:28:54.536'),
('97cc0864-71b7-4894-9a0f-083c9a04c02a', 'Ratchaburi FC Official Store Manager', 'seller9@shop.com', '$2a$10$0PhtUltdYHupnhmrHHlPC.6AR0CkTBYFvuvG1rsdACQZA.HqFMsiG', 'seller', '2026-09-08 03:28:56.262'),
('9e409db2-2fc2-4567-b4c0-7c3e6dcfd812', 'Chonburi FC Official Store Manager', 'seller6@shop.com', '$2a$10$0PhtUltdYHupnhmrHHlPC.6AR0CkTBYFvuvG1rsdACQZA.HqFMsiG', 'seller', '2026-09-08 03:28:55.703'),
('bc612874-c2f0-41bf-b48e-2730d8966f86', 'Buriram United Official Store Manager', 'seller1@shop.com', '$2a$10$0PhtUltdYHupnhmrHHlPC.6AR0CkTBYFvuvG1rsdACQZA.HqFMsiG', 'seller', '2026-09-08 03:28:54.220'),
('cd27c1e5-1167-452a-9a55-55ad800cee54', 'Port FC Official Store Manager', 'seller5@shop.com', '$2a$10$0PhtUltdYHupnhmrHHlPC.6AR0CkTBYFvuvG1rsdACQZA.HqFMsiG', 'seller', '2026-09-08 03:28:55.478'),
('df540527-3501-4fc1-aba5-d729b6cba425', 'Admin', 'admin@shop.com', '$2a$10$0PhtUltdYHupnhmrHHlPC.6AR0CkTBYFvuvG1rsdACQZA.HqFMsiG', 'admin', '2026-09-08 03:28:53.922'),
('ec9c9223-285b-4c50-a6a5-48f587a5111b', 'Customer One', 'customer@shop.com', '$2a$10$0PhtUltdYHupnhmrHHlPC.6AR0CkTBYFvuvG1rsdACQZA.HqFMsiG', 'customer', '2026-09-08 03:28:54.037');

-- --------------------------------------------------------

--
-- Table structure for table `_prisma_migrations`
--

CREATE TABLE `_prisma_migrations` (
  `id` varchar(36) NOT NULL,
  `checksum` varchar(64) NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) NOT NULL,
  `logs` text DEFAULT NULL,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `applied_steps_count` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `_prisma_migrations`
--

INSERT INTO `_prisma_migrations` (`id`, `checksum`, `finished_at`, `migration_name`, `logs`, `rolled_back_at`, `started_at`, `applied_steps_count`) VALUES
('8c9ee0cd-3506-41c7-8874-47e5418ac5ab', '48623936a1deb00816ba48e4a2eebf8ddd37d5a7458277ee75d7f99ea2014730', '2026-09-08 03:28:49.675', '20260908032837_init', NULL, NULL, '2026-09-08 03:28:37.661', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `addresses_user_id_fkey` (`user_id`);

--
-- Indexes for table `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `carts_customer_id_key` (`customer_id`);

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cart_items_cart_id_product_id_key` (`cart_id`,`product_id`),
  ADD KEY `cart_items_product_id_fkey` (`product_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `categories_name_key` (`name`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_customer_id_fkey` (`customer_id`),
  ADD KEY `orders_address_id_fkey` (`address_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_items_order_id_fkey` (`order_id`),
  ADD KEY `order_items_product_id_fkey` (`product_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `payments_order_id_key` (`order_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `products_seller_id_fkey` (`seller_id`),
  ADD KEY `products_category_id_fkey` (`category_id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reviews_product_id_fkey` (`product_id`),
  ADD KEY `reviews_customer_id_fkey` (`customer_id`);

--
-- Indexes for table `sellers`
--
ALTER TABLE `sellers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sellers_user_id_key` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_key` (`email`);

--
-- Indexes for table `_prisma_migrations`
--
ALTER TABLE `_prisma_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `addresses`
--
ALTER TABLE `addresses`
  ADD CONSTRAINT `addresses_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `carts`
--
ALTER TABLE `carts`
  ADD CONSTRAINT `carts_customer_id_fkey` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `cart_items_cart_id_fkey` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cart_items_product_id_fkey` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_address_id_fkey` FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `orders_customer_id_fkey` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_order_id_fkey` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `order_items_product_id_fkey` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_order_id_fkey` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_category_id_fkey` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `products_seller_id_fkey` FOREIGN KEY (`seller_id`) REFERENCES `sellers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_customer_id_fkey` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reviews_product_id_fkey` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `sellers`
--
ALTER TABLE `sellers`
  ADD CONSTRAINT `sellers_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
