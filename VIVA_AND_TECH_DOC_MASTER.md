# 🎓 Student Marketplace & Subscription Sharing
## 📚 Comprehensive Viva Preparation & Technical Architecture Guide (মাস্টার টেক ডক)

---

## 📑 সূচিপত্র (Table of Contents)
1. [প্রজেক্ট ওভারভিউ ও আর্কিটেকচার (High-Level Architecture)](#১-প্রজেক্ট-ওভারভিউ-ও-আর্কিটেকচার)
2. [ফোল্ডার স্ট্রাকচার ও ফাইল ম্যাপ (File Locations)](#২-ফোল্ডার-স্ট্রাকচার-ও-ফাইল-ম্যাপ)
3. [ফিচারভিত্তিক কোড ও ফাংশন বিশ্লেষণ (Feature-by-Feature Deep Dive)](#৩-ফিচারভিত্তিক-কোড-ও-ফাংশন-বিশ্লেষণ)
   - ক. অথেনটিকেশন ও ভার্সিটি ইমেইল ভ্যালিডেশন
   - খ. মার্কেটপ্লেস ও সেল আইটেম (ইমেজ আপলোড)
   - গ. সাবস্ক্রিপশন শেয়ারিং ও খরচ ভাগাভাগি
   - ঘ. সেফ-পে (SafePay) এস্ক্রো ও হ্যান্ডওভার মেকানিজম
   - ঙ. রিয়েল-টাইম চ্যাট সিস্টেম (Firestore Reactive Streams)
   - চ. সেলার ওয়ালেট, আর্নিংস ও পে-আউট
   - ছ. অ্যাডমিন প্যানেল (লিস্টিং, পেমেন্টস, ডিসপিউট ও রিফান্ড)
4. [ফায়ারবেস ডাটাবেস ডিজাইন ও স্কিমা (Firestore Collections)](#৪-ফায়ারবেস-ডাটাবেস-ডিজাইন-ও-স্কিমা)
5. [ম্যামের সম্ভাব্য সকল প্রশ্ন ও উত্তর (Top 15+ Viva Q&A)](#৫-ম্যামের-সম্ভাব্য-সকল-প্রশ্ন-ও-উত্তর)

---

## ১. প্রজেক্ট ওভারভিউ ও আর্কিটেকচার

**Student Marketplace** হলো বিশ্ববিদ্যালয়ের শিক্ষার্থীদের জন্য একটি সেন্ট্রালাইজড মাল্টি-মডিউল ওয়েব প্ল্যাটফর্ম, যার মূল লক্ষ্য:
1. ক্যাম্পাসের ভেতর ব্যবহৃত বই, ক্যালকুলেটর ও গ্যাজেট কেনাবেচাকে নিরাপদ করা (**SafePay Escrow System**)।
2. একাধিক শিক্ষার্থী মিলে নেটফ্লিক্স, স্পটিফাই, ক্যানভা বা কোর্সেরার মতো প্রিমিয়াম সাবস্ক্রিপশন খরচ ভাগ করে নেওয়া (**Subscription Sharing**)।
3. ইন-অ্যাপ রিয়েল-টাইম চ্যাটের মাধ্যমে ক্যাম্পাসে সরাসরি দেখা করার সময় ও স্থান নির্ধারণ করা।

### 🛠️ টেকনোলজি স্ট্যাক:
- **Frontend Framework:** Flutter Web (Dart)
- **State Management:** Flutter Riverpod (`StateNotifierProvider`)
- **Backend & Authentication:** Google Firebase (Cloud Firestore & Firebase Auth)
- **Image & Asset Storage:** Dual-Tier (Base64 for user uploads + Unsplash Global CDN for catalog assets)
- **Navigation:** GoRouter

---

## ২. ফোল্ডার স্ট্রাকচার ও ফাইল ম্যাপ

ম্যাম যদি কোনো নির্দিষ্ট ফিচারের কোড দেখতে চান, নিচের টেবিল দেখে সরাসরি ফাইলে চলে যেতে পারবেন:

| ফিচারের নাম | ফ্রন্টএন্ড UI ফাইল | ব্যাকএন্ড / সার্ভিস / প্রোভাইডার ফাইল |
| :--- | :--- | :--- |
| **১. অথেনটিকেশন (Login/Signup/Forgot)** | `lib/features/auth/screens/login_screen.dart`<br>`lib/features/auth/screens/signup_screen.dart`<br>`lib/features/auth/screens/forgot_password_screen.dart` | Firebase Authentication API |
| **২. ল্যান্ডিং পেজ** | `lib/features/auth/screens/landing_screen.dart` | Static & CDN Hero Assets |
| **৩. মার্কেটপ্লেস (বই ও গ্যাজেট)** | `lib/features/marketplace/screens/marketplace_screen.dart`<br>`lib/features/marketplace/screens/product_details_screen.dart` | `lib/features/marketplace/providers/marketplace_provider.dart` |
| **৪. পণ্য বিক্রয় (Sell Item)** | `lib/features/marketplace/screens/sell_item_screen.dart` | `lib/core/utils/file_picker_helper.dart`<br>`lib/core/utils/file_picker_web.dart` |
| **৫. সাবস্ক্রিপশন শেয়ারিং** | `lib/features/subscriptions/screens/subscription_groups_screen.dart` | `lib/features/subscriptions/providers/subscriptions_provider.dart` |
| **৬. সেফ-পে চেকআউট** | `lib/features/marketplace/widgets/payment_checkout_dialog.dart` | `lib/core/services/order_service.dart` |
| **৭. ইন-অ্যাপ চ্যাট** | `lib/features/chat/widgets/dynamic_chat_dialog.dart`<br>`lib/features/subscriptions/widgets/host_chat_dialog.dart` | `lib/core/services/chat_service.dart` |
| **৮. প্রোফাইল ও ওয়ালেট** | `lib/features/profile/screens/profile_screen.dart` | `lib/core/services/order_service.dart` |
| **৯. অ্যাডমিন প্যানেল** | `lib/features/admin/screens/admin_panel_screen.dart`<br>`lib/features/admin/screens/admin_login_screen.dart` | `lib/features/admin/providers/admin_provider.dart` |

---

## ৩. ফিচারভিত্তিক কোড ও ফাংশন বিশ্লেষণ

### ক. অথেনটিকেশন ও ভার্সিটি ইমেইল ভ্যালিডেশন
- **ফাইল:** `lib/features/auth/screens/signup_screen.dart` ও `login_screen.dart`
- **লজিক:** ক্যাম্পাসের বাইরের কেউ যেন একাউন্ট খুলতে না পারে, সেজন্য ইমেইলে `.edu` অথবা বিশ্ববিদ্যালয় ডোমেইন চেক করা হয়:
  ```dart
  if (!email.contains('.edu') && !email.contains('student')) {
    // Show campus domain validation message
  }
  ```
- **পাসওয়ার্ড রিসেট:** `FirebaseAuth.instance.sendPasswordResetEmail(email: email)` দিয়ে ইউজারের ইমেইলে সিকিউর পাসওয়ার্ড রিসেট লিংক পাঠানো হয়।

---

### খ. মার্কেটপ্লেস ও সেল আইটেম (ইমেজ আপলোড)
- **ফাইল:** `lib/features/marketplace/screens/sell_item_screen.dart`
- **ইমেজ হ্যান্ডলিং লজিক:** ব্রাউজার থেকে `dart:html` দিয়ে ইমেজ রিড করে Base64 এ রূপান্তর করা হয়:
  ```dart
  final base64String = base64Encode(_uploadedImageBytes!);
  finalImageUrl = 'data:image/jpeg;base64,$base64String';
  ```
- **কেন এই পদ্ধতি?** ব্রাউজারে জিরো CORS সমস্যা, নো এক্সট্রা ক্লাউড স্টোরেজ কস্ট এবং ইনস্ট্যান্ট লোডিং।

---

### গ. সাবস্ক্রিপশন শেয়ারিং ও খরচ ভাগাভাগি
- **ফাইল:** `lib/features/subscriptions/screens/subscription_groups_screen.dart`
- **লজিক:** একজন হোস্ট গ্রুপ তৈরি করে (যেমন: Netflix 4K = ৳1000, 4 Slots)। 
  - সিট প্রতি দাম স্বয়ংক্রিয়ভাবে ক্যালকুলেট হয়: `seatPrice = (totalPrice / totalSlots).roundToDouble()` (৳২৫০)।
  - বায়ার জয়েন করার সাথে সাথে স্লট অকুপাইড হয় (`1/4 -> 2/4`) এবং ক্রেডেনশিয়াল/ইনভাইট লিংক আনলক হয়।

---

### ঘ. সেফ-পে (SafePay) এস্ক্রো ও হ্যান্ডওভার মেকানিজম
- **সার্ভিস ফাইল:** `lib/core/services/order_service.dart`
- **ফ্লো:**
  1. বায়ার বিকাশ/নগদে পে করলে অর্ডার তৈরি হয় `status: 'in_safepay'` দিয়ে।
  2. টাকাটি সেলারের কাছে যায় না; এটি SafePay Escrow ভল্টে লক থাকে।
  3. বায়ার পণ্য বুঝে পেলে বা সাবস্ক্রিপশন এক্সেস পেলে প্রোফাইল থেকে **`Access Received (Confirm Seat)`** বা **`Item Received`** এ চাপ দেয়।
  4. ফাংশন `orderService.completeHandover(orderId)` কল হয়ে স্ট্যাটাস `completed` হয় এবং সেলারের ওয়ালেটে টাকা ট্রান্সফার হয়।

---

### ঙ. রিয়েল-টাইম চ্যাট সিস্টেম
- **সার্ভিস ফাইল:** `lib/core/services/chat_service.dart`
- **UI ফাইল:** `lib/features/chat/widgets/dynamic_chat_dialog.dart` ও `host_chat_dialog.dart`
- **লজিক:**
  - প্রতিটি রুমের আইডি ডাইনামিক: `prod_{productId}_buyer_{buyerId}` অথবা `{groupTitle}_{hostName}`।
  - `StreamBuilder` এবং `chats/{roomId}/messages` এর মাধ্যমে লাইভ মেসেজ আদান-প্রদান হয়।

---

### চ. সেলার ওয়ালেট ও আর্নিংস
- **ফাইল:** `lib/features/profile/screens/profile_screen.dart`
- **লজিক:**
  - `Available for Withdrawal` = শুধুমাত্র যে অর্ডারগুলো বায়ার কনফার্ম করেছে (`status == 'completed'`)।
  - বায়ার কনফার্ম না করা পর্যন্ত সেলারের ওয়ালেটে টাকা ০ থাকে, যাতে কোনো জালিয়াতি না হয়।

---

### ছ. অ্যাডমিন প্যানেল (Admin Panel)
- **ফাইল:** `lib/features/admin/screens/admin_panel_screen.dart`
- **ফাংশনালিটি:**
  1. **Users Management:** সকল রেজিস্টার্ড স্টুডেন্টের তালিকা।
  2. **Active Listings:** ফেক বা ভায়োলেটিং প্রডাক্ট রিমুভ করা।
  3. **SafePay Payments:** সকল এস্ক্রো লেনদেন ট্র্যাকিং (`Held in Escrow` vs `Released to Seller`)।
  4. **Reports & Disputes:** বায়ার বা সেলার কোনো সমস্যা রিপোর্ট করলে অ্যাডমিন সরাসরি তা রিভিউ করে **রিফান্ড (`refundOrder`)** বা **সলভ (`resolveReport`)** করতে পারে।

---

## ৪. ফায়ারবেস ডাটাবেস ডিজাইন ও স্কিমা

| কালেকশন (Collection) | ডকুমেন্ট আইডি (Primary Key) | ফরেন কী (Foreign Keys) | গুরুত্বপূর্ণ ফিল্ডস (Key Fields) |
| :--- | :--- | :--- | :--- |
| **`users`** | `user.uid` | - | `name`, `email`, `department`, `role`, `createdAt` |
| **`products`** | Auto-ID (20 chars) | `sellerId` ➔ `users.uid` | `title`, `price`, `category`, `imageUrl`, `isSold` |
| **`orders`** | Auto-ID | `buyerId`, `sellerId`, `productId` | `price`, `paymentMethod`, `trxId`, `status`, `createdAt` |
| **`chats`** | Compound ID (`prod_X_buyer_Y`) | `participants: [sellerId, buyerId]` | `lastMessage`, `lastMessageTime`, `productTitle` |
| **`messages`** *(Sub-collection)* | Auto-ID | `chats/{roomId}/messages` | `text`, `sender`, `senderId`, `timestamp` |
| **`reports`** | Auto-ID | `orderId`, `reportedById` | `reason`, `notes`, `contactNumber`, `status` |

---

## ৫. ম্যামের সম্ভাব্য সকল প্রশ্ন ও উত্তর (Top 15+ Viva Q&A)

### প্রশ্ন ১: প্রজেক্টটির মূল উদ্দেশ্য কী? সাধারণ মার্কেটপ্লেস (যেমন Bikroy বা Daraz) থেকে এটি আলাদা কেন?
**উত্তর:**
> "ম্যাম, এটি শুধুমাত্র একটি সাধারণ ক্লাসিফায়েড সাইট নয়। এটি বিশ্ববিদ্যালয় শিক্ষার্থীদের জন্য একটি ক্লোজড-লুপ ইকোসিস্টেম। এখানে রয়েছে **SafePay Escrow প্রোটেকশন** (যাতে অগ্রিম টাকা মেরে দেওয়া বা নষ্ট পণ্য দেওয়ার ঝুঁকি থাকে না) এবং বাংলাদেশে প্রথম **Subscription Sharing Splitter** (যার মাধ্যমে শিক্ষার্থীরা ওটিটি ও এডুকেশনাল টুলসের খরচ ভাগ করে নিতে পারে)।"

---

### প্রশ্ন ২: সেফ-পে (SafePay) কীভাবে কাজ করে? টাকা কি সরাসরি বিক্রেতার কাছে চলে যায়?
**উত্তর:**
> "না ম্যাম। বায়ার বিকাশ বা নগদে পেমেন্ট করার পর টাকাটি সরাসরি বিক্রেতার ওয়ালেটে যায় না। এটি SafePay এস্ক্রো ভল্টে `in_safepay` স্ট্যাটাসে হোল্ড থাকে। বায়ার ক্যাম্পাসে দেখা করে আইটেম বুঝে নেওয়ার পর অ্যাপে **`Item Received`** চাপলে তবেই টাকাটি সেলারের অ্যাকাউন্টে রিলিজ হয়।"

---

### প্রশ্ন ৩: কোনো বায়ার যদি পণ্য না পেয়ে জালিয়াতির শিকার হয়, তখন কী হবে?
**উত্তর:**
> "বায়ার সাথে সাথে অর্ডারের নিচে থাকা **`Report to Admin`** বাটনে চাপ দিয়ে ডিসপিউট ওপেন করতে পারবে। অ্যাডমিন তার ড্যাশবোর্ডে গিয়ে বিষয়টি তদন্ত করে সেলারের পেমেন্ট বাতিল করতে পারবে এবং **`Refund to Buyer`** অ্যাকশন দিয়ে বায়ারকে টাকা রিফান্ড করে দিতে পারবে।"

---

### প্রশ্ন ৪: তোমরা ছবিগুলো কীভাবে স্টোর করছো? ফায়ারবেস স্টোরেজ কেন ব্যবহার করোনি?
**উত্তর:**
> "ম্যাম, আমরা হাইব্রিড মডেল ব্যবহার করেছি:
> ১. ডেমো ও ক্যাটালগ ইমেজের জন্য দ্রুতগতির **Unsplash CDN** ব্যবহার করেছি।
> ২. ইউজারের আপলোড করা ছবিগুলো `file_picker_web` দিয়ে রিড করে **Base64 Data URI** আকারে সরাসরি Firestore ডকুমেন্টে সেভ করেছি।
> Firebase Storage-এ ব্রাউজারে CORS জটিলতা এবং অতিরিক্ত বিলিং থাকে, কিন্তু Base64 ফরম্যাটে ব্রাউজারে জিরো CORS সমস্যা এবং ১টি সিঙ্গেল কুয়েরিতেই ইনস্ট্যান্ট ছবি লোড হয়।"

---

### প্রশ্ন ৫: সাবস্ক্রিপশন গ্রুপের দাম কীভাবে ভাগ হচ্ছে?
**উত্তর:**
> "হোস্ট যখন গ্রুপের টোটাল প্রাইস এবং স্লট সংখ্যা দেয়, সিস্টেম স্বয়ংক্রিয়ভাবে `(totalPrice / totalSlots).roundToDouble()` দিয়ে প্রতি সিটের দাম বের করে। বায়ার যখন স্লট পারচেজ করে, সে ওই নির্দিষ্ট স্ক্রিনের পিন/ক্রেডেনশিয়াল পেয়ে যায় এবং হোস্ট তার শেয়ারের টাকা পায়।"

---

### প্রশ্ন ৬: ইন-অ্যাপ চ্যাট কি রিয়েল-টাইম? রিফ্রেশ ছাড়া মেসেজ কীভাবে আসে?
**উত্তর:**
> "হ্যাঁ ম্যাম, এটি সম্পূর্ণ রিয়েল-টাইম। আমরা Flutter-এর **`StreamBuilder`** এবং Cloud Firestore-এর **`.snapshots()`** লিসেনার ব্যবহার করেছি। ফলে ডাটাবেসে নতুন মেসেজ আসার সাথে সাথেই WebSocket স্ট্রিমের মাধ্যমে স্ক্রিনে মেসেজ বাবল রেন্ডার হয়ে যায়।"

---

### প্রশ্ন ৭: একই বায়ার একই প্রোডাক্টে বারবার চ্যাট করলে কি নতুন নতুন চ্যাটরুম তৈরি হয়?
**উত্তর:**
> "না ম্যাম। আমরা কম্পাউন্ড ডিটারমিনিস্টিক রুম আইডি ব্যবহার করেছি: `prod_{productId}_buyer_{buyerId}`। ফলে একই বায়ার ও প্রোডাক্টের জন্য সবসময় ডাটাবেসের একটি নির্দিষ্ট ইউনিক রুমেই চ্যাট ওপেন হয়, কোনো ডুপ্লিকেট হয় না।"

---

### প্রশ্ন ৮: স্টেট ম্যানেজমেন্টের জন্য তোমরা কী ব্যবহার করেছো?
**উত্তর:**
> "ম্যাম, আমরা **Flutter Riverpod** ব্যবহার করেছি। যেমন: মার্কেটপ্লেসের স্টেট হ্যান্ডেল করার জন্য `marketplaceProvider`, সাবস্ক্রিপশনের জন্য `subscriptionsProvider` এবং অ্যাডমিন অ্যাকশনের জন্য `adminProvider`।"

---

### প্রশ্ন ৯: সিকিউরিটি ও আনঅথরাইজড এক্সেস কীভাবে রোধ করছো?
**উত্তর:**
> "ম্যাম, আমাদের ৩ স্তরের নিরাপত্তা রয়েছে:
> ১. **ইমেইল ফিল্টার:** শুধুমাত্র অথোরাইজড স্টুডেন্ট ডোমেইন।
> ২. **Firestore Security Rules:** `firestore.rules` ফাইলে ডিফাইন করা আছে যেন কোনো ইউজার অন্য কারও প্রাইভেট চ্যাট বা অর্ডার ম্যানিপুলেট করতে না পারে।
> ৩. **অ্যাডমিন প্রোটেকশন:** অ্যাডমিন রুট এবং প্যানেল সাধারণ স্টুডেন্টদের জন্য ব্লকড।"

---

### প্রশ্ন ১০: ল্যাপটপ বা মোবাইলের ভিন্ন ভিন্ন স্ক্রিন সাইজে ডিজাইন কি ভেঙে যাবে?
**উত্তর:**
> "না ম্যাম। প্রতিটি স্ক্রিন **`SingleChildScrollView`** এবং **`ConstrainedBox (maxWidth: 1300)`** দিয়ে র‍্যাপ করা। ফলে ছোট ১৩ ইঞ্চি ল্যাপটপ থেকে শুরু করে বড় মনিটর বা স্প্লিট স্ক্রিনেও লেআউট নিখুঁতভাবে অটো-স্কেল ও সেন্টারড থাকে।"

---

🎯 **এই ডকটি সাথে রাখলে ভাইভায় যেকোনো প্রশ্নের উত্তর আপনি সবচেয়ে প্রফেশনাল ও আত্মবিশ্বাসের সাথে দিতে পারবেন!**
