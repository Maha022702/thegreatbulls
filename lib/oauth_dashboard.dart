import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'kite_oauth_service.dart';

class OrderDialog extends StatefulWidget {
  const OrderDialog({super.key});

  @override
  State<OrderDialog> createState() => _OrderDialogState();
}

class _OrderDialogState extends State<OrderDialog> {
  final _formKey = GlobalKey<FormState>();
  String _variety = 'regular';
  String _exchange = 'NSE';
  String _tradingsymbol = '';
  String _transactionType = 'BUY';
  String _orderType = 'MARKET';
  String _product = 'CNC';
  int _quantity = 0;
  double? _price;
  double? _triggerPrice;
  bool _isLoading = false;

  final _tradingsymbolController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _triggerPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text(
        'Place New Order',
        style: TextStyle(color: Colors.amber),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Variety
                DropdownButtonFormField<String>(
                  value: _variety,
                  decoration: const InputDecoration(
                    labelText: 'Order Variety',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                  ),
                  dropdownColor: Colors.grey[800],
                  style: const TextStyle(color: Colors.white),
                  items: const [
                    DropdownMenuItem(value: 'regular', child: Text('Regular')),
                    DropdownMenuItem(value: 'bo', child: Text('Bracket Order')),
                    DropdownMenuItem(value: 'co', child: Text('Cover Order')),
                    DropdownMenuItem(value: 'iceberg', child: Text('Iceberg')),
                    DropdownMenuItem(value: 'auction', child: Text('Auction')),
                  ],
                  onChanged: (value) => setState(() => _variety = value!),
                ),

                const SizedBox(height: 16),

                // Exchange
                DropdownButtonFormField<String>(
                  value: _exchange,
                  decoration: const InputDecoration(
                    labelText: 'Exchange',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                  ),
                  dropdownColor: Colors.grey[800],
                  style: const TextStyle(color: Colors.white),
                  items: const [
                    DropdownMenuItem(value: 'NSE', child: Text('NSE')),
                    DropdownMenuItem(value: 'BSE', child: Text('BSE')),
                    DropdownMenuItem(value: 'MCX', child: Text('MCX')),
                    DropdownMenuItem(value: 'NCDEX', child: Text('NCDEX')),
                  ],
                  onChanged: (value) => setState(() => _exchange = value!),
                ),

                const SizedBox(height: 16),

                // Trading Symbol
                TextFormField(
                  controller: _tradingsymbolController,
                  decoration: const InputDecoration(
                    labelText: 'Trading Symbol (e.g., RELIANCE)',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),

                const SizedBox(height: 16),

                // Transaction Type
                DropdownButtonFormField<String>(
                  value: _transactionType,
                  decoration: const InputDecoration(
                    labelText: 'Transaction Type',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                  ),
                  dropdownColor: Colors.grey[800],
                  style: const TextStyle(color: Colors.white),
                  items: const [
                    DropdownMenuItem(value: 'BUY', child: Text('BUY')),
                    DropdownMenuItem(value: 'SELL', child: Text('SELL')),
                  ],
                  onChanged: (value) => setState(() => _transactionType = value!),
                ),

                const SizedBox(height: 16),

                // Order Type
                DropdownButtonFormField<String>(
                  value: _orderType,
                  decoration: const InputDecoration(
                    labelText: 'Order Type',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                  ),
                  dropdownColor: Colors.grey[800],
                  style: const TextStyle(color: Colors.white),
                  items: const [
                    DropdownMenuItem(value: 'MARKET', child: Text('MARKET')),
                    DropdownMenuItem(value: 'LIMIT', child: Text('LIMIT')),
                    DropdownMenuItem(value: 'SL', child: Text('STOP LOSS')),
                    DropdownMenuItem(value: 'SL-M', child: Text('STOP LOSS MARKET')),
                  ],
                  onChanged: (value) => setState(() => _orderType = value!),
                ),

                const SizedBox(height: 16),

                // Product
                DropdownButtonFormField<String>(
                  value: _product,
                  decoration: const InputDecoration(
                    labelText: 'Product',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                  ),
                  dropdownColor: Colors.grey[800],
                  style: const TextStyle(color: Colors.white),
                  items: const [
                    DropdownMenuItem(value: 'CNC', child: Text('CNC (Delivery)')),
                    DropdownMenuItem(value: 'MIS', child: Text('MIS (Intraday)')),
                    DropdownMenuItem(value: 'NRML', child: Text('NRML (Normal)')),
                  ],
                  onChanged: (value) => setState(() => _product = value!),
                ),

                const SizedBox(height: 16),

                // Quantity
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),

                const SizedBox(height: 16),

                // Price (for LIMIT orders)
                if (_orderType == 'LIMIT')
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),

