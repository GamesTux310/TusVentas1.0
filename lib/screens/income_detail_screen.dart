
import 'package:flutter/material.dart';

class IncomeDetailScreen extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;

  const IncomeDetailScreen({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
                      onPressed: () => Navigator.pop(context),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: 40),
                        child: Text(
                          'Detalle de Ingresos',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (transactions.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 64,
                        color: Colors.white.withOpacity(0.1),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay ingresos registrados',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[transactions.length - 1 - index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Implementar vista detallada si es necesario
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        transaction['title'] ?? 'Sin título',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16, // Slightly smaller font size
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '+\$${transaction['amount'].toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Color(0xFF4CAF50),
                                        fontSize: 18, // Slightly smaller font size
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4), // Reduced spacing
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatDate(transaction['date'] as DateTime),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                if (transaction['products'] != null) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.shopping_bag_outlined,
                                        size: 14,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${transaction['products'].fold<int>(0, (int sum, Map<String, dynamic> product) => sum + (product['quantity'] as int? ?? 1))} productos x ${(transaction['products'] as List).first['name']}', // Updated line
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Removed individual product names
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}