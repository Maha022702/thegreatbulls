import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'kite_config.dart';

class LiveMarketDataWidget extends StatefulWidget {
  const LiveMarketDataWidget({Key? key}) : super(key: key);

  @override
  State<LiveMarketDataWidget> createState() => _LiveMarketDataWidgetState();
}

class _LiveMarketDataWidgetState extends State<LiveMarketDataWidget> {
  late String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'live-market-data-${DateTime.now().millisecondsSinceEpoch}';
    _registerViewFactory();
  }

  void _registerViewFactory() {
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..id = 'live-data-iframe-$viewId'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.border = 'none'
          ..srcdoc = _buildLiveDataHTML();

        return iframe;
      },
    );
  }

  String _buildLiveDataHTML() {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <script src="https://unpkg.com/lightweight-charts@4/dist/lightweight-charts.standalone.production.js"></script>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    
    body {
      background: #0a0a0a;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Inter', sans-serif;
      color: #ffffff;
      height: 100vh;
      overflow: hidden;
    }
    
    .container { display: flex; height: 100vh; }
    
    .stock-list {
      width: 280px;
      background: #0f0f0f;
      border-right: 1px solid #27272a;
      overflow-y: auto;
      flex-shrink: 0;
    }
    
    .list-header {
      padding: 14px 16px;
      background: #1a1a1a;
      border-bottom: 1px solid #27272a;
      position: sticky;
      top: 0;
      z-index: 10;
    }
    
    .list-header h2 { font-size: 14px; color: #fbbf24; margin-bottom: 6px; }
    
    .connection-badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 3px 8px;
      border-radius: 10px;
      font-size: 10px;
      font-weight: 600;
    }
    
    .connection-badge.connected { background: #22c55e20; color: #22c55e; }
    .connection-badge.disconnected { background: #ef444420; color: #ef4444; }
    .connection-badge.connecting { background: #fbbf2420; color: #fbbf24; }
    
    .status-dot {
      width: 5px; height: 5px;
      border-radius: 50%;
      animation: pulse 2s infinite;
    }
    .status-dot.connected { background: #22c55e; }
    .status-dot.disconnected { background: #ef4444; animation: none; }
    .status-dot.connecting { background: #fbbf24; }
    
    @keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.4; } }
    
    .stock-item {
      padding: 10px 14px;
      border-bottom: 1px solid #1f1f23;
      cursor: pointer;
      transition: all 0.15s;
    }
    .stock-item:hover { background: #1a1a1a; }
    .stock-item.selected { background: #fbbf2415; border-left: 3px solid #fbbf24; }
    .stock-item.updating { animation: itemPulse 0.3s ease; }
    @keyframes itemPulse { 50% { background: #22c55e10; } }
    
    .stock-row { display: flex; justify-content: space-between; align-items: center; }
    .stock-name { font-size: 12px; font-weight: 600; color: #e5e7eb; }
    .stock-token-id { font-size: 9px; color: #6b7280; margin-top: 1px; }
    .stock-price { text-align: right; }
    .ltp { font-size: 13px; font-weight: 700; }
    .ltp.up { color: #22c55e; }
    .ltp.down { color: #ef4444; }
    .ltp.neutral { color: #ffffff; }
    .change { font-size: 10px; font-weight: 600; }
    .change.up { color: #22c55e; }
    .change.down { color: #ef4444; }
    
    .chart-panel { flex: 1; display: flex; flex-direction: column; background: #0a0a0a; }
    
    .chart-header {
      padding: 12px 20px;
      background: #0f0f0f;
      border-bottom: 1px solid #27272a;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    
    .selected-stock-info { display: flex; align-items: center; gap: 16px; }
    .selected-name { font-size: 18px; font-weight: 700; color: #fbbf24; }
    .selected-price { font-size: 24px; font-weight: 700; }
    .selected-price.up { color: #22c55e; }
    .selected-price.down { color: #ef4444; }
    .selected-change { font-size: 13px; font-weight: 600; }
    .selected-change.up { color: #22c55e; }
    .selected-change.down { color: #ef4444; }
    
    .header-right { display: flex; align-items: center; gap: 12px; }
    
    .interval-selector {
      display: flex;
      gap: 4px;
      background: #1a1a1a;
      padding: 3px;
      border-radius: 6px;
    }
    .interval-btn {
      padding: 4px 10px;
      border: none;
      background: transparent;
      color: #9ca3af;
      font-size: 11px;
      font-weight: 600;
      cursor: pointer;
      border-radius: 4px;
      transition: all 0.15s;
    }
    .interval-btn:hover { background: #27272a; color: #fff; }
    .interval-btn.active { background: #fbbf24; color: #000; }
    
    .live-indicator {
      display: flex;
      align-items: center;
      gap: 6px;
      padding: 4px 10px;
      background: #22c55e15;
      border: 1px solid #22c55e40;
      border-radius: 14px;
      color: #22c55e;
      font-size: 10px;
      font-weight: 600;
    }
    .live-dot { width: 6px; height: 6px; background: #22c55e; border-radius: 50%; animation: pulse 1s infinite; }
    
    .stock-stats {
      display: flex;
      gap: 20px;
      padding: 10px 20px;
      background: #0f0f0f;
      border-bottom: 1px solid #27272a;
      flex-wrap: wrap;
    }
    .stat-item { display: flex; flex-direction: column; gap: 1px; }
    .stat-label { font-size: 9px; color: #6b7280; text-transform: uppercase; }
    .stat-value { font-size: 12px; font-weight: 600; color: #e5e7eb; }
    .stat-value.high { color: #22c55e; }
    .stat-value.low { color: #ef4444; }
    .stat-value.volume { color: #60a5fa; }
    
    .candle-count {
      font-size: 10px;
      color: #6b7280;
      padding: 4px 10px;
      background: #1a1a1a;
      border-radius: 10px;
    }
    
    .realtime-clock {
      font-size: 11px;
      font-weight: 600;
      color: #fbbf24;
      font-family: monospace;
    }
    
    .last-tick {
      font-size: 10px;
      color: #6b7280;
      padding: 4px 10px;
      background: #1a1a1a;
      border-radius: 10px;
    }
    .last-tick.fresh { color: #22c55e; }
    .last-tick.stale { color: #ef4444; }
    
    #chartContainer { flex: 1; position: relative; }
    
    .no-selection {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      height: 100%;
      color: #6b7280;
      gap: 10px;
    }
    .no-selection-icon { font-size: 40px; }
    
    .loading-overlay {
      position: absolute;
      top: 0; left: 0; right: 0; bottom: 0;
      background: rgba(10,10,10,0.8);
      display: flex;
      align-items: center;
      justify-content: center;
      color: #fbbf24;
      font-size: 14px;
      z-index: 100;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="stock-list">
      <div class="list-header">
        <h2>📊 Live Stocks</h2>
        <div class="connection-badge disconnected" id="statusBadge">
          <div class="status-dot disconnected" id="statusDot"></div>
          <span id="statusText">Connecting...</span>
        </div>
      </div>
      <div id="stockList"></div>
    </div>
    
    <div class="chart-panel">
      <div class="chart-header" id="chartHeader" style="display: none;">
        <div class="selected-stock-info">
          <div class="selected-name" id="selectedName">—</div>
          <div class="selected-price" id="selectedPrice">₹—</div>
          <div class="selected-change" id="selectedChange">—</div>
        </div>
        <div class="header-right">
          <div class="realtime-clock" id="realtimeClock">--:--:--</div>
          <div class="interval-selector">
            <button class="interval-btn active" data-interval="1m">1m</button>
            <button class="interval-btn" data-interval="5m">5m</button>
            <button class="interval-btn" data-interval="15m">15m</button>
          </div>
          <div class="candle-count" id="candleCount">0 candles</div>
          <div class="last-tick" id="lastTick">Last tick: --</div>
          <div class="live-indicator"><div class="live-dot"></div>LIVE</div>
        </div>
      </div>
      
      <div class="stock-stats" id="stockStats" style="display: none;">
        <div class="stat-item"><div class="stat-label">Open</div><div class="stat-value" id="statOpen">—</div></div>
        <div class="stat-item"><div class="stat-label">High</div><div class="stat-value high" id="statHigh">—</div></div>
        <div class="stat-item"><div class="stat-label">Low</div><div class="stat-value low" id="statLow">—</div></div>
        <div class="stat-item"><div class="stat-label">Prev Close</div><div class="stat-value" id="statClose">—</div></div>
        <div class="stat-item"><div class="stat-label">Volume</div><div class="stat-value volume" id="statVolume">—</div></div>
        <div class="stat-item"><div class="stat-label">Buy Qty</div><div class="stat-value" id="statBuyQty">—</div></div>
        <div class="stat-item"><div class="stat-label">Sell Qty</div><div class="stat-value" id="statSellQty">—</div></div>
      </div>
      
      <div id="chartContainer">
        <div class="no-selection" id="noSelection">
          <div class="no-selection-icon">👈</div>
          <div>Select a stock to view live chart</div>
        </div>
        <div class="loading-overlay" id="loadingOverlay" style="display: none;">
          Loading historical data...
        </div>
      </div>
    </div>
  </div>
  
  <script>
    // Configuration
    const DB_NAME = 'TheGreatBullsDB';
    const DB_VERSION = 2;
    const CANDLES_STORE = 'candles';
    const TICKS_STORE = 'ticks';
    
    const stocks = [
      { token: 738561, name: 'Reliance Industries', symbol: 'RELIANCE' },
      { token: 3786497, name: 'TCS', symbol: 'TCS' },
      { token: 408065, name: 'Infosys', symbol: 'INFY' },
      { token: 779521, name: 'State Bank of India', symbol: 'SBIN' },
      { token: 341249, name: 'HDFC Bank', symbol: 'HDFCBANK' },
      { token: 424961, name: 'ITC', symbol: 'ITC' },
      { token: 4267265, name: 'Bajaj Finance', symbol: 'BAJFINANCE' },
      { token: 969473, name: 'Wipro', symbol: 'WIPRO' },
      { token: 2815745, name: 'Maruti Suzuki', symbol: 'MARUTI' },
      { token: 971009, name: 'Asian Paints', symbol: 'ASIANPAINT' }
    ];
    
    let db = null;
    let ws = null;
    let stockData = {};
    let selectedToken = null;
    let selectedInterval = '1m';
    let chart = null;
    let candleSeries = null;
    let volumeSeries = null;
    let candleData = {};  // { token: { '1m': [], '5m': [], '15m': [] } }
    let currentCandle = {};  // Current forming candle per stock
    let lastTickTime = {};  // Track last tick time per stock
    let tickCount = 0;  // Total ticks received
    
    // IST offset: UTC+5:30 = 19800 seconds
    const IST_OFFSET = 5.5 * 60 * 60;
    
    // Initialize stock data
    stocks.forEach(stock => {
      stockData[stock.token] = { ...stock, ltp: null, change: 0, changePercent: 0, ohlc: {}, volume: 0, buyQty: 0, sellQty: 0 };
      candleData[stock.token] = { '1m': [], '5m': [], '15m': [] };
      currentCandle[stock.token] = null;
    });
    
    // ========== IndexedDB Functions ==========
    async function initDB() {
      return new Promise((resolve, reject) => {
        const request = indexedDB.open(DB_NAME, DB_VERSION);
        
        request.onerror = () => reject(request.error);
        request.onsuccess = () => { db = request.result; resolve(db); };
        
        request.onupgradeneeded = (event) => {
          const db = event.target.result;
          
          // Candles store: { token_interval_time: { token, interval, time, open, high, low, close, volume } }
          if (!db.objectStoreNames.contains(CANDLES_STORE)) {
            const candlesStore = db.createObjectStore(CANDLES_STORE, { keyPath: 'id' });
            candlesStore.createIndex('token_interval', ['token', 'interval'], { unique: false });
          }
          
          // Ticks store for raw data
          if (!db.objectStoreNames.contains(TICKS_STORE)) {
            const ticksStore = db.createObjectStore(TICKS_STORE, { keyPath: 'id', autoIncrement: true });
            ticksStore.createIndex('token', 'token', { unique: false });
          }
        };
      });
    }
    
    async function saveCandle(candle) {
      if (!db) return;
      const id = candle.token + '_' + candle.interval + '_' + candle.time;
      const tx = db.transaction(CANDLES_STORE, 'readwrite');
      tx.objectStore(CANDLES_STORE).put({ ...candle, id });
    }
    
    async function loadCandles(token, interval) {
      if (!db) return [];
      return new Promise((resolve) => {
        const tx = db.transaction(CANDLES_STORE, 'readonly');
        const store = tx.objectStore(CANDLES_STORE);
        const index = store.index('token_interval');
        const request = index.getAll([token, interval]);
        
        request.onsuccess = () => {
          const candles = request.result || [];
          // Sort by time and keep last 500 candles
          candles.sort((a, b) => a.time - b.time);
          resolve(candles.slice(-500));
        };
        request.onerror = () => resolve([]);
      });
    }
    
    async function cleanOldCandles() {
      if (!db) return;
      const tx = db.transaction(CANDLES_STORE, 'readwrite');
      const store = tx.objectStore(CANDLES_STORE);
      const cutoff = Math.floor(Date.now() / 1000) - (7 * 24 * 60 * 60); // 7 days ago
      
      store.openCursor().onsuccess = (event) => {
        const cursor = event.target.result;
        if (cursor) {
          if (cursor.value.time < cutoff) {
            cursor.delete();
          }
          cursor.continue();
        }
      };
    }
    
    // ========== Candle Aggregation ==========
    function getIntervalMs(interval) {
      switch(interval) {
        case '1m': return 60 * 1000;
        case '5m': return 5 * 60 * 1000;
        case '15m': return 15 * 60 * 1000;
        default: return 60 * 1000;
      }
    }
    
    function getCandleTime(timestamp, interval) {
      const ms = getIntervalMs(interval);
      // Convert to IST-aligned candle time
      const utcSeconds = Math.floor(timestamp / 1000);
      const istSeconds = utcSeconds + IST_OFFSET;
      const intervalSeconds = ms / 1000;
      const candleIstSeconds = Math.floor(istSeconds / intervalSeconds) * intervalSeconds;
      return candleIstSeconds - IST_OFFSET;  // Convert back to UTC for chart
    }
    
    function processTick(tick) {
      const token = tick.instrument_token;
      const price = tick.last_price;
      const volume = tick.volume || 0;
      const now = Date.now();
      
      ['1m', '5m', '15m'].forEach(interval => {
        const candleTime = getCandleTime(now, interval);
        let candle = currentCandle[token + '_' + interval];
        
        if (!candle || candle.time !== candleTime) {
          // Save old candle if exists
          if (candle) {
            candleData[token][interval].push(candle);
            if (candleData[token][interval].length > 500) {
              candleData[token][interval] = candleData[token][interval].slice(-500);
            }
            saveCandle(candle);
          }
          
          // Start new candle
          candle = {
            token: token,
            interval: interval,
            time: candleTime,
            open: price,
            high: price,
            low: price,
            close: price,
            volume: volume
          };
          currentCandle[token + '_' + interval] = candle;
        } else {
          // Update current candle
          candle.high = Math.max(candle.high, price);
          candle.low = Math.min(candle.low, price);
          candle.close = price;
          candle.volume = volume;
        }
      });
      
      // Update chart if this is the selected stock
      if (token === selectedToken) {
        updateChart();
      }
    }
    
    // ========== Chart Functions ==========
    function initChart() {
      const container = document.getElementById('chartContainer');
      if (chart) chart.remove();
      
      chart = LightweightCharts.createChart(container, {
        layout: { background: { color: '#0a0a0a' }, textColor: '#9ca3af' },
        width: container.offsetWidth,
        height: container.offsetHeight,
        grid: { vertLines: { color: '#1f1f23' }, horzLines: { color: '#1f1f23' } },
        crosshair: { mode: 0, vertLine: { color: '#fbbf24', width: 1, style: 3 }, horzLine: { color: '#fbbf24', width: 1, style: 3 } },
        rightPriceScale: { borderColor: '#27272a', scaleMargins: { top: 0.1, bottom: 0.2 } },
        timeScale: { borderColor: '#27272a', timeVisible: true, secondsVisible: false },
      });
      
      candleSeries = chart.addCandlestickSeries({
        upColor: '#22c55e',
        downColor: '#ef4444',
        borderUpColor: '#22c55e',
        borderDownColor: '#ef4444',
        wickUpColor: '#22c55e',
        wickDownColor: '#ef4444',
      });
      
      volumeSeries = chart.addHistogramSeries({
        color: '#3b82f6',
        priceFormat: { type: 'volume' },
        priceScaleId: '',
        scaleMargins: { top: 0.85, bottom: 0 },
      });
      
      window.addEventListener('resize', () => {
        if (container.offsetWidth > 0) {
          chart.applyOptions({ width: container.offsetWidth, height: container.offsetHeight });
        }
      });
    }
    
    function updateChart() {
      if (!selectedToken || !candleSeries) return;
      
      const historicalCandles = candleData[selectedToken][selectedInterval] || [];
      const current = currentCandle[selectedToken + '_' + selectedInterval];
      
      let allCandles = [...historicalCandles];
      if (current) allCandles.push(current);
      
      // Format for chart
      const chartCandles = allCandles.map(c => ({
        time: c.time,
        open: c.open,
        high: c.high,
        low: c.low,
        close: c.close
      }));
      
      const volumeData = allCandles.map(c => ({
        time: c.time,
        value: c.volume,
        color: c.close >= c.open ? '#22c55e40' : '#ef444440'
      }));
      
      if (chartCandles.length > 0) {
        candleSeries.setData(chartCandles);
        volumeSeries.setData(volumeData);
        document.getElementById('candleCount').textContent = chartCandles.length + ' candles';
      }
      
      updateChartHeader();
    }
    
    async function selectStock(token) {
      selectedToken = token;
      
      document.getElementById('chartHeader').style.display = 'flex';
      document.getElementById('stockStats').style.display = 'flex';
      document.getElementById('noSelection').style.display = 'none';
      document.getElementById('loadingOverlay').style.display = 'flex';
      
      renderStockList();
      initChart();
      
      // Load historical candles from IndexedDB
      for (const interval of ['1m', '5m', '15m']) {
        const saved = await loadCandles(token, interval);
        if (saved.length > 0) {
          candleData[token][interval] = saved;
        }
      }
      
      document.getElementById('loadingOverlay').style.display = 'none';
      updateChart();
      updateChartHeader();
    }
    
    function setInterval(interval) {
      selectedInterval = interval;
      document.querySelectorAll('.interval-btn').forEach(btn => {
        btn.classList.toggle('active', btn.dataset.interval === interval);
      });
      updateChart();
    }
    
    // ========== UI Functions ==========
    function updateStatus(status, cls) {
      document.getElementById('statusText').textContent = status;
      document.getElementById('statusBadge').className = 'connection-badge ' + cls;
      document.getElementById('statusDot').className = 'status-dot ' + cls;
    }
    
    function formatNum(n) {
      if (!n) return '0';
      if (n >= 10000000) return (n / 10000000).toFixed(2) + ' Cr';
      if (n >= 100000) return (n / 100000).toFixed(2) + ' L';
      if (n >= 1000) return (n / 1000).toFixed(1) + 'K';
      return n.toLocaleString();
    }
    
    function renderStockList() {
      const list = document.getElementById('stockList');
      list.innerHTML = '';
      
      stocks.forEach(stock => {
        const d = stockData[stock.token];
        const cls = d.change > 0 ? 'up' : d.change < 0 ? 'down' : 'neutral';
        const arr = d.change > 0 ? '▲' : d.change < 0 ? '▼' : '';
        
        const item = document.createElement('div');
        item.className = 'stock-item' + (selectedToken === stock.token ? ' selected' : '');
        item.id = 'item-' + stock.token;
        item.onclick = () => selectStock(stock.token);
        
        item.innerHTML = '<div class="stock-row"><div><div class="stock-name">' + stock.symbol + '</div><div class="stock-token-id">' + stock.name + '</div></div><div class="stock-price"><div class="ltp ' + cls + '">₹' + (d.ltp ? d.ltp.toFixed(2) : '—') + '</div><div class="change ' + cls + '">' + arr + ' ' + d.changePercent.toFixed(2) + '%</div></div></div>';
        
        list.appendChild(item);
      });
    }
    
    function updateChartHeader() {
      if (!selectedToken) return;
      const d = stockData[selectedToken];
      const cls = d.change > 0 ? 'up' : d.change < 0 ? 'down' : '';
      const arr = d.change > 0 ? '▲' : d.change < 0 ? '▼' : '';
      
      document.getElementById('selectedName').textContent = d.symbol;
      document.getElementById('selectedPrice').textContent = '₹' + (d.ltp?.toFixed(2) || '—');
      document.getElementById('selectedPrice').className = 'selected-price ' + cls;
      document.getElementById('selectedChange').innerHTML = arr + ' ₹' + Math.abs(d.change).toFixed(2) + ' (' + (d.change >= 0 ? '+' : '') + d.changePercent.toFixed(2) + '%)';
      document.getElementById('selectedChange').className = 'selected-change ' + cls;
      
      document.getElementById('statOpen').textContent = '₹' + (d.ohlc.open?.toFixed(2) || '—');
      document.getElementById('statHigh').textContent = '₹' + (d.ohlc.high?.toFixed(2) || '—');
      document.getElementById('statLow').textContent = '₹' + (d.ohlc.low?.toFixed(2) || '—');
      document.getElementById('statClose').textContent = '₹' + (d.ohlc.close?.toFixed(2) || '—');
      document.getElementById('statVolume').textContent = formatNum(d.volume);
      document.getElementById('statBuyQty').textContent = formatNum(d.buyQty);
      document.getElementById('statSellQty').textContent = formatNum(d.sellQty);
    }
    
    function updateStock(tick) {
      const d = stockData[tick.instrument_token];
      if (!d) return;
      
      d.ltp = tick.last_price;
      d.ohlc = tick.ohlc || d.ohlc;
      d.volume = tick.volume || d.volume;
      d.buyQty = tick.buy_quantity || d.buyQty;
      d.sellQty = tick.sell_quantity || d.sellQty;
      
      if (d.ohlc.close) {
        d.change = d.ltp - d.ohlc.close;
        d.changePercent = (d.change / d.ohlc.close) * 100;
      }
      
      // Process tick for candle aggregation
      processTick(tick);
      
      // Track last tick time
      lastTickTime[tick.instrument_token] = Date.now();
      tickCount++;
      updateLastTickDisplay();
      
      const item = document.getElementById('item-' + tick.instrument_token);
      if (item) {
        item.classList.add('updating');
        setTimeout(() => item.classList.remove('updating'), 300);
      }
      
      renderStockList();
    }
    
    // ========== WebSocket Functions ==========
    function connectWebSocket() {
      const accessToken = localStorage.getItem('access_token');
      if (!accessToken) {
        updateStatus('Not logged in', 'disconnected');
        return;
      }
      
      updateStatus('Connecting...', 'connecting');
      
      final apiKey = KiteConfig.apiKey;
      if (apiKey.isEmpty) {
        setState(() {
          connectionStatus = 'Missing API key - set KITE_API_KEY via --dart-define';
        });
        return;
      }
      ws = new WebSocket('wss://ws.kite.trade?api_key=' + apiKey + '&access_token=' + accessToken);
      ws.binaryType = 'arraybuffer';
      
      ws.onopen = () => {
        updateStatus('Live', 'connected');
        const tokens = stocks.map(s => s.token);
        ws.send(JSON.stringify({ a: 'subscribe', v: tokens }));
        setTimeout(() => ws.send(JSON.stringify({ a: 'mode', v: ['full', tokens] })), 500);
      };
      
      ws.onmessage = (event) => {
        if (event.data instanceof ArrayBuffer) {
          const buffer = event.data;
          if (buffer.byteLength < 2) return;
          
          const dv = new DataView(buffer);
          const n = dv.getInt16(0);
          let off = 2;
          
          for (let i = 0; i < n; i++) {
            if (off + 2 > buffer.byteLength) break;
            const len = dv.getInt16(off);
            off += 2;
            if (off + len > buffer.byteLength) break;
            
            const tick = parseTick(dv, off, len);
            if (tick) updateStock(tick);
            off += len;
          }
        }
      };
      
      ws.onerror = () => updateStatus('Error', 'disconnected');
      ws.onclose = (e) => {
        updateStatus('Disconnected', 'disconnected');
        if (e.code !== 1000) setTimeout(connectWebSocket, 5000);
      };
    }
    
    function parseTick(dv, off, len) {
      try {
        const token = dv.getInt32(off);
        if (len === 8) return { instrument_token: token, last_price: dv.getInt32(off + 4) / 100 };
        
        return {
          instrument_token: token,
          last_price: dv.getInt32(off + 4) / 100,
          volume: dv.getInt32(off + 16),
          buy_quantity: dv.getInt32(off + 20),
          sell_quantity: dv.getInt32(off + 24),
          ohlc: {
            open: dv.getInt32(off + 28) / 100,
            high: dv.getInt32(off + 32) / 100,
            low: dv.getInt32(off + 36) / 100,
            close: dv.getInt32(off + 40) / 100
          }
        };
      } catch (e) { return null; }
    }
    
    // ========== Interval Button Event Listeners ==========
    document.querySelectorAll('.interval-btn').forEach(btn => {
      btn.addEventListener('click', () => setInterval(btn.dataset.interval));
    });
    
    // ========== Real-time Clock ==========
    function updateClock() {
      const now = new Date();
      const ist = new Date(now.getTime() + (IST_OFFSET * 1000) - (now.getTimezoneOffset() * 60 * 1000));
      const time = ist.toTimeString().split(' ')[0];
      const clockEl = document.getElementById('realtimeClock');
      if (clockEl) clockEl.textContent = time + ' IST';
    }
    setInterval(updateClock, 1000);
    updateClock();
    
    // ========== Last Tick Display ==========
    function updateLastTickDisplay() {
      if (!selectedToken) return;
      const lastTime = lastTickTime[selectedToken];
      const el = document.getElementById('lastTick');
      if (!el) return;
      
      if (lastTime) {
        const ago = Math.floor((Date.now() - lastTime) / 1000);
        el.textContent = 'Last tick: ' + ago + 's ago (#' + tickCount + ')';
        el.className = 'last-tick ' + (ago < 5 ? 'fresh' : 'stale');
      } else {
        el.textContent = 'Waiting for tick...';
        el.className = 'last-tick';
      }
    }
    setInterval(updateLastTickDisplay, 1000);
    
    // ========== Initialize ==========
    async function init() {
      await initDB();
      await cleanOldCandles();
      renderStockList();
      connectWebSocket();
    }
    
    init();
  </script>
</body>
</html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}
