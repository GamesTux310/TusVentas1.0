import 'package:flutter/material.dart';

class RecentTransactionsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;

  const RecentTransactionsScreen({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedTransactions = List<Map<String, dynamic>>.from(transactions)
      ..sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
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
                    'Últimos Movimientos',
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.receipt_long_outlined,
                color: Colors.white70,
                size: 40,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Text(
                  sortedTransactions.isEmpty
                      ? 'No hay movimientos registrados'
                      : 'Movimientos recientes: ${sortedTransactions.length}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: sortedTransactions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long,
                            size: 80,
                            color: const Color(0xFF2979FF).withOpacity(0.1),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Registra tu primer movimiento',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: sortedTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = sortedTransactions[index];
                        final isIncome = transaction['isIncome'] as bool;
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: ListTile(
                            dense: true, // Makes the ListTile more compact
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4, // Reduced vertical padding
                            ),
                            leading: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                                color: isIncome ? Colors.white70 : Colors.white70,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              transaction['title'] ?? 'Sin título',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Row(  // Changed to Row for more compact layout
                              children: [
                                Text(
                                  _formatDate(transaction['date'] as DateTime),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 12,
                                  ),
                                ),
                                if (transaction['products'] != null) ...[
                                  Text(
                                    ' • ${(transaction['products'] as List).length} productos',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            trailing: Text(
                              '${isIncome ? '+' : '-'}\$${transaction['amount'].toStringAsFixed(2)}',
                              style: TextStyle(
                                color: isIncome ? const Color(0xFF4CAF50) : const Color(0xFFE53935),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
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
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy, ${_formatTime(date)}';
    } else if (difference.inDays == 1) {
      return 'Ayer, ${_formatTime(date)}';
    } else if (difference.inDays < 7) {
      return '${_getDayName(date)}, ${_formatTime(date)}';
    } else {
      return '${date.day}/${date.month}/${date.year}, ${_formatTime(date)}';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getDayName(DateTime date) {
    switch (date.weekday) {
      case 1: return 'Lunes';
      case 2: return 'Martes';
      case 3: return 'Miércoles';
      case 4: return 'Jueves';
      case 5: return 'Viernes';
      case 6: return 'Sábado';
      case 7: return 'Domingo';
      default: return '';
    }
  }
}