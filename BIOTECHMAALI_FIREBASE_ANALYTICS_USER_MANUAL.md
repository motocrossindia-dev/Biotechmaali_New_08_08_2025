# 📊 Biotechmaali Firebase Analytics
## User Manual & Documentation

---

**Document Version:** 1.0  
**Date:** March 8, 2026  
**Prepared For:** Biotechmaali Private Limited  
**Application:** Biotechmaali Mobile App (Android & iOS)

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Getting Started with Firebase Analytics](#2-getting-started-with-firebase-analytics)
3. [Accessing the Firebase Console](#3-accessing-the-firebase-console)
4. [Dashboard Overview](#4-dashboard-overview)
5. [Events Tracked in Biotechmaali App](#5-events-tracked-in-biotechmaali-app)
6. [User Properties](#6-user-properties)
7. [Creating Custom Reports](#7-creating-custom-reports)
8. [Understanding Audiences](#8-understanding-audiences)
9. [Funnels & User Journeys](#9-funnels--user-journeys)
10. [Real-Time Analytics](#10-real-time-analytics)
11. [Export & Integration](#11-export--integration)
12. [Best Practices](#12-best-practices)
13. [Glossary](#13-glossary)
14. [Support & Contact](#14-support--contact)

---

## 1. Introduction

### 1.1 What is Firebase Analytics?

Firebase Analytics (also known as Google Analytics for Firebase) is a powerful, free analytics solution that provides insights into user behavior within your Biotechmaali mobile application. It helps you understand:

- **Who** your users are
- **What** they do in your app
- **When** they are most active
- **Where** they drop off in the purchase journey
- **Why** users convert or abandon

### 1.2 Benefits for Biotechmaali

| Benefit | Description |
|---------|-------------|
| 📈 **User Insights** | Understand customer behavior patterns |
| 🛒 **E-Commerce Tracking** | Track complete purchase journey |
| 🎯 **Marketing Optimization** | Measure campaign effectiveness |
| 🔍 **Search Analysis** | Know what products users search for |
| 💰 **Revenue Attribution** | Track revenue by source and campaign |
| 🐛 **Error Monitoring** | Identify app issues quickly |

### 1.3 What's Implemented

The Biotechmaali app has been configured with comprehensive analytics tracking covering:

- ✅ Screen views across 40+ screens
- ✅ E-commerce events (view, cart, wishlist, purchase)
- ✅ Search behavior analytics
- ✅ User authentication tracking
- ✅ Payment success and failure tracking
- ✅ Navigation pattern analysis
- ✅ Banner and promotion clicks
- ✅ Wallet and coins usage
- ✅ Referral program tracking
- ✅ Error and performance monitoring

---

## 2. Getting Started with Firebase Analytics

### 2.1 Firebase Project Information

| Property | Value |
|----------|-------|
| **Project Name** | biotechmaali-14778 |
| **Android Package** | com.biotechmaali.app |
| **iOS Bundle ID** | com.biotechmaali.app |

### 2.2 Access Requirements

To access the Firebase Console, you need:

1. A Google account with access to the Biotechmaali Firebase project
2. Appropriate permissions (Viewer, Editor, or Admin)

### 2.3 Team Access Levels

| Role | Permissions |
|------|-------------|
| **Admin** | Full access to all settings and data |
| **Editor** | View and modify analytics, create reports |
| **Viewer** | View analytics data and reports only |

---

## 3. Accessing the Firebase Console

### 3.1 Step-by-Step Access

1. **Go to Firebase Console**
   - Open your browser
   - Navigate to: https://console.firebase.google.com

2. **Sign In**
   - Sign in with your authorized Google account
   - Select the **biotechmaali-14778** project

3. **Navigate to Analytics**
   - In the left sidebar, click on **Analytics**
   - Click on **Dashboard** to view the main overview

### 3.2 Navigation Structure

```
Firebase Console
├── Analytics
│   ├── Dashboard (Overview)
│   ├── Realtime (Live data)
│   ├── Events (All tracked events)
│   ├── Conversions (Key events)
│   ├── Audiences (User segments)
│   ├── Custom Definitions
│   │   ├── Custom Dimensions
│   │   └── Custom Metrics
│   ├── DebugView (Testing)
│   └── Reports
│       ├── User Engagement
│       ├── Acquisition
│       └── Monetization
└── Project Settings
```

---

## 4. Dashboard Overview

### 4.1 Key Metrics on Dashboard

| Metric | Description | Why It Matters |
|--------|-------------|----------------|
| **Active Users** | Users active in selected period | Overall app engagement |
| **New Users** | First-time app users | Growth indicator |
| **Engagement Time** | Average time spent in app | User interest level |
| **Total Revenue** | Revenue from purchases | Business performance |
| **Sessions** | Number of app sessions | Usage frequency |
| **Events** | Total events triggered | Feature usage |

### 4.2 Time Period Selection

You can view data for different time periods:
- Last 7 days
- Last 28 days
- Last 30 days
- Last 90 days
- Custom date range

### 4.3 Comparison Mode

Compare current period with:
- Previous period (week-over-week)
- Same period last year (year-over-year)

---

## 5. Events Tracked in Biotechmaali App

### 5.1 Screen View Events

Every screen in the app is tracked. When a user visits any screen, it's automatically logged.

| Screen Name | Description |
|-------------|-------------|
| `SplashScreen` | App launch screen |
| `LoginScreen` | User login page |
| `MobileNumberScreen` | Phone number entry |
| `OtpScreen` | OTP verification |
| `HomeScreen` | Main home page |
| `ExploreScreen` | Product exploration |
| `CartScreen` | Shopping cart |
| `WishlistScreen` | Saved items |
| `AccountScreen` | User profile |
| `ProductDetailsScreen` | Product detail page |
| `ProductSearchScreen` | Search page |
| `OrderSummaryScreen` | Checkout summary |
| `ChoosePaymentScreen` | Payment selection |
| `OrderHistoryScreen` | Past orders |
| `WalletScreen` | Digital wallet |
| `ReferFriendScreen` | Referral program |

**How to Use:**
- Go to **Events** → Filter by `screen_view`
- See which screens users visit most
- Identify low-traffic screens that need attention

---

### 5.2 E-Commerce Events

These events track the complete shopping journey:

#### 5.2.1 Product Viewing

| Event | Description | Parameters |
|-------|-------------|------------|
| `view_item` | User viewed a product | product_id, product_name, category, price |

**Insight:** Know which products attract the most attention.

#### 5.2.2 Cart Events

| Event | Description | Parameters |
|-------|-------------|------------|
| `add_to_cart` | Item added to cart | product_id, product_name, price, quantity |
| `remove_from_cart` | Item removed from cart | product_id, product_name, price |
| `view_cart` | User viewed cart | items, total_value |

**Insight:** Track cart abandonment and popular products.

#### 5.2.3 Wishlist Events

| Event | Description | Parameters |
|-------|-------------|------------|
| `add_to_wishlist` | Item added to wishlist | product_id, product_name, category, price |
| `remove_from_wishlist` | Item removed from wishlist | product_id, product_name |

**Insight:** Understand product interest vs. purchase intent.

#### 5.2.4 Checkout Events

| Event | Description | Parameters |
|-------|-------------|------------|
| `begin_checkout` | Started checkout | items, total_value, coupon_code |
| `add_shipping_info` | Added delivery address | shipping_method, address_type |
| `add_payment_info` | Selected payment method | payment_type, value |

**Insight:** Identify where users drop off during checkout.

#### 5.2.5 Purchase Events

| Event | Description | Parameters |
|-------|-------------|------------|
| `purchase` | Order completed | transaction_id, total_value, items, payment_method |
| `payment_failed` | Payment unsuccessful | payment_method, error_reason, amount |
| `refund` | Order refunded | transaction_id, value, reason |

**Insight:** Track conversion rate and revenue.

---

### 5.3 Search Events

Track user search behavior:

| Event | Description | Parameters |
|-------|-------------|------------|
| `search` | User searched for product | search_term, results_count |
| `search_no_results` | Search returned no results | search_term |
| `voice_search` | User used voice search | search_term |
| `search_result_click` | Clicked on search result | search_term, product_id, position |
| `filter_applied` | Applied search filter | filter_type, filter_value |
| `sort_applied` | Applied sorting | sort_type |

**Insight:** 
- Find what products users search for
- Identify gaps in inventory (search_no_results)
- Optimize search algorithms

---

### 5.4 User Authentication Events

| Event | Description | Parameters |
|-------|-------------|------------|
| `sign_up` | New user registered | method (phone) |
| `login` | User logged in | method (phone) |
| `logout` | User logged out | - |
| `profile_update` | Profile info updated | fields_updated |
| `address_added` | New address added | address_type, city, pincode |
| `address_deleted` | Address removed | address_type |

**Insight:** Track user registration and account activity.

---

### 5.5 Navigation Events

| Event | Description | Parameters |
|-------|-------------|------------|
| `bottom_nav_click` | Bottom navigation clicked | tab_name, from_tab |
| `banner_click` | Promotional banner clicked | banner_id, banner_name, position |
| `banner_view` | Banner was displayed | banner_id, position |
| `category_click` | Category selected | category_id, category_name |
| `button_click` | Button clicked | button_name, screen_name |

**Insight:** Understand navigation patterns and banner effectiveness.

---

### 5.6 Wallet & Coins Events

| Event | Description | Parameters |
|-------|-------------|------------|
| `wallet_transaction` | Wallet credit/debit | type, amount, source |
| `wallet_add_money` | Money added to wallet | amount |
| `wallet_used` | Wallet used for payment | amount |
| `coins_earned` | User earned coins | coins, source |
| `coins_redeemed` | Coins used for purchase | coins, value |

**Insight:** Track wallet adoption and reward program effectiveness.

---

### 5.7 Referral Events

| Event | Description | Parameters |
|-------|-------------|------------|
| `referral_shared` | User shared referral code | method |
| `referral_applied` | Referral code used | referral_code |
| `referral_success` | Referral completed | referred_user_id, reward_value |

**Insight:** Measure referral program success.

---

### 5.8 Store & Franchise Events

| Event | Description | Parameters |
|-------|-------------|------------|
| `store_view` | Store page viewed | store_id, store_name, city |
| `store_selected` | Store selected for delivery | store_id, store_name |
| `franchise_enquiry` | Franchise enquiry submitted | location, city, state |

**Insight:** Track store interest and franchise inquiries.

---

### 5.9 Error & Performance Events

| Event | Description | Parameters |
|-------|-------------|------------|
| `app_error` | App error occurred | error_type, error_message, screen_name |
| `api_error` | API request failed | endpoint, status_code, error_message |
| `payment_failed` | Payment unsuccessful | payment_method, error_reason |
| `screen_load_time` | Screen loading time | screen_name, load_time_ms |

**Insight:** Monitor app health and identify issues.

---

### 5.10 Other Events

| Event | Description | Parameters |
|-------|-------------|------------|
| `share` | Content shared | content_type, item_id, method |
| `product_rating` | Rating submitted | product_id, rating, has_review |
| `coupon_applied` | Coupon code applied | coupon_code, discount_value |
| `coupon_removed` | Coupon code removed | coupon_code |
| `video_play` | Video played | video_id, video_title |
| `notification_click` | Push notification clicked | notification_type, action |
| `app_open` | App opened | - |

---

## 6. User Properties

User properties are attributes that describe segments of your user base.

### 6.1 Tracked User Properties

| Property | Description | Example Values |
|----------|-------------|----------------|
| `user_type` | Type of user | guest, registered, premium |
| `preferred_payment` | Preferred payment method | upi, card, cod, wallet |
| `preferred_category` | Most viewed category | plants, seeds, tools |
| `total_orders` | Number of completed orders | 0, 5, 15, 50+ |
| `total_spent` | Total amount spent | 0, 500, 5000, 50000 |
| `user_city` | User's city | Bangalore, Mumbai, Delhi |
| `app_version` | App version installed | 1.0.0, 1.1.0, 2.0.0 |
| `registration_date` | When user registered | 2024-01-15 |

### 6.2 Using User Properties

1. **Segment Users**
   - Create audiences based on properties
   - Example: Users with total_orders > 5

2. **Filter Reports**
   - View events only for specific user segments
   - Example: Revenue from premium users

3. **Personalization**
   - Use for targeted push notifications
   - Example: Send offers to users in Mumbai

---

## 7. Creating Custom Reports

### 7.1 Exploration Reports

1. Go to **Analytics** → **Explore**
2. Click **Create new exploration**
3. Choose template or start blank

### 7.2 Funnel Analysis

Create funnels to track conversion:

**Example: Purchase Funnel**
```
Step 1: view_item
Step 2: add_to_cart
Step 3: begin_checkout
Step 4: add_payment_info
Step 5: purchase
```

### 7.3 Path Analysis

Visualize user navigation paths:
- See common paths through the app
- Identify unexpected navigation patterns

### 7.4 Segment Comparison

Compare different user segments:
- New vs returning users
- High-value vs low-value customers
- Different city users

---

## 8. Understanding Audiences

### 8.1 Built-in Audiences

Firebase automatically creates:

| Audience | Description |
|----------|-------------|
| All Users | Everyone who opened the app |
| Purchasers | Users who made a purchase |
| 7-Day Active Users | Users active in last 7 days |
| 28-Day Active Users | Users active in last 28 days |

### 8.2 Creating Custom Audiences

**Example: High-Value Customers**
- Condition: purchase events > 3 in last 30 days
- AND total_spent > ₹5000

**Example: Cart Abandoners**
- Condition: add_to_cart in last 7 days
- AND NOT purchase in last 7 days

### 8.3 Using Audiences

1. **Export to Ads**
   - Use for Google Ads remarketing
   - Target specific user groups

2. **Push Notifications**
   - Send targeted messages via FCM

3. **A/B Testing**
   - Test features with specific audiences

---

## 9. Funnels & User Journeys

### 9.1 Key Funnels to Monitor

#### 9.1.1 Registration Funnel
```
app_open → MobileNumberScreen → OtpScreen → HomeScreen (as registered)
```
**Metrics:**
- Registration completion rate
- Drop-off at each step

#### 9.1.2 Purchase Funnel
```
view_item → add_to_cart → begin_checkout → add_payment_info → purchase
```
**Metrics:**
- Add to cart rate
- Checkout completion rate
- Purchase conversion rate

#### 9.1.3 Search to Purchase
```
search → view_item (from search) → add_to_cart → purchase
```
**Metrics:**
- Search-to-view rate
- Search-to-purchase rate

### 9.2 Creating Funnels in Firebase

1. Go to **Analytics** → **Explore**
2. Select **Funnel exploration**
3. Add steps (events)
4. View conversion rates

---

## 10. Real-Time Analytics

### 10.1 Accessing Real-Time View

1. Go to **Analytics** → **Realtime**
2. See live user activity

### 10.2 What You Can Monitor

| Metric | Description |
|--------|-------------|
| Active Users | Users currently in app |
| Users by Screen | Which screens are being viewed |
| Events by Name | Events happening now |
| Users by Location | Geographic distribution |

### 10.3 Use Cases

- **Launch Monitoring**: Track activity after new release
- **Campaign Tracking**: See immediate response to promotions
- **Issue Detection**: Spot problems quickly

---

## 11. Export & Integration

### 11.1 BigQuery Export

For advanced analysis:
1. Go to **Project Settings** → **Integrations**
2. Enable BigQuery
3. Query raw event data with SQL

### 11.2 Google Ads Integration

1. Go to **Project Settings** → **Integrations**
2. Link Google Ads account
3. Use audiences for remarketing

### 11.3 Data Studio Reports

1. Create a Data Studio report
2. Connect Firebase Analytics as data source
3. Build custom dashboards

### 11.4 Export Data

- Download CSV reports from any exploration
- Schedule automated reports via email

---

## 12. Best Practices

### 12.1 Daily Monitoring

| Task | Frequency |
|------|-----------|
| Check active users | Daily |
| Monitor purchase events | Daily |
| Review error events | Daily |
| Check search_no_results | Weekly |

### 12.2 Weekly Analysis

| Task | Purpose |
|------|---------|
| Compare week-over-week metrics | Identify trends |
| Review funnel conversion rates | Find drop-offs |
| Analyze top searched terms | Product demand |
| Check payment failures | Fix issues |

### 12.3 Monthly Reports

| Report | Include |
|--------|---------|
| Executive Summary | KPIs, trends, insights |
| User Growth Report | New users, retention |
| Revenue Report | Revenue, ARPU, transactions |
| Product Performance | Top products, views, conversions |

### 12.4 Actionable Insights

| Finding | Action |
|---------|--------|
| High search_no_results for "organic fertilizer" | Add product to inventory |
| Payment failure rate > 5% | Investigate payment gateway |
| Cart abandonment > 70% | Add cart reminders, simplify checkout |
| Low engagement on Explore screen | Improve UI/UX |

---

## 13. Glossary

| Term | Definition |
|------|------------|
| **Event** | User action tracked in app (e.g., add_to_cart) |
| **Parameter** | Additional data sent with event (e.g., product_id) |
| **User Property** | Attribute describing user (e.g., user_city) |
| **Session** | Period of user engagement in app |
| **Conversion** | Key event you want users to complete |
| **Funnel** | Series of steps toward a goal |
| **Audience** | Group of users with shared characteristics |
| **Attribution** | Determining which source led to conversion |
| **ARPU** | Average Revenue Per User |
| **DAU** | Daily Active Users |
| **MAU** | Monthly Active Users |
| **Retention** | Users returning to app over time |
| **Churn** | Users who stop using the app |

---

## 14. Support & Contact

### 14.1 Technical Support

For technical issues with analytics implementation:
- Review Firebase documentation: https://firebase.google.com/docs/analytics
- Check DebugView for real-time event testing

### 14.2 Additional Resources

| Resource | Link |
|----------|------|
| Firebase Analytics Documentation | https://firebase.google.com/docs/analytics |
| Google Analytics Help Center | https://support.google.com/analytics |
| Firebase YouTube Channel | https://www.youtube.com/@Firebase |

### 14.3 Data Privacy Note

Firebase Analytics:
- Does NOT collect personally identifiable information by default
- Is compliant with GDPR and other privacy regulations
- Allows users to opt-out of analytics collection

---

## Appendix A: Complete Event Reference

### All E-Commerce Events

```
view_item
add_to_cart
remove_from_cart
view_cart
add_to_wishlist
remove_from_wishlist
begin_checkout
add_shipping_info
add_payment_info
purchase
payment_failed
refund
```

### All Search Events

```
search
search_no_results
voice_search
search_result_click
search_with_filters
filter_applied
sort_applied
```

### All User Events

```
sign_up
login
logout
profile_update
address_added
address_deleted
```

### All Navigation Events

```
screen_view
bottom_nav_click
banner_click
banner_view
category_click
button_click
back_button_press
```

### All Wallet & Loyalty Events

```
wallet_transaction
wallet_add_money
wallet_used
coins_earned
coins_redeemed
referral_shared
referral_applied
referral_success
```

### All Engagement Events

```
share
product_rating
coupon_applied
coupon_removed
video_play
notification_received
notification_click
```

### All Error Events

```
app_error
api_error
payment_failed
```

---

## Appendix B: Key Metrics Dashboard Template

### Weekly KPI Dashboard

| Metric | Target | Current | Status |
|--------|--------|---------|--------|
| Daily Active Users | 10,000 | - | - |
| New User Registrations | 500/day | - | - |
| Purchase Conversion Rate | 3% | - | - |
| Cart Abandonment Rate | < 70% | - | - |
| Average Order Value | ₹500 | - | - |
| Payment Failure Rate | < 2% | - | - |
| Search-to-Purchase Rate | 5% | - | - |

---

## Appendix C: Common Analysis Queries

### Finding Top Products

**Steps:**
1. Go to Events → view_item
2. Click on event
3. View parameter: product_name
4. Sort by count

### Finding Search Gaps

**Steps:**
1. Go to Events → search_no_results
2. View parameter: search_term
3. Export list of unmatched searches

### Tracking Campaign Performance

**Steps:**
1. Add UTM parameters to campaign URLs
2. View Acquisition reports
3. Filter by campaign name

---

**Document End**

---

*This document is proprietary to Biotechmaali Private Limited. The analytics implementation was completed in March 2026.*

© 2026 Biotechmaali Private Limited. All rights reserved.