                // Trigger Price (for SL/SL-M orders)
                if (_orderType == 'SL' || _orderType == 'SL-M')
                  TextFormField(
                    controller: _triggerPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Trigger Price',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _placeOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Place Order'),
        ),
      ],
    );
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await KiteOAuthService.placeOrder(
        variety: _variety,
        exchange: _exchange,
        tradingsymbol: _tradingsymbolController.text.trim().toUpperCase(),
        transactionType: _transactionType,
        orderType: _orderType,
        product: _product,
        quantity: int.parse(_quantityController.text),
        price: _priceController.text.isNotEmpty ? double.parse(_priceController.text) : null,
        triggerPrice: _triggerPriceController.text.isNotEmpty ? double.parse(_triggerPriceController.text) : null,
      );

      if (result != null && result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order placed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
        // Refresh data
        if (context.mounted) {
          context.findAncestorStateOfType<_OAuthDashboardState>()?._loadAllData();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to place order: ${result?['error'] ?? 'Unknown error'}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error placing order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _tradingsymbolController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _triggerPriceController.dispose();
    super.dispose();
  }
}

class OAuthDashboard extends StatefulWidget {
  const OAuthDashboard({super.key});

  @override
  State<OAuthDashboard> createState() => _OAuthDashboardState();
}

class _OAuthDashboardState extends State<OAuthDashboard> {
  bool _isLoading = true;
  Map<String, dynamic>? _userProfile;
  Map<String, dynamic>? _margins;
  Map<String, dynamic>? _holdings;
  Map<String, dynamic>? _orders;
  Map<String, dynamic>? _positions;
  Map<String, dynamic>? _quotes;
  String? _error;

  // Navigation
  int _selectedIndex = 0;
  final List<String> _navigationItems = [
    'Dashboard',
    'Trading',
    'Orders',
    'Positions',
    'Holdings',
    'Portfolio',
    'Watchlist',
    'Analytics',
  ];

  final List<IconData> _navigationIcons = [
    Icons.dashboard,
    Icons.trending_up,
    Icons.receipt,
    Icons.account_balance,
    Icons.inventory,
    Icons.pie_chart,
    Icons.visibility,
    Icons.analytics,
  ];

  @override
  void initState() {
    super.initState();
    _checkLoginAndLoadData();
  }

