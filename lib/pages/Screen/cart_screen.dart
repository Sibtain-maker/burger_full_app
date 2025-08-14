import 'package:burger_app_full/Core/Utils/const.dart';
import 'package:burger_app_full/Core/models/cart_model.dart';
import 'package:burger_app_full/service/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback? onNavigateToHome;
  
  const CartScreen({super.key, this.onNavigateToHome});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  final CartService cartService = CartService();
  final TextEditingController promoController = TextEditingController();
  late AnimationController _animationController;
  late AnimationController _checkoutController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _checkoutController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    cartService.initializeCart();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _checkoutController.dispose();
    promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey1,
      body: ListenableBuilder(
        listenable: cartService,
        builder: (context, child) {
          print('CartScreen: Rebuilding, cart has ${cartService.cart.items.length} items');
          
          if (cartService.isLoading) {
            return _buildLoadingState();
          }

          if (cartService.cart.isEmpty) {
            return _buildEmptyCartState();
          }

          return _buildCartContent();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: red),
          SizedBox(height: 16),
          Text(
            'Loading your cart...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCartState() {
    return Center(
      child: FadeInUp(
        duration: Duration(milliseconds: 800),
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.shopping_cart,
                  size: 60,
                  color: red,
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Your Cart is Empty',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Looks like you haven\'t added anything to your cart yet. Start browsing our delicious menu!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 40),
              Container(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => widget.onNavigateToHome?.call(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: red,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.shop),
                      SizedBox(width: 12),
                      Text(
                        'Start Shopping',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartContent() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(
          child: Column(
            children: [
              _buildCartItems(),
              _buildPromoCodeSection(),
              _buildOrderSummary(),
              _buildCheckoutButton(),
              SizedBox(height: 140), // Extra space for bottom navigation
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: red,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'My Cart',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [red, red.withOpacity(0.8)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 20,
                bottom: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${cartService.itemCount} items',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Remove back button since cart is part of bottom navigation
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: Icon(Iconsax.refresh, color: Colors.white),
          onPressed: () async {
            // Clear cart storage and reinitialize for debugging
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('cart');
            cartService.initializeCart();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cart storage cleared!')),
              );
            }
          },
        ),
        IconButton(
          icon: Icon(Iconsax.trash, color: Colors.white),
          onPressed: _showClearCartDialog,
        ),
      ],
    );
  }

  Widget _buildCartItems() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(Iconsax.bag_2, color: red, size: 24),
                SizedBox(width: 12),
                Text(
                  'Order Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey[200]),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: cartService.cart.items.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.grey[100],
              indent: 20,
              endIndent: 20,
            ),
            itemBuilder: (context, index) {
              final item = cartService.cart.items[index];
              return _buildCartItemCard(item, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(CartItem item, int index) {
    return FadeInUp(
      duration: Duration(milliseconds: 400),
      delay: Duration(milliseconds: index * 100),
      child: Dismissible(
        key: Key(item.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Iconsax.trash, color: red, size: 24),
        ),
        onDismissed: (direction) {
          cartService.removeFromCart(item.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${item.product.name} removed from cart'),
              action: SnackBarAction(
                label: 'UNDO',
                onPressed: () {
                  // Add back to cart
                  cartService.addToCart(
                    product: item.product,
                    quantity: item.quantity,
                    selectedAddons: item.selectedAddons,
                    specialInstructions: item.specialInstructions,
                  );
                },
              ),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Hero(
                tag: 'product_${item.product.id}',
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: imagebackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      item.product.imageCard,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: imagebackground,
                          child: Icon(
                            Icons.fastfood,
                            color: red,
                            size: 32,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    if (item.selectedAddons.isNotEmpty) ...[
                      Text(
                        'Add-ons: ${item.selectedAddons.join(', ')}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                    ],
                    Text(
                      '\$${item.itemTotalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: red,
                      ),
                    ),
                  ],
                ),
              ),
              _buildQuantityControls(item),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControls(CartItem item) {
    return Container(
      decoration: BoxDecoration(
        color: grey1,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            icon: Iconsax.minus,
            onTap: () => _updateQuantity(item, item.quantity - 1),
          ),
          Container(
            width: 50,
            height: 40,
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: Text(
                '${item.quantity}',
                key: ValueKey(item.quantity),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          _buildQuantityButton(
            icon: Iconsax.add,
            onTap: () => _updateQuantity(item, item.quantity + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18,
          color: red,
        ),
      ),
    );
  }

  Widget _buildPromoCodeSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.ticket_discount, color: orange, size: 24),
              SizedBox(width: 12),
              Text(
                'Promo Code',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (cartService.cart.promoCode.isNotEmpty) 
            _buildAppliedPromoCode()
          else
            _buildPromoCodeInput(),
        ],
      ),
    );
  }

  Widget _buildAppliedPromoCode() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Iconsax.tick_circle, color: Colors.green, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartService.cart.promoCode,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Text(
                  '${cartService.cart.promoDiscount}% discount applied',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => cartService.removePromoCode(),
            icon: Icon(Iconsax.close_circle, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodeInput() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: promoController,
            decoration: InputDecoration(
              hintText: 'Enter promo code',
              prefixIcon: Icon(Iconsax.ticket, color: red),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: red, width: 2),
              ),
              filled: true,
              fillColor: grey1,
            ),
          ),
        ),
        SizedBox(width: 12),
        ElevatedButton(
          onPressed: _applyPromoCode,
          style: ElevatedButton.styleFrom(
            backgroundColor: red,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    final cart = cartService.cart;
    
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.receipt, color: red, size: 24),
              SizedBox(width: 12),
              Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildSummaryRow('Subtotal', cart.subtotal),
          SizedBox(height: 12),
          _buildSummaryRow('Delivery Fee', cart.deliveryFee),
          SizedBox(height: 12),
          _buildSummaryRow('Tax', cart.tax),
          if (cart.discount > 0) ...[
            SizedBox(height: 12),
            _buildSummaryRow('Discount', -cart.discount, isDiscount: true),
          ],
          Divider(height: 32, color: Colors.grey[300]),
          _buildSummaryRow('Total', cart.total, isTotal: true),
          if (cart.deliveryFee == 0) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.truck, color: Colors.green, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Free delivery on orders over \$25',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    double amount, {
    bool isTotal = false,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.black87 : Colors.grey[700],
          ),
        ),
        Text(
          '${isDiscount ? '-' : ''}\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal
                ? red
                : isDiscount
                    ? Colors.green
                    : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _proceedToCheckout,
        style: ElevatedButton.styleFrom(
          backgroundColor: red,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: red.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.wallet_3, size: 24),
            SizedBox(width: 12),
            Text(
              'Proceed to Checkout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 12),
            Text(
              '\$${cartService.total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateQuantity(CartItem item, int newQuantity) {
    _animationController.forward().then((_) {
      cartService.updateQuantity(item.id, newQuantity);
      _animationController.reverse();
    });
  }

  void _applyPromoCode() async {
    if (promoController.text.trim().isEmpty) return;
    
    final success = await cartService.applyPromoCode(promoController.text.trim());
    
    if (success) {
      promoController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Iconsax.tick_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Promo code applied successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Iconsax.close_circle, color: Colors.white),
              SizedBox(width: 8),
              Text(cartService.error ?? 'Failed to apply promo code'),
            ],
          ),
          backgroundColor: red,
        ),
      );
    }
  }

  void _proceedToCheckout() {
    // Navigate to checkout screen (to be implemented)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Checkout functionality - Coming Soon!'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Cart'),
        content: Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              cartService.clearCart();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cart cleared successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: red),
            child: Text('Clear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}