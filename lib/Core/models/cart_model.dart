import 'package:burger_app_full/Core/models/product_model.dart';

class CartItem {
  final String id;
  final FoodModel product;
  int quantity;
  final List<String> selectedAddons;
  final String specialInstructions;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    this.selectedAddons = const [],
    this.specialInstructions = '',
    required this.addedAt,
  });

  double get totalPrice => product.price * quantity;
  
  double get addonsPrice {
    // Add logic for addon pricing if needed
    return selectedAddons.length * 0.5; // Example: $0.5 per addon
  }

  double get itemTotalPrice => totalPrice + (addonsPrice * quantity);

  CartItem copyWith({
    String? id,
    FoodModel? product,
    int? quantity,
    List<String>? selectedAddons,
    String? specialInstructions,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedAddons: selectedAddons ?? this.selectedAddons,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toMap(),
      'quantity': quantity,
      'selectedAddons': selectedAddons,
      'specialInstructions': specialInstructions,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      product: FoodModel.fromJson(json['product']),
      quantity: json['quantity'],
      selectedAddons: List<String>.from(json['selectedAddons'] ?? []),
      specialInstructions: json['specialInstructions'] ?? '',
      addedAt: DateTime.parse(json['addedAt']),
    );
  }
}

class Cart {
  final List<CartItem> items;
  final String promoCode;
  final double promoDiscount;

  Cart({
    this.items = const [],
    this.promoCode = '',
    this.promoDiscount = 0.0,
  });

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.itemTotalPrice);
  
  double get deliveryFee => subtotal > 25 ? 0.0 : 2.99; // Free delivery over $25
  
  double get tax => subtotal * 0.08; // 8% tax
  
  double get discount => subtotal * (promoDiscount / 100);
  
  double get total => subtotal + deliveryFee + tax - discount;

  bool get isEmpty => items.isEmpty;
  
  bool get isNotEmpty => items.isNotEmpty;

  Cart copyWith({
    List<CartItem>? items,
    String? promoCode,
    double? promoDiscount,
  }) {
    return Cart(
      items: items ?? this.items,
      promoCode: promoCode ?? this.promoCode,
      promoDiscount: promoDiscount ?? this.promoDiscount,
    );
  }
}

// Available addons for products
class ProductAddon {
  final String id;
  final String name;
  final double price;
  final String description;
  final String? imageUrl;

  ProductAddon({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.imageUrl,
  });
}

final List<ProductAddon> availableAddons = [
  ProductAddon(
    id: 'extra_cheese',
    name: 'Extra Cheese',
    price: 0.99,
    description: 'Double the cheese, double the flavor',
  ),
  ProductAddon(
    id: 'bacon',
    name: 'Bacon',
    price: 1.49,
    description: 'Crispy bacon strips',
  ),
  ProductAddon(
    id: 'avocado',
    name: 'Avocado',
    price: 1.99,
    description: 'Fresh sliced avocado',
  ),
  ProductAddon(
    id: 'spicy_sauce',
    name: 'Spicy Sauce',
    price: 0.50,
    description: 'Our signature spicy sauce',
  ),
  ProductAddon(
    id: 'extra_patty',
    name: 'Extra Patty',
    price: 2.99,
    description: 'Additional beef patty',
  ),
];