import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../cart/presentation/screens/cart_page.dart';
import '../orders/orders_page.dart';
import '../profile/presentation/screens/chat_list_screen.dart';
import '../profile/presentation/screens/supplier_category_page.dart';
import '../profile/presentation/screens/supplier_payout_page.dart';
import '../profile/presentation/screens/supplier_profile_screen.dart';
import '../profile/presentation/screens/supplier_wishlist_page.dart';
import '../supplier/inventory/ui/add_product_page.dart';

class SupplierDashboard extends StatefulWidget {
  const SupplierDashboard({super.key});

  @override
  State<SupplierDashboard> createState() => _SupplierDashboardState();
}

class _SupplierDashboardState extends State<SupplierDashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  late final List<Widget> _pages = [
    const SupplierDashboardHome(),
    const SupplierCategoryPage(),
    const SupplierWishlistPage(),
    const OrdersPage(),
    const SupplierProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductPage()),
          );
        },
        backgroundColor: const Color(0xFF4CA6A8),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Product",
            style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4CA6A8),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view), label: "Category"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: "Wishlist"),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: "Order"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}

class SupplierDashboardHome extends StatefulWidget {
  const SupplierDashboardHome({super.key});

  @override
  State<SupplierDashboardHome> createState() => _SupplierDashboardHomeState();
}

class _SupplierDashboardHomeState extends State<SupplierDashboardHome> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildTopBar(context),
          const SizedBox(height: 20),
          _buildPromoBanner(),
          const SizedBox(height: 30),

          _buildSectionHeader("Categories"),
          const SizedBox(height: 15),
          _buildCategoryList(context),

          const SizedBox(height: 30),
          _buildSectionHeader("My Products"),
          const SizedBox(height: 15),
          _buildSupplierProducts(),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // ---------------- TOP BAR ----------------
  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(Icons.grid_view_rounded,
              color: Theme.of(context).iconTheme.color),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartPage()),
            );
          },
          child: CircleAvatar(
            backgroundColor: Theme.of(context).cardColor,
            child: Icon(Icons.shopping_cart_outlined,
                color: Theme.of(context).iconTheme.color),
          ),
        ),
      ],
    );
  }

  // ---------------- PROMO ----------------
  Widget _buildPromoBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFF63B4B7), Color(0xFF4CA6A8)],
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Supplier Growth",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "Manage your products easily",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // ---------------- SECTION HEADER ----------------
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D2D2D),
      ),
    );
  }

  // ---------------- CATEGORY LIST ----------------
  Widget _buildCategoryList(BuildContext context) {
    final cats = [
      {"icon": Icons.receipt_long, "label": "Orders"},
      {"icon": Icons.people, "label": "Clients"},
      {"icon": Icons.account_balance_wallet, "label": "Payouts"},
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 25),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (cats[index]['label'] == "Orders") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const OrdersPage()));
              } else if (cats[index]['label'] == "Clients") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ChatListScreen()));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SupplierPayoutPage()),
                );
              }
            },
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Theme.of(context).cardColor,
                  child: Icon(
                    cats[index]['icon'] as IconData,
                    color: const Color(0xFF4CA6A8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(cats[index]['label'] as String),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------- ALL PRODUCTS FROM SUPABASE ----------------
  Widget _buildSupplierProducts() {
    final supabase = Supabase.instance.client;

    return FutureBuilder<List<dynamic>>(
      future: supabase
          .from('products')
          .select()
          .order('created_at', ascending: false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Column(
            children: [
              const Text("Failed to load products", style: TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
              Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => setState(() {}),
                child: const Text("Retry"),
              ),
            ],
          );
        }

        final products = snapshot.data ?? [];
        if (products.isEmpty) {
          return const Center(
            child: Column(
              children: [
                Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text(
                  "No products found",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Products: ${products.length}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final p = products[index];

                final imageUrl = p['image_url'];
                final productName = p['name'] ?? "Unnamed Product";
                final category = p['category'] ?? "No Category";
                final price = p['price']?.toString() ?? "0.00";
                final supplierCode = p['supplier_code'] ?? "--";

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Product Image
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: imageUrl != null && imageUrl.toString().isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.image, color: Colors.grey),
                                )
                              : const Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 15),
                      
                      // Product Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              category,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Supplier: $supplierCode",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Price and Actions
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "₹$price",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CA6A8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // TODO: Edit product functionality
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Edit product - TODO")),
                                  );
                                },
                                icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  // TODO: Delete product functionality
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Delete product - TODO")),
                                  );
                                },
                                icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}