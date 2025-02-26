import 'package:flutter/material.dart';
import 'dart:async'; // Add this import for Timer
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'add_product_screen.dart';  // Update this import
import 'settings_screen.dart';
import 'income_detail_screen.dart';
import 'expense_detail_screen.dart';
import 'new_sale_screen.dart';  // Add this import
import 'register_expense_screen.dart';  // Add this import
import 'inventory_screen.dart';
import 'recent_transactions_screen.dart';
import 'learn_screen.dart'; // Ensure this import is present

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'Usuario';
  int _daysUntilPayday = 0;
  bool _notificationsEnabled = true;
  double _totalIncome = 0.0;  // Add this
  double _totalExpenses = 0.0;  // Add this
  final List<Map<String, dynamic>> _transactions = [];  // Add this
  
  // Declare the _bannerAd variable
  BannerAd? _bannerAd;

  String mostrarTextoQuincena(int diasParaQuincena) {
    if (diasParaQuincena <= 0) return "¡Ya es quincena! 🎉";
    return diasParaQuincena == 1
        ? "¡Falta 1 día para la quincena!"
        : "¡Faltan $diasParaQuincena días para la quincena!";
  }

  final List<String> _motivationalPhrases = [
    'Planifica hoy, prospera mañana.',
    'Esfuerzos repetidos logran éxito.', // Acortada
    'La disciplina es clave.',
    'Crea tus oportunidades.',
    'Cree en tus sueños.',
    'Ama lo que haces.',
    'La felicidad es éxito.',
    'Haz que los días cuenten.',
    'Fracasa para aprender.',
    'Reacciona bien.',
    'Éxito antes del trabajo.',
    'Motivación y hábito.',
    'No te detengas.',
    'Fracasa sin perder ánimo.',
    'Limítate menos.',
    'Esfuerzos diarios.',
    'Empieza ya.',
    'Continúa con valor.',
    'Esfuerzos repetidos.',
    'El éxito es persistir.',
  ];

  int _currentPhraseIndex = 0;

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-1528096512203588/9587153935', // Production ad unit ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
          print('Banner ad loaded successfully');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Banner ad failed to load: $error');
        },
      ),
    )..load();
  }

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _startPhraseRotation();
  }

  void _startPhraseRotation() {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        _currentPhraseIndex = (_currentPhraseIndex + 1) % _motivationalPhrases.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF000000), Color(0xFF1A1A2E), Color(0xFF16213E)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '¡Hola, $_userName! 👋',
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Bienvenido de vuelta',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings, color: Colors.white, size: 28),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SettingsScreen(
                                      initialName: _userName,
                                      initialDays: _daysUntilPayday,
                                      initialNotifications: _notificationsEnabled,
                                    ),
                                  ),
                                );
                                if (result != null && result is Map<String, dynamic>) {
                                  setState(() {
                                    _userName = result['name'];
                                    _daysUntilPayday = result['days'];
                                    _notificationsEnabled = result['notifications'];
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Highlighted Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mostrarTextoQuincena(_daysUntilPayday),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 800),
                                transitionBuilder: (Widget child, Animation<double> animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0.0, 0.2),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Text(
                                  _motivationalPhrases[_currentPhraseIndex],
                                  key: ValueKey<int>(_currentPhraseIndex),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white.withOpacity(0.7),
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        // Financial Summary
                        const Text(
                          'Resumen Financiero',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _InfoCard(
                                title: 'Ingresos',
                                amount: '\$${_totalIncome.toStringAsFixed(2)}',
                                color: const Color(0xFF00C853),
                                icon: MdiIcons.trendingUp,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => IncomeDetailScreen(
                                        transactions: _transactions.where((t) => t['isIncome']).toList(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _InfoCard(
                                title: 'Gastos',
                                amount: '\$${_totalExpenses.toStringAsFixed(2)}',  // Update this line
                                color: const Color(0xFFD50000),
                                icon: MdiIcons.trendingDown,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ExpenseDetailScreen(
                                        transactions: _transactions.where((t) => !t['isIncome']).toList(), // Pass expenses
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        
                        // Management Section
                        const Text(
                          'Gestión',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildActionRow([
                          const _ActionButton('Nueva Venta', MdiIcons.cartOutline, Color(0xFF00E676)), // Updated icon
                          const _ActionButton('Nuevo Gasto', MdiIcons.receipt, Color(0xFFB71C1C)), // Updated icon
                        ]),
                        const SizedBox(height: 16),
                        _buildActionRow([
                          const _ActionButton('Nuevo Producto', MdiIcons.packageVariantClosed, Color(0xFFFF6D00)), // Updated icon
                          const _ActionButton('Inventario', MdiIcons.clipboardListOutline, Color(0xFF2979FF)), // Updated icon
                        ]),
                        const SizedBox(height: 16),
                        _buildActionRow([
                          const _ActionButton('Últimos Movimientos', MdiIcons.chartBar, Color(0xFF616161)),
                          const _ActionButton('Aprende Aquí!', MdiIcons.schoolOutline, Color(0xFF0091EA)),
                        ]),
                        const SizedBox(height: 30), // Añade un espaciador
                        _buildRecentActivity(), // Añade la sección de Actividad Reciente
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_bannerAd != null)
            Container(
              color: Colors.black,
              alignment: Alignment.center,
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
    );
  }

  Widget _buildActionRow(List<Widget> children) {
    return Row(
      children: children
          .map((child) => Expanded(child: child))
          .toList()
          .expand((widget) => [widget, const SizedBox(width: 16)])
          .toList()
        ..removeLast(),
    );
  }

  // Mantener solo esta versión del método _buildRecentActivity
  Widget _buildRecentActivity() {
    final recentTransactions = _transactions.isEmpty
        ? []
        : List<Map<String, dynamic>>.from(_transactions)
          ..sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime))
          ..take(3).toList();
  
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Actividad Reciente',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecentTransactionsScreen(
                      transactions: _transactions,
                    ),
                  ),
                );
              },
              child: const Text(
                'Ver todo',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        recentTransactions.isEmpty
            ? const Text(
                'No hay actividad reciente.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              )
            : Column(
                children: List.generate(
                  recentTransactions.length > 3 ? 3 : recentTransactions.length,
                  (index) {
                    final transaction = recentTransactions[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1 - (index * 0.02)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction['title'] ?? 'Sin título',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(1 - (index * 0.2)),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${transaction['date'].day}/${transaction['date'].month}/${transaction['date'].year}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7 - (index * 0.1)),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${transaction['isIncome'] ? '+' : '-'}\$${transaction['amount'].toStringAsFixed(2)}',
                            style: TextStyle(
                              color: transaction['isIncome'] ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _ActionButton(this.label, this.icon, this.color);

  // Update the method signature to be async
  Future<void> _handlePress(BuildContext context) async {
    switch (label) {
      case 'Nueva Venta':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NewSaleScreen(),
          ),
        ).then((result) {
          if (result != null && result is Map<String, dynamic>) {
            final homeState = context.findAncestorStateOfType<_HomeScreenState>();
            if (homeState != null) {
              homeState.setState(() {
                homeState._totalIncome += result['amount'];
                homeState._transactions.add(result);
              });
            }
          }
        });
        break;
      case 'Nuevo Gasto':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RegisterExpenseScreen(),
          ),
        ).then((result) {
          if (result != null && result is Map<String, dynamic>) {
            // ignore: use_build_context_synchronously
            final homeState = context.findAncestorStateOfType<_HomeScreenState>();
            if (homeState != null) {
              homeState.setState(() {
                homeState._transactions.add({
                  ...result,
                  'isIncome': false, // Ensure isIncome key is present
                });
                homeState._totalExpenses += result['amount'];
              });
            }
          }
        });
        break;
      case 'Nuevo Producto':
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddProductScreen(),
          ),
        );
        if (result != null && result is Map<String, dynamic>) {
          // Navigate to inventory screen and pass the product
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InventoryScreen(newProduct: result),
            ),
          );
        }
        break;
      case 'Inventario':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const InventoryScreen(),
          ),
        );
        break;
      // En el método _handlePress del _ActionButton
      case 'Últimos Movimientos':
        final homeState = context.findAncestorStateOfType<_HomeScreenState>();
        if (homeState != null) {
          print('Transactions count: ${homeState._transactions.length}'); // Debug print
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecentTransactionsScreen(
                transactions: homeState._transactions,
              ),
            ),
          );
        }
        break;
      case 'Aprende Aquí!':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LearnScreen(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handlePress(context),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class _InfoCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const _InfoCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color.withOpacity(0.7), size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                amount,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
