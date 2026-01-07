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
    return Scaffold(
      backgroundColor: Colors.black,
      body: const Center(
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
      ),
    );
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