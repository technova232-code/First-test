import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../data/tools_data.dart';
import '../models/tool.dart';
import '../widgets/tool_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String bannerAdUnitId = 'BANNER_AD_UNIT_ID_HERE';
  final String interstitialAdUnitId = 'INTERSTITIAL_AD_UNIT_ID_HERE';n

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _isBannerLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _loadInterstitialAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _isBannerLoaded = true),
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (err) {
          _interstitialAd = null;
        },
      ),
    );
  }

  void _showInterstitialIfAvailable() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, err) {
          ad.dispose();
          _loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  void _copyInstallCommand(String cmd) {
    Clipboard.setData(ClipboardData(text: cmd));
    Fluttertoast.showToast(
      msg: 'تم نسخ أمر التثبيت إلى الحافظة',
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.grey[900],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Widget _buildCategory(String category, List<Tool> tools) {
    return ExpansionTile(
      title: Text(
        category,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      children: tools.map((tool) {
        return ToolTile(
          tool: tool,
          onCopy: () {
            _copyInstallCommand(tool.installCommand);
            _showInterstitialIfAvailable();
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = toolsData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Termux Hub — مركز الأدوات'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ToolsSearchDelegate());
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: categories.entries.map((entry) => _buildCategory(entry.key, entry.value)).toList(),
      ),
      bottomNavigationBar: _isBannerLoaded && _bannerAd != null
          ? SizedBox(
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : null,
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }
}

class ToolsSearchDelegate extends SearchDelegate<Tool?> {
  ToolsSearchDelegate()
      : super(
          searchFieldLabel: 'ابحث عن أداة',
          textInputAction: TextInputAction.search,
        );

  @override
  TextStyle? get searchFieldStyle => GoogleFonts.cairo();

  List<Tool> _allTools() => toolsData.values.expand((list) => list).toList();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: () => close(context, null), icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _allTools().where((t) => t.name.contains(query) || t.installCommand.contains(query)).toList();
    return ListView(
      children: results.map((tool) {
        return ListTile(
          title: Text(tool.name),
          subtitle: Text(tool.installCommand),
          trailing: ElevatedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: tool.installCommand));
              Fluttertoast.showToast(msg: 'تم نسخ أمر التثبيت إلى الحافظة');
            },
            child: const Text('نسخ كود التثبيت'),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = _allTools().where((t) => t.name.contains(query) || t.installCommand.contains(query)).toList();
    return ListView(
      children: suggestions.map((tool) {
        return ListTile(
          title: Text(tool.name),
          onTap: () {
            query = tool.name;
            showResults(context);
          },
        );
      }).toList(),
    );
  }
}