  Future<void> _checkLoginAndLoadData() async {
    print('🔍 Dashboard: Checking login status...');
    final isLoggedIn = await KiteOAuthService.isLoggedIn();
    print('🔍 Dashboard: Login status result: $isLoggedIn');

    // Additional debugging
    final accessToken = await KiteOAuthService.getAccessTokenForDebug();
    final publicToken = await KiteOAuthService.getPublicTokenForDebug();
    print('🔍 Dashboard: Access Token exists: ${accessToken != null}');
    print('🔍 Dashboard: Public Token exists: ${publicToken != null}');

    if (!isLoggedIn) {
      print('🔍 Dashboard: User is not logged in, redirecting to login page...');
      if (mounted) {
        context.go('/');
      }
      return;
    }
    print('🔍 Dashboard: User is logged in, loading data...');
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        KiteOAuthService.getUserProfile(),
        KiteOAuthService.getMargins(),
        KiteOAuthService.getHoldings(),
        KiteOAuthService.getOrders(),
        KiteOAuthService.getPositions(),
        KiteOAuthService.getQuote('NSE:RELIANCE,NSE:TCS,NSE:INFY'),
      ]);

      setState(() {
        _userProfile = results[0] as Map<String, dynamic>?;
        _margins = results[1] as Map<String, dynamic>?;
        _holdings = results[2] as Map<String, dynamic>?;
        _orders = results[3] as Map<String, dynamic>?;
        _positions = results[4] as Map<String, dynamic>?;
        _quotes = results[5] as Map<String, dynamic>?;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onNavigationTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return _buildTradingContent();
      case 2:
        return _buildOrdersContent();
      case 3:
        return _buildPositionsContent();
      case 4:
        return _buildHoldingsContent();
      case 5:
        return _buildPortfolioContent();
      case 6:
        return _buildWatchlistContent();
      case 7:
        return _buildAnalyticsContent();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to The Great Bulls',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your comprehensive trading platform for smart investments',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _onNavigationTap(1), // Trading
                      icon: const Icon(Icons.show_chart),
                      label: const Text('Start Trading'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () => _onNavigationTap(2), // Orders
                      icon: const Icon(Icons.list_alt),
                      label: const Text('View Orders'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Quick Stats Grid
          GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard('Total Orders', _orders?.length.toString() ?? '0', Icons.receipt),
              _buildStatCard('Open Positions', _positions?.length.toString() ?? '0', Icons.trending_up),
              _buildStatCard('Holdings', _holdings?.length.toString() ?? '0', Icons.account_balance_wallet),
              _buildStatCard('Margin Available', _margins?['net']?.toStringAsFixed(2) ?? '0.00', Icons.account_balance),
            ],
          ),

          const SizedBox(height: 30),

          // Recent Activity
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                if (_orders != null && _orders!.isNotEmpty)
                  ...(_orders!['data'] as List?)!.take(5).map((order) => _buildActivityItem(order))
                else
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'No recent activity',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradingContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trading Interface Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trading Interface',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Place, modify, and cancel orders with advanced trading tools',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _showOrderDialog,
                    icon: const Icon(Icons.add, size: 28),
                    label: const Text('Place New Order'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Market Data Section
          if (_quotes != null) _buildQuotesCard(),

          const SizedBox(height: 20),

          // Quick Actions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionButton(
                        'Modify Order',
                        Icons.edit,
                        () => _showModifyOrderDialog(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildQuickActionButton(
                        'Cancel Order',
                        Icons.cancel,
                        () => _showCancelOrderDialog(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Orders Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order History',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Track and manage all your orders',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _loadOrders,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Orders List
          if (_orders != null) _buildOrdersCard() else _buildLoadingCard('Loading orders...'),
        ],
      ),
    );
  }

  Widget _buildPositionsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Positions Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Positions',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Monitor your current positions and P&L',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _loadPositions,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Positions List
          if (_positions != null) _buildPositionsCard() else _buildLoadingCard('Loading positions...'),
        ],
      ),
    );
  }

  Widget _buildHoldingsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Holdings Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Holdings',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'View your investment portfolio',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _loadHoldings,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Holdings List
          if (_holdings != null) _buildHoldingsCard() else _buildLoadingCard('Loading holdings...'),
        ],
      ),
    );
  }

  Widget _buildPortfolioContent() {
    return _buildComingSoonContent('Portfolio Analytics');
  }

  Widget _buildWatchlistContent() {
    return _buildComingSoonContent('Watchlist');
  }

  Widget _buildAnalyticsContent() {
    return _buildComingSoonContent('Analytics & Reports');
  }

  Widget _buildComingSoonContent(String title) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time,
              size: 64,
              color: Colors.amber.withOpacity(0.5),
            ),
            const SizedBox(height: 20),
            Text(
              '$title - Coming Soon',
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'This feature is under development and will be available soon.',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.amber, size: 32),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> order) {
    final status = order['status'] ?? 'Unknown';
    final tradingsymbol = order['tradingsymbol'] ?? 'N/A';
    final transactionType = order['transaction_type'] ?? 'N/A';
    final quantity = order['quantity'] ?? 0;
    final orderType = order['order_type'] ?? 'N/A';

    Color statusColor;
    switch (status.toLowerCase()) {
      case 'complete':
        statusColor = Colors.green;
        break;
      case 'open':
        statusColor = Colors.blue;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$transactionType $tradingsymbol',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Qty: $quantity | Type: $orderType | Status: $status',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            order['order_timestamp']?.split('T')[0] ?? '',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[700],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildLoadingCard(String message) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          children: [
            const CircularProgressIndicator(color: Colors.amber),
            const SizedBox(height: 20),
            Text(message, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await KiteOAuthService.logout();
    if (mounted) {
      context.go('/');
    }
  }

  Future<void> _checkTokenStatus() async {
    final isLoggedIn = await KiteOAuthService.isLoggedIn();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login Status: ${isLoggedIn ? 'LOGGED IN' : 'NOT LOGGED IN'}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingScreen();
    }

    if (_error != null) {
      return _buildErrorScreen();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 280,
            color: Colors.grey[900],
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.amber, width: 1),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.show_chart,
                        color: Colors.amber,
                        size: 40,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'The Great Bulls',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Trading Platform',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Navigation Items
                Expanded(
                  child: ListView.builder(
                    itemCount: _navigationItems.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedIndex == index;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.amber.withOpacity(0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border(
                            left: BorderSide(
                              color: isSelected ? Colors.amber : Colors.transparent,
                              width: 4,
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(
                            _navigationIcons[index],
                            color: isSelected ? Colors.amber : Colors.white70,
                          ),
                          title: Text(
                            _navigationItems[index],
                            style: TextStyle(
                              color: isSelected ? Colors.amber : Colors.white70,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          onTap: () => _onNavigationTap(index),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Footer with logout
                Container(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout, color: Colors.black),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 45),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top Bar
                Container(
                  height: 60,
                  color: Colors.grey[850],
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _navigationItems[_selectedIndex],
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _loadAllData,
                            icon: const Icon(Icons.refresh, color: Colors.amber),
                            tooltip: 'Refresh Data',
                          ),
                          IconButton(
                            onPressed: _checkTokenStatus,
                            icon: const Icon(Icons.info, color: Colors.blue),
                            tooltip: 'Check Token Status',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Content Area
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: _getCurrentPage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.amber),
          SizedBox(height: 20),
          Text(
            'Loading your trading data...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 60),
          const SizedBox(height: 20),
          Text(
            'Error loading data: $_error',
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadAllData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileCard() {
    final profile = _userProfile?['data'];
    if (profile == null) {
      return _buildDataCard('👤 User Profile', const Text('No profile data', style: TextStyle(color: Colors.white70)));
    }
    return _buildDataCard(
      '👤 User Profile',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('User ID', profile['user_id']?.toString() ?? 'N/A'),
          _buildInfoRow('Name', profile['user_name']?.toString() ?? 'N/A'),
          _buildInfoRow('Email', profile['email']?.toString() ?? 'N/A'),
          _buildInfoRow('Broker', profile['broker']?.toString() ?? 'N/A'),
          _buildInfoRow('User Type', profile['user_type']?.toString() ?? 'N/A'),
          _buildInfoRow('Products', (profile['products'] as List?)?.join(', ') ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildMarginsCard() {
    final margins = _margins?['data'];
    if (margins == null) {
      return _buildDataCard('💰 Account Margins', const Text('No margin data', style: TextStyle(color: Colors.white70)));
    }

    final equity = margins['equity'] as Map<String, dynamic>?;
    if (equity == null) {
      return _buildDataCard('💰 Account Margins', const Text('No equity data', style: TextStyle(color: Colors.white70)));
    }

    final available = equity['available'] as Map<String, dynamic>? ?? {};
    final used = equity['utilised'] as Map<String, dynamic>? ?? equity['used'] as Map<String, dynamic>? ?? {};

    return _buildDataCard(
      '💰 Account Margins',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Net Margin', '₹${_formatNumber(equity['net'])}'),
          const Divider(color: Colors.white24),
          const Text('Available:', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          _buildInfoRow('Cash', '₹${_formatNumber(available['cash'])}'),
          _buildInfoRow('Collateral', '₹${_formatNumber(available['collateral'])}'),
          const Divider(color: Colors.white24),
          const Text('Used:', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          _buildInfoRow('Debits', '₹${_formatNumber(used['debits'])}'),
          _buildInfoRow('M2M', '₹${_formatNumber(used['m2m_unrealised'])}'),
        ],
      ),
    );
  }

  String _formatNumber(dynamic value) {
    if (value == null) return '0.00';
    if (value is num) return value.toStringAsFixed(2);
    return value.toString();
  }

  Widget _buildHoldingsCard() {
    final holdings = _holdings?['data'] as List?;
    return _buildDataCard(
      '📈 Holdings (${holdings?.length ?? 0})',
      holdings != null && holdings.isNotEmpty
          ? Column(
              children: holdings.map((holding) => _buildHoldingItem(holding as Map<String, dynamic>)).toList(),
            )
          : const Text('No holdings found', style: TextStyle(color: Colors.white70)),
    );
  }

  Widget _buildHoldingItem(Map<String, dynamic> holding) {
    final pnlValue = holding['pnl'];
    final pnl = (pnlValue is num) ? pnlValue.toDouble() : 0.0;
    final pnlColor = pnl >= 0 ? Colors.green : Colors.red;
    final lastPrice = holding['last_price'];
    final lastPriceStr = (lastPrice is num) ? lastPrice.toStringAsFixed(2) : '0.00';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                holding['tradingsymbol']?.toString() ?? 'N/A',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹$lastPriceStr',
                style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Qty: ${holding['quantity'] ?? 0}',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              Text(
                '${pnl >= 0 ? '+' : ''}₹${pnl.toStringAsFixed(2)}',
                style: TextStyle(color: pnlColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersCard() {
    final orders = _orders?['data'] as List?;
    return _buildDataCard(
      '📋 Orders (${orders?.length ?? 0})',
      orders != null && orders.isNotEmpty
          ? Column(
              children: orders.take(5).map((order) => _buildOrderItem(order as Map<String, dynamic>)).toList(),
            )
          : const Text('No orders found', style: TextStyle(color: Colors.white70)),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
    final status = order['status']?.toString() ?? 'UNKNOWN';
    final statusColor = status == 'COMPLETE' ? Colors.green :
                       status == 'OPEN' ? Colors.amber : Colors.red;
    final price = order['price'];
    final priceStr = (price is num) ? price.toStringAsFixed(2) : '0.00';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${order['tradingsymbol']?.toString() ?? 'N/A'} (${order['transaction_type']?.toString() ?? 'N/A'})',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${order['order_type']?.toString() ?? 'N/A'} | Qty: ${order['quantity'] ?? 0} | Price: ₹$priceStr',
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionsCard() {
    final positions = _positions?['data'] as Map<String, dynamic>?;
    if (positions == null) {
      return _buildDataCard('📊 Positions', const Text('No position data', style: TextStyle(color: Colors.white70)));
    }
    final netPositions = positions['net'] as List?;
    return _buildDataCard(
      '📊 Positions (${netPositions?.length ?? 0})',
      netPositions != null && netPositions.isNotEmpty
          ? Column(
              children: netPositions.map((position) => _buildPositionItem(position as Map<String, dynamic>)).toList(),
            )
          : const Text('No open positions', style: TextStyle(color: Colors.white70)),
    );
  }

  Widget _buildPositionItem(Map<String, dynamic> position) {
    final pnlValue = position['pnl'];
    final pnl = (pnlValue is num) ? pnlValue.toDouble() : 0.0;
    final pnlColor = pnl >= 0 ? Colors.green : Colors.red;
    final lastPrice = position['last_price'];
    final lastPriceStr = (lastPrice is num) ? lastPrice.toStringAsFixed(2) : '0.00';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                position['tradingsymbol']?.toString() ?? 'N/A',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹$lastPriceStr',
                style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Qty: ${position['quantity'] ?? 0}',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              Text(
                '${pnl >= 0 ? '+' : ''}₹${pnl.toStringAsFixed(2)}',
                style: TextStyle(color: pnlColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuotesCard() {
    final quotes = _quotes?['data'] as Map<String, dynamic>?;
    if (quotes == null || quotes.isEmpty) {
      return _buildDataCard('📈 Market Quotes', const Text('No quote data', style: TextStyle(color: Colors.white70)));
    }
    return _buildDataCard(
      '📈 Market Quotes',
      Column(
        children: quotes.entries.map<Widget>((entry) => _buildQuoteItem(entry.key, entry.value as Map<String, dynamic>)).toList(),
      ),
    );
  }

  Widget _buildQuoteItem(String symbol, Map<String, dynamic> quote) {
    final changeValue = quote['net_change'];
    final change = (changeValue is num) ? changeValue.toDouble() : 0.0;
    final changeColor = change >= 0 ? Colors.green : Colors.red;
    final lastPrice = quote['last_price'];
    final lastPriceStr = (lastPrice is num) ? lastPrice.toStringAsFixed(2) : '0.00';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                symbol.split(':').last,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹$lastPriceStr',
                style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}',
                style: TextStyle(color: changeColor, fontWeight: FontWeight.bold),
              ),
              Text(
                'Vol: ${quote['volume']?.toString() ?? '0'}',
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataCard(String title, Widget content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Future<void> _loadOrders() async {
    try {
      final orders = await KiteOAuthService.getOrders();
      setState(() {
        _orders = orders;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load orders: $e')),
      );
    }
  }

  Future<void> _loadPositions() async {
    try {
      final positions = await KiteOAuthService.getPositions();
      setState(() {
        _positions = positions;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load positions: $e')),
      );
    }
  }

  Future<void> _loadHoldings() async {
    try {
      final holdings = await KiteOAuthService.getHoldings();
      setState(() {
        _holdings = holdings;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load holdings: $e')),
      );
    }
  }

  void _showModifyOrderDialog() {
    if (_orders == null || _orders!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No orders available to modify')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Modify Order',
          style: TextStyle(color: Colors.amber),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select an order to modify:',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Order ID',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                dropdownColor: Colors.grey[800],
                style: const TextStyle(color: Colors.white),
                items: (_orders!['data'] as List?)?.map((order) {
                  final orderId = order['order_id']?.toString() ?? '';
                  final symbol = order['tradingsymbol'] ?? '';
                  final status = order['status'] ?? '';
                  return DropdownMenuItem(
                    value: orderId,
                    child: Text('$orderId - $symbol ($status)'),
                  );
                }).toList() ?? [],
                onChanged: (value) {
                  // TODO: Implement modify order logic
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Modify order feature coming soon')),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  void _showCancelOrderDialog() {
    if (_orders == null || _orders!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No orders available to cancel')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Cancel Order',
          style: TextStyle(color: Colors.amber),
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select an order to cancel:',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Order ID',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber),
                  ),
                ),
                dropdownColor: Colors.grey[800],
                style: const TextStyle(color: Colors.white),
                items: (_orders!['data'] as List?)?.where((order) => order['status'] == 'OPEN').map((order) {
                  final orderId = order['order_id']?.toString() ?? '';
                  final symbol = order['tradingsymbol'] ?? '';
                  return DropdownMenuItem(
                    value: orderId,
                    child: Text('$orderId - $symbol'),
                  );
                }).toList() ?? [],
                onChanged: (value) async {
                  if (value != null) {
                    Navigator.of(context).pop();
                    // Find the order to get variety
                    final orderData = (_orders!['data'] as List?)?.firstWhere(
                      (order) => order['order_id']?.toString() == value,
                      orElse: () => null,
                    );
                    if (orderData != null) {
                      final variety = orderData['variety'] ?? 'regular';
                      try {
                        await KiteOAuthService.cancelOrder(variety, value);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order cancelled successfully')),
                        );
                        _loadOrders(); // Refresh orders
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to cancel order: $e')),
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  void _showOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => const OrderDialog(),
    );
  }
}