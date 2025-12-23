# Order Response Model Update - Cart Support

## Summary
Updated `OrderResponseModel` to support the new cart data structure returned by the backend in the order summary API response.

## New JSON Structure
```json
{
  "message": "success",
  "data": {
    "cart": [
      {
        "id": 1254,
        "user_id": 79,
        "main_prod": 277,
        "product_id": 774,
        "quantity": 1,
        "name": "Eva Planter",
        "image": "/media/product_images/SEREVA1210MG1_5ogUrTc.jpg",
        "mrp": 799.0,
        "selling_price": 719.1,
        "discount": 79.9,
        "short_description": "Designed with a contemporary...",
        "stock_status": "In Stock"
      }
    ]
  }
}
```

## Changes Made

### 1. **Updated OrderData Class**

#### Before:
```dart
class OrderData {
  final OrderDetails order;  // Required
  final List<OrderItem> orderItems;

  OrderData({
    required this.order,
    required this.orderItems,
    // ...
  });
}
```

#### After:
```dart
class OrderData {
  final OrderDetails? order;  // Now nullable
  final List<OrderItem> orderItems;
  final List<CartItem> cart;  // New field

  OrderData({
    this.order,  // Nullable
    this.orderItems = const [],
    this.cart = const [],  // New cart list
    // ...
  });
}
```

**Key Changes**:
- ✅ `order` is now **nullable** (`OrderDetails?`) - may not be present in cart responses
- ✅ Added `cart` field to store cart items
- ✅ Made `orderItems` and `cart` default to empty lists
- ✅ Updated `fromJson` to parse cart data

### 2. **Created New CartItem Class**

Complete new class to represent cart items:

```dart
class CartItem {
  final int id;
  final int userId;
  final int mainProd;
  final int productId;
  final int quantity;
  final String name;
  final String image;
  final double mrp;
  final double sellingPrice;
  final double discount;
  final String shortDescription;
  final String stockStatus;

  CartItem({...});

  factory CartItem.fromJson(Map<String, dynamic> json) {...}
  
  Map<String, dynamic> toJson() {...}
}
```

**Fields Mapping**:
| JSON Field | Dart Property | Type | Description |
|------------|---------------|------|-------------|
| `id` | `id` | `int` | Cart item ID |
| `user_id` | `userId` | `int` | User who added item |
| `main_prod` | `mainProd` | `int` | Main product ID |
| `product_id` | `productId` | `int` | Variant/combination product ID |
| `quantity` | `quantity` | `int` | Number of items |
| `name` | `name` | `String` | Product name |
| `image` | `image` | `String` | Product image path |
| `mrp` | `mrp` | `double` | Maximum retail price |
| `selling_price` | `sellingPrice` | `double` | Discounted price |
| `discount` | `discount` | `double` | Discount amount |
| `short_description` | `shortDescription` | `String` | Product description |
| `stock_status` | `stockStatus` | `String` | Availability status |

### 3. **Updated fromJson Method**

```dart
factory OrderData.fromJson(Map<String, dynamic> json) {
  return OrderData(
    order: json['order'] != null 
        ? OrderDetails.fromJson(json['order']) 
        : null,  // Safe null handling
    orderItems: (json['order_items'] as List? ?? [])
        .map((item) => OrderItem.fromJson(item))
        .toList(),
    cart: (json['cart'] as List? ?? [])  // Parse cart array
        .map((item) => CartItem.fromJson(item))
        .toList(),
    // ... other fields
  );
}
```

## Use Cases

### 1. **Order Summary Page**
When loading an existing order:
```dart
// Response has 'order' and 'order_items'
{
  "message": "success",
  "data": {
    "order": {...},
    "order_items": [...]
  }
}
```
Access via: `orderResponse.data.order` and `orderResponse.data.orderItems`

### 2. **Cart Data in Order Context**
When cart is included with order:
```dart
// Response has 'cart' array
{
  "message": "success",
  "data": {
    "cart": [...]
  }
}
```
Access via: `orderResponse.data.cart`

