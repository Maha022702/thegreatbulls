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
  final _tradingsymbolController = TextEditingController();
  String _transactionType = 'BUY';
  String _orderType = 'MARKET';
  String _product = 'CNC';
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _triggerPriceController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text(
        'Place Order',
        style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Variety
              DropdownButtonFormField<String>(
                value: _variety,
                decoration: const InputDecoration(
                  labelText: 'Variety',
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
      ]);

      setState(() {
        _userProfile = results[0] as Map<String, dynamic>?;
        _margins = results[1] as Map<String, dynamic>?;
        _holdings = results[2] as Map<String, dynamic>?;
        _orders = results[3] as Map<String, dynamic>?;
        _positions = results[4] as Map<String, dynamic>?;
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
    setState(() => _isLoading = true);

    try {
      // Load all data in parallel
      final results = await Future.wait([
        KiteOAuthService.getUserProfile(),
        KiteOAuthService.getMargins(),
        KiteOAuthService.getHoldings(),
        KiteOAuthService.getOrders(),
        KiteOAuthService.getPositions(),
        KiteOAuthService.getQuote('NSE:RELIANCE,NSE:TCS,NSE:INFY'),
      ]);

      setState(() {
        _userProfile = results[0];
        _margins = results[1];
        _holdings = results[2];
        _orders = results[3];
        _positions = results[4];
        _quotes = results[5];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'DevForge Dashboard',
          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
        ),
        actions: [
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
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'Logout',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showOrderDialog,
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, color: Colors.black),
        tooltip: 'Place Order',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            if (_userProfile != null) _buildUserProfileCard(),

            const SizedBox(height: 20),

            // Margins Section
            if (_margins != null) _buildMarginsCard(),

            const SizedBox(height: 20),

            // Holdings Section
            if (_holdings != null) _buildHoldingsCard(),

            const SizedBox(height: 20),

            // Orders Section
            if (_orders != null) _buildOrdersCard(),

            const SizedBox(height: 20),

            // Positions Section
            if (_positions != null) _buildPositionsCard(),

            const SizedBox(height: 20),

            // Market Quotes Section
            if (_quotes != null) _buildQuotesCard(),
          ],
        ),
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

  // Content Pages
  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          if (_userProfile != null) _buildUserProfileCard(),
          const SizedBox(height: 20),

          // Quick Stats
          if (_margins != null) _buildMarginsCard(),
          const SizedBox(height: 20),

          // Recent Activity
          _buildRecentActivityCard(),
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
          // Order Placement Section
          Container(
            width: double.infinity,
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
                  '🚀 Place New Order',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Execute real trades with advanced order types',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _showOrderDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Place Order'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Quick Order Templates
          _buildQuickOrderTemplates(),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '📋 Order History',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _loadAllData,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Orders List
          if (_orders != null) _buildOrdersCard() else _buildComingSoonCard('Order History'),
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
          const Text(
            '📊 Position Management',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          if (_positions != null) _buildPositionsCard() else _buildComingSoonCard('Position Management'),
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
          const Text(
            '📦 Portfolio Holdings',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          if (_holdings != null) _buildHoldingsCard() else _buildComingSoonCard('Holdings'),
        ],
      ),
    );
  }

  Widget _buildPortfolioContent() {
    return _buildComingSoonCard('Portfolio Analytics');
  }

  Widget _buildWatchlistContent() {
    return _buildComingSoonCard('Watchlist');
  }

  Widget _buildAnalyticsContent() {
    return _buildComingSoonCard('Advanced Analytics');
  }

  Widget _buildComingSoonCard(String feature) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              color: Colors.amber,
              size: 60,
            ),
            const SizedBox(height: 20),
            Text(
              '$feature',
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Coming Soon!',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'This feature is under development.\nCheck back soon for updates.',
              style: TextStyle(color: Colors.white54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickOrderTemplates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '⚡ Quick Order Templates',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            _buildOrderTemplateCard('Market Order', 'Instant execution', Icons.flash_on, Colors.green),
            const SizedBox(width: 15),
            _buildOrderTemplateCard('Limit Order', 'Set target price', Icons.target, Colors.blue),
            const SizedBox(width: 15),
            _buildOrderTemplateCard('Stop Loss', 'Protect profits', Icons.shield, Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderTemplateCard(String title, String subtitle, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard() {
    return Container(
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
            '📈 Recent Activity',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _buildActivityItem('Portfolio value updated', '2 minutes ago', Icons.trending_up, Colors.green),
          _buildActivityItem('Order executed', '15 minutes ago', Icons.check_circle, Colors.blue),
          _buildActivityItem('New holding added', '1 hour ago', Icons.inventory, Colors.amber),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  time,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Existing card builders
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
          _buildInfoRow('Email', profile['email'] ?? 'N/A'),
          _buildInfoRow('User Name', profile['user_name'] ?? 'N/A'),
          _buildInfoRow('User Short Name', profile['user_shortname'] ?? 'N/A'),
          _buildInfoRow('Broker', profile['broker'] ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildMarginsCard() {
    final margins = _margins?['data'];
    if (margins == null) {
      return _buildDataCard('💰 Account Margins', const Text('No margin data', style: TextStyle(color: Colors.white70)));
    }
    return _buildDataCard(
      '💰 Account Margins',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Available Cash', '₹${margins['available']['cash']?.toStringAsFixed(2) ?? '0.00'}'),
          _buildInfoRow('Used Margin', '₹${margins['utilised']['debits']?.toStringAsFixed(2) ?? '0.00'}'),
          _buildInfoRow('Total Balance', '₹${(margins['available']['cash'] + margins['available']['intraday_payin'] + margins['available']['collateral'] - margins['utilised']['debits']).toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildHoldingsCard() {
    final holdings = _holdings?['data'];
    if (holdings == null || holdings.isEmpty) {
      return _buildDataCard('📦 Holdings', const Text('No holdings data', style: TextStyle(color: Colors.white70)));
    }
    return _buildDataCard(
      '📦 Holdings',
      Column(
        children: holdings.map<Widget>((holding) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holding['tradingsymbol'] ?? 'N/A',
                  style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                _buildInfoRow('Quantity', holding['quantity']?.toString() ?? '0'),
                _buildInfoRow('Average Price', '₹${holding['average_price']?.toStringAsFixed(2) ?? '0.00'}'),
                _buildInfoRow('LTP', '₹${holding['last_price']?.toStringAsFixed(2) ?? '0.00'}'),
                _buildInfoRow('P&L', '₹${holding['pnl']?.toStringAsFixed(2) ?? '0.00'}'),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrdersCard() {
    final orders = _orders?['data'];
    if (orders == null || orders.isEmpty) {
      return _buildDataCard('📋 Orders', const Text('No orders data', style: TextStyle(color: Colors.white70)));
    }
    return _buildDataCard(
      '📋 Orders',
      Column(
        children: orders.map<Widget>((order) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order['tradingsymbol'] ?? 'N/A',
                      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getOrderStatusColor(order['status']),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        order['status'] ?? 'UNKNOWN',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                _buildInfoRow('Type', '${order['transaction_type']} ${order['order_type']}'),
                _buildInfoRow('Quantity', order['quantity']?.toString() ?? '0'),
                _buildInfoRow('Price', order['price'] != null ? '₹${order['price']?.toStringAsFixed(2)}' : 'Market'),
                _buildInfoRow('Order ID', order['order_id'] ?? 'N/A'),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPositionsCard() {
    final positions = _positions?['data'];
    if (positions == null || positions.isEmpty) {
      return _buildDataCard('📊 Positions', const Text('No positions data', style: TextStyle(color: Colors.white70)));
    }
    return _buildDataCard(
      '📊 Positions',
      Column(
        children: positions.map<Widget>((position) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position['tradingsymbol'] ?? 'N/A',
                  style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                _buildInfoRow('Net Quantity', position['net_quantity']?.toString() ?? '0'),
                _buildInfoRow('Average Price', '₹${position['average_price']?.toStringAsFixed(2) ?? '0.00'}'),
                _buildInfoRow('LTP', '₹${position['last_price']?.toStringAsFixed(2) ?? '0.00'}'),
                _buildInfoRow('P&L', '₹${position['pnl']?.toStringAsFixed(2) ?? '0.00'}'),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuotesCard() {
    final quotes = _quotes?['data'];
    if (quotes == null) {
      return _buildDataCard('📈 Market Quotes', const Text('No quotes data', style: TextStyle(color: Colors.white70)));
    }
    return _buildDataCard(
      '📈 Market Quotes',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: quotes.entries.map<Widget>((entry) {
          final data = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                _buildInfoRow('Last Price', '₹${data['last_price']?.toStringAsFixed(2) ?? '0.00'}'),
                _buildInfoRow('Change', '${data['net_change']?.toStringAsFixed(2) ?? '0.00'}'),
                _buildInfoRow('Volume', data['volume']?.toString() ?? '0'),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDataCard(String title, Widget content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
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
          const SizedBox(height: 15),
          content,
        ],
      ),
    );
  }

  Color _getOrderStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'COMPLETE':
        return Colors.green;
      case 'OPEN':
        return Colors.blue;
      case 'CANCELLED':
        return Colors.red;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.grey;
    }
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

  Future<void> _checkTokenStatus() async {
    final accessToken = await KiteOAuthService.getAccessTokenForDebug();
    final publicToken = await KiteOAuthService.getPublicTokenForDebug();
    final isLoggedIn = await KiteOAuthService.isLoggedIn();

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Token Status', style: TextStyle(color: Colors.amber)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Logged In: $isLoggedIn', style: const TextStyle(color: Colors.white)),
              Text('Access Token: ${accessToken != null ? 'Present' : 'Missing'}', style: const TextStyle(color: Colors.white)),
              Text('Public Token: ${publicToken != null ? 'Present' : 'Missing'}', style: const TextStyle(color: Colors.white)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(color: Colors.amber)),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _logout() async {
    await KiteOAuthService.logout();
    if (mounted) {
      context.go('/');
    }
  }

  void _showOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => const OrderDialog(),
    );
  }
}

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
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

  void _showOrderDialog() {
    showDialog(
      context: context,
      builder: (context) => const OrderDialog(),
    );
  }
}