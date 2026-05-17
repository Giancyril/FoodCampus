# Campus Food Express — Foodeli Premium Food App 

A state-of-the-art, modern, and high-fidelity campus food ordering and queue-skipping system. Styled exquisitely after the modern **Foodeli Premium Dribbble design**, this application integrates a highly-responsive Flutter student frontend with a powerful Laravel PostgreSQL REST API backend.

---

## Design Philosophy & Aesthetics (Foodeli Inspired)
* **Harmonious HSL Palette**: Tailored sleek colors using organic grass green accents (`#3EBD70`), soft premium light backdrops (`#F5F6F6`), and high-contrast deep charcoal text labels (`#0D121B`).
* **Pill-Style Custom Bottom Navigation Bar**: Floating horizontal bottom navbar where active tabs morph fluidly into rounded emerald green pill capsules, showing beautiful animated micro-transitions.
* **Hero Image Stall Headers**: Restaurant and stall browse views present beautiful high-fidelity hero image cards with rounded bottom sheets, transparent app bar headers, floating favoriting support, and inline live ratings pills.
* **Compact Category Badges**: Sleek, circular category filter chips (Meals, Drinks, Snacks) that slide smoothly, built perfectly to maximize display real estate.
* **Modern Rounded Input Fields**: Flat white card-like panels with subtle borders, custom validation, and dropdown selectors that feel incredibly premium.

---

## Key Features

### Student / Customer Flow
* **Custom Name Resolution & Persistent Offline Cache**: Inputting a student number (e.g. `20221270`) automatically translates to the student's real database profile name (**Mary Jane**). The name is saved inside offline `SharedPreferences` so it remains fully persistent when offline.
* **Dribbble Best Seller Grid**: Real-time browsing of canteen stalls with rating scores, description banners, and active/inactive status badges.
* **Live Search & Category Filters**: Search delicious dishes with instant keystroke filtering or select categories (All, Meals, Drinks, Snacks) to filter menus on the fly.
* **Interactive Cart Bottom Sheet**: Add items with custom quantities, special notes, and view the checkout summary with automated price calculation.
* **Queue-Skipping Order Scheduler**: Schedule canteen pickups ahead of time, pay seamlessly, and skip long queues.

### Canteen Stall / Vendor Dashboard
* **Real-time Order Processing**: Manage incoming customer orders with status updates (Pending, Cooking, Ready, Picked Up).
* **Live Menu Management**: Add, update, or hide food items, adjust prices, descriptions, and categories easily.
* **Analytical Insights**: Review daily earnings, stall performance metrics, and pending order pipelines.

### Admin / Platform Manager Dashboard
* **Role-Based Dropdown Authentication**: Choose between Customer, Vendor, or Admin directly from the landing screens to access separate dashboards.
* **Stall Approvals Portal**: Approve new vendor registration requests before they go live on the student store.
* **10% Commission Engine**: Automatic 10% commission calculations on all transactions to track platform revenues.
* **Comprehensive Users Manager**: Review student activity, audit transaction logs, and manage accounts.

---

## Technology Stack
* **Frontend Mobile/Web**: Flutter (Dart)
* **State Management**: GetX (Robust, reactive, and lightning-fast state handling)
* **Local Caching**: SharedPreferences (Offline name caching & persistent session handling)
* **Backend REST API**: Laravel (PHP)
* **Primary Database**: PostgreSQL (Secure, enterprise-grade, relational data store)
* **Animations**: Flutter Animate & Custom Tween Micro-transitions

---

## How to Run Locally

### 1. Database Setup (PostgreSQL)
1. Ensure your PostgreSQL service is running on your machine.
2. Create a new database named `foodcampus`:
   ```sql
   CREATE DATABASE foodcampus;
   ```
3. The database password is set to `aech123` with username `postgres` on port `5432`.

### 2. Laravel Backend Service
1. Open a terminal in the `campus-food-backend` directory.
2. Run database migrations to initialize all tables:
   ```bash
   php artisan migrate
   ```
3. Start the local server:
   ```bash
   php artisan serve
   ```
   The API will now be live on `http://127.0.0.1:8000/api`.

### 3. Flutter Student Frontend
1. Open a terminal in the `campus_food_express` directory.
2. Fetch and initialize packages:
   ```bash
   flutter pub get
   ```
3. Start the application on Google Chrome in debug mode:
   ```bash
   flutter run -d chrome
   ```

---

## Project Structure
```text
├── campus_food_express       # Flutter mobile and web frontend application
│   ├── lib
│   │   ├── controllers/      # GetX state managers & HTTP REST connection controllers
│   │   ├── models/           # Data models (Canteens, FoodItems, Orders, Users)
│   │   └── main.dart         # Premium Dribbble UI screen components
├── campus-food-backend       # Laravel PostgreSQL REST API service
│   ├── app/Http/Controllers/ # REST API controllers (Auth, Order pipelines)
│   ├── database/migrations/  # PostgreSQL database schema definitions
│   └── routes/api.php        # REST endpoints list
```