### 3. **Mixed Response**
When both order and cart data are present:
```dart
{
  "message": "success",
  "data": {
    "order": {...},
    "order_items": [...],
    "cart": [...]
  }
}
```
Access all: 
- `orderResponse.data.order`
- `orderResponse.data.orderItems`
- `orderResponse.data.cart`

## Example Usage

### Parsing Cart Data:
```dart
// API Response
final response = await api.getOrderSummary();

// Parse into model
final orderResponse = OrderResponseModel.fromJson(response);

// Access cart items
final cartItems = orderResponse.data.cart;

for (var item in cartItems) {
  print('Product: ${item.name}');
  print('Price: ₹${item.sellingPrice}');
  print('Quantity: ${item.quantity}');
  print('Image: ${item.image}');
  print('Stock: ${item.stockStatus}');
}
```

### Checking Data Availability:
```dart
final orderData = orderResponse.data;

// Check if order exists
if (orderData.order != null) {
  print('Order ID: ${orderData.order!.orderId}');
  print('Total: ₹${orderData.order!.grandTotal}');
}

// Check if cart has items
if (orderData.cart.isNotEmpty) {
  print('Cart has ${orderData.cart.length} items');
}

// Check if order items exist
if (orderData.orderItems.isNotEmpty) {
  print('Order has ${orderData.orderItems.length} items');
}
```

### Display Cart in UI:
```dart
ListView.builder(
  itemCount: orderData.cart.length,
  itemBuilder: (context, index) {
    final cartItem = orderData.cart[index];
    return ListTile(
      leading: Image.network('${BaseUrl.baseUrl}${cartItem.image}'),
      title: Text(cartItem.name),
      subtitle: Text(
        '₹${cartItem.sellingPrice} × ${cartItem.quantity}\n'
        '${cartItem.stockStatus}'
      ),
      trailing: Text('₹${cartItem.sellingPrice * cartItem.quantity}'),
    );
  },
)
```

## Benefits

### ✅ **Flexible Response Handling**
- Can handle responses with just `cart` data
- Can handle responses with just `order` data
- Can handle responses with both

### ✅ **Type Safety**
- All fields properly typed
- Safe parsing with default values
- Null safety with nullable `order` field

### ✅ **Complete Cart Information**
- Product details (name, image, description)
- Pricing information (MRP, selling price, discount)
- Stock status
- Quantity tracking
- User and product IDs for reference

### ✅ **Backward Compatible**
- Existing code using `order` and `orderItems` still works
- New `cart` field available when needed
- Empty lists returned when data not present

## Testing Checklist

- [ ] Parse response with only `cart` data
- [ ] Parse response with only `order` data
- [ ] Parse response with both `cart` and `order` data
- [ ] Handle empty cart array
- [ ] Handle null order field
- [ ] Display cart items in UI
- [ ] Calculate cart totals
- [ ] Show product images from cart
- [ ] Display stock status correctly
- [ ] Handle quantity changes
- [ ] Format prices correctly

## Files Modified

1. `/lib/src/payment_and_order/order_summary/model/order_response_model.dart`
   - Made `OrderDetails order` nullable
   - Added `List<CartItem> cart` field
   - Created new `CartItem` class with all fields
   - Updated `fromJson` to parse cart data
   - Added `toJson` method to CartItem

## Data Flow

```
API Response (JSON)
      ↓
OrderResponseModel.fromJson()
      ↓
OrderData
   ├── order? (nullable)
   ├── orderItems (List<OrderItem>)
   └── cart (List<CartItem>)
      ↓
UI/Business Logic
```

## Notes

- Cart items use `product_id` field (variant/combination ID)
- Order items also have `productId` for consistency
- Both support image paths that need base URL prepended
- Stock status is a string ("In Stock", "Out of Stock", etc.)
- All price fields are properly typed as `double`
- Safe parsing handles missing or null fields gracefully
