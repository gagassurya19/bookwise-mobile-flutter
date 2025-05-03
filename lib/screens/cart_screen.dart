import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';
import '../utils/api_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  Future<void> _checkout(BuildContext context) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found. Please login again.')),
      );
      return;
    }

    if (cartProvider.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty')),
      );
      return;
    }

    if (cartProvider.paymentMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    if (cartProvider.paymentEvidence.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload payment evidence')),
      );
      return;
    }

    try {
      final response = await ApiService.createTransaction(
        cartProvider.toCheckoutJson(userId),
      );

      if (response.statusCode == 200) {
        cartProvider.clearCart();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Checkout successful!')),
        );
        Navigator.pushReplacementNamed(context, '/transactions');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Checkout failed: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during checkout: $e')),
      );
    }
  }

  void _showCheckoutDialog(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final TextEditingController urlController = TextEditingController();
    DateTime selectedDateFrom = DateTime.now();
    DateTime selectedDateTo = DateTime.now().add(const Duration(days: 7));
    String? selectedPaymentMethod;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Checkout Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Borrow Period Selection
                const Text(
                  'Borrow Period',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('From'),
                          InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: selectedDateFrom,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (date != null) {
                                setState(() {
                                  selectedDateFrom = date;
                                  // Update cart items with new date
                                  for (var item in cartProvider.items) {
                                    cartProvider.updateItemDate(item.id, date, selectedDateTo);
                                  }
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      selectedDateFrom.toString().split(' ')[0],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.calendar_today, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('To'),
                          InkWell(
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: selectedDateTo,
                                firstDate: selectedDateFrom,
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (date != null) {
                                setState(() {
                                  selectedDateTo = date;
                                  // Update cart items with new date
                                  for (var item in cartProvider.items) {
                                    cartProvider.updateItemDate(item.id, selectedDateFrom, date);
                                  }
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      selectedDateTo.toString().split(' ')[0],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.calendar_today, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Payment Method Selection
                const Text(
                  'Payment Method',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedPaymentMethod,
                      isExpanded: true,
                      hint: const Text('Select payment method'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Bank Transfer',
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.account_balance),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Bank Transfer',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Credit Card',
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.credit_card),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Credit Card',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'E-Wallet',
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.payment),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'E-Wallet',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedPaymentMethod = value;
                            cartProvider.setPaymentMethod(value);
                          });
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Payment Evidence
                const Text(
                  'Payment Evidence',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    labelText: 'Payment Evidence URL',
                    hintText: 'Enter the URL of your payment evidence',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).unfocus();
                  },
                  onTapOutside: (_) {
                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please upload your payment evidence (receipt, screenshot, etc.) to a file sharing service and paste the URL here.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                
                if (selectedPaymentMethod == null) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Please select a payment method')),
                  );
                  return;
                }

                if (urlController.text.isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Please enter payment evidence URL')),
                  );
                  return;
                }

                // Save the payment details
                cartProvider.setPaymentMethod(selectedPaymentMethod!);
                cartProvider.setPaymentEvidence(urlController.text);

                // Close the dialog
                Navigator.pop(dialogContext);

                // Show loading indicator
                if (!dialogContext.mounted) return;
                BuildContext? loadingContext;
                showDialog(
                  context: dialogContext,
                  barrierDismissible: false,
                  builder: (context) {
                    loadingContext = context;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                try {
                  // Get user ID
                  final prefs = await SharedPreferences.getInstance();
                  final userId = prefs.getString('userId');

                  if (userId == null) {
                    if (loadingContext != null && loadingContext!.mounted) {
                      Navigator.pop(loadingContext!);
                    }
                    if (!dialogContext.mounted) return;
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(content: Text('User ID not found. Please login again.')),
                    );
                    return;
                  }

                  // Create transaction
                  final response = await ApiService.createTransaction(
                    cartProvider.toCheckoutJson(userId),
                  );

                  // Close loading indicator
                  if (loadingContext != null && loadingContext!.mounted) {
                    Navigator.pop(loadingContext!);
                  }

                  if (response.statusCode == 200) {
                    // Clear cart and show success message
                    cartProvider.clearCart();
                    if (!dialogContext.mounted) return;
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(content: Text('Checkout successful!')),
                    );

                    // Navigate to transaction screen
                    if (!dialogContext.mounted) return;
                    Navigator.pushReplacementNamed(dialogContext, '/transactions');
                  } else {
                    if (!dialogContext.mounted) return;
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(content: Text('Checkout failed: ${response.body}')),
                    );
                  }
                } catch (e) {
                  // Close loading indicator if it's still showing
                  if (loadingContext != null && loadingContext!.mounted) {
                    Navigator.pop(loadingContext!);
                  }
                  if (!dialogContext.mounted) return;
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text('Error during checkout: $e')),
                  );
                }
              },
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.image,
                            width: 60,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.image_not_supported),
                              );
                            },
                          ),
                        ),
                        title: Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.author),
                            Text(
                              'Late Fee: \$${item.lateFee.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Borrow Period: ${item.dateFrom.toString().split(' ')[0]} to ${item.dateTo.toString().split(' ')[0]}',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => cart.removeItem(item.id),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Fee:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${cart.totalFee.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _showCheckoutDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Proceed to Checkout',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
} 