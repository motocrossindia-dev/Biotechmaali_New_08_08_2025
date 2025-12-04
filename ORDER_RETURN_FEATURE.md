# Order Return Feature Implementation

## Overview
Complete implementation of order return functionality allowing customers to return delivered orders with reason and notes.

## Files Modified/Created

### 1. Repository Layer
**File:** `lib/src/payment_and_order/order_history_detail/order_history_detail_repository.dart`
- **Added Function:** `returnOrder()`
- Uses existing Dio instance
- Endpoint: `POST /order/return/{orderId}`
- Retrieves `access_token` from SharedPreferences
- Sends return reason and notes in request body
- Comprehensive error handling with user-friendly messages

### 2. Provider Layer
**File:** `lib/src/payment_and_order/order_history_detail/order_history_detail_provider.dart`
- **Added Function:** `returnOrder()`
- **Added Properties:** 
  - `isReturning` - loading state for return operation
  - `returnSuccessMessage` - success message after return
  - `returnReasons` - list of 5 predefined return reasons
- Provides 5 predefined return reasons:
  1. Product received is damaged
  2. Wrong product delivered
  3. Product quality is not satisfactory
  4. Product does not match description
  5. Changed my mind
- Handles API communication through existing repository
- Notifies UI of state changes

### 3. UI Layer
**File:** `lib/src/payment_and_order/order_history_detail/order_return_dialog.dart` (NEW)
- Beautiful dialog with theme color (green #749F09)
- **Return Reason Dropdown:** Allows selection from predefined reasons
- **Additional Notes Field:** 4-line text input (min 10 chars, max 500 chars)
- **Form Validation:** Ensures both fields are filled
- **Action Buttons:** Cancel and Submit Return
- **Loading State:** Shows spinner during submission
- **Success/Error Handling:** Shows snackbar messages

## UI Integration

### Order History Detail Screen
**File:** `lib/src/payment_and_order/order_history_detail/order_history_detail_screen.dart`

**Changes Made:**
1. **Return Button (Delivered Orders):**
   - Shows green elevated button with "Return Order" text
   - Only visible when `orderStatus == 'delivered'`
   - Opens return dialog on tap
   - Navigates back after successful return

2. **Cancel Button (Pending Orders):**
   - Shows red outlined button with "Cancel Order" text
   - Visible for orders that are NOT:
     - Cancelled
     - Delivered
     - Ready for pickup
     - On the way
   - Shows confirmation dialog before cancellation

## API Request Format

```json
POST /order/return/{orderId}
Headers: {
  "Authorization": "Bearer {access_token}",
  "Content-Type": "application/json"
}
Body: {
  "reason": "Product received is damaged",
  "notes": "The product packaging was damaged and contents were broken..."
}
```

## User Flow

1. **Customer views delivered order** → Order Details Screen
2. **Clicks "Return Order" button** → Return Dialog Opens
3. **Selects return reason** from dropdown (required)
4. **Enters additional notes** in text field (min 10 chars, required)
5. **Clicks "Submit Return"** → API call with loading spinner
6. **Success** → Shows green snackbar → Navigates back to order list
7. **Error** → Shows red snackbar with error message

## Features

✅ **Clean UI:** Matches app theme with green accent color
✅ **Form Validation:** Both fields required with proper validation
✅ **Loading States:** Spinner during submission, disabled buttons
✅ **Error Handling:** User-friendly error messages
✅ **Token Management:** Automatically retrieves from SharedPreferences
✅ **Responsive Design:** Works in all screen sizes including floating windows
✅ **Character Counter:** Shows remaining characters (0/500)
✅ **Minimum Text:** Enforces minimum 10 character description

## Status-Based Button Logic

| Order Status | Button Shown | Action |
|-------------|-------------|---------|
| Delivered | Return Order (Green Elevated) | Opens return dialog |
| Pending/Processing | Cancel Order (Red Outlined) | Shows cancel confirmation |
| Cancelled | None | No action available |
| Ready for Pickup | None | No action available |
| On the Way | None | No action available |

## Testing Checklist

- [ ] Test with valid access token
- [ ] Test with expired/invalid token
- [ ] Test form validation (empty fields)
- [ ] Test minimum character requirement (notes field)
- [ ] Test maximum character limit (500 chars)
- [ ] Test dropdown selection required
- [ ] Test loading states
- [ ] Test success response handling
- [ ] Test error response handling
- [ ] Test navigation back after success
- [ ] Test cancel button in dialog
- [ ] Test button visibility based on order status

## Notes

- Dialog is non-dismissible (user must click Cancel or Submit)
- Provider is created locally for each dialog instance
- Success returns user to order list
- All fields are validated before submission
- Notes field has 500 character limit with counter
