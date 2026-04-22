import 'package:biotech_maali/src/module/account/coin/coin_provider.dart';
import 'package:intl/intl.dart';
import '../../../../../import.dart';
import 'package:biotech_maali/src/widgets/gd_coin_widget.dart';

class CoinHistoryScreen extends StatelessWidget {
  const CoinHistoryScreen({super.key});

  static const Color _primaryGreen = Color(0xFF3B5226);
  static const Color _darkGreen = Color(0xFF1B3012);
  static const Color _bgColor = Color(0xFFF9FBF7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: _darkGreen, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Coin History',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _darkGreen,
              ),
            ),
            Text(
              'Your earnings & redemptions',
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: _primaryGreen),
            onPressed: () {
              final provider = Provider.of<CoinProvider>(context, listen: false);
              provider.refreshTransactions();
            },
          ),
        ],
      ),
      body: Consumer<CoinProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: _primaryGreen));
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  Text('Error loading transactions', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () => provider.refreshTransactions(),
                    child: Text('Retry', style: GoogleFonts.poppins(color: _primaryGreen)),
                  ),
                ],
              ),
            );
          }

          if (provider.coinTransactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                    child: const GdCoinWidget(size: 48),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No coin history yet',
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: _darkGreen),
                  ),
                  Text(
                    'Earn coins by shopping or reviewing products!',
                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Summary Row
              Container(
                margin: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSummaryItem(
                        'Total Earned',
                        provider.totalEarned.toString(),
                        Colors.green.shade700,
                        Icons.add_circle_outline,
                      ),
                    ),
                    Container(height: 40, width: 1, color: Colors.grey.shade100),
                    Expanded(
                      child: _buildSummaryItem(
                        'Total Spent',
                        provider.totalSpent.toString(),
                        Colors.red.shade700,
                        Icons.remove_circle_outline,
                      ),
                    ),
                  ],
                ),
              ),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _buildFilterChip('All', 'all', provider),
                    const SizedBox(width: 8),
                    _buildFilterChip('Earned', 'earned', provider),
                    const SizedBox(width: 8),
                    _buildFilterChip('Spent', 'spent', provider),
                  ],
                ),
              ),

              // Transaction List
              Expanded(
                child: RefreshIndicator(
                  color: _primaryGreen,
                  onRefresh: () => provider.refreshTransactions(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: provider.filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = provider.filteredTransactions[index];
                      final isEarn = transaction.transactionType == 'EARN';
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isEarn ? Colors.green.shade50 : Colors.red.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isEarn ? Icons.add_rounded : Icons.remove_rounded,
                                color: isEarn ? Colors.green.shade700 : Colors.red.shade700,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    transaction.reference,
                                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: _darkGreen),
                                  ),
                                  Text(
                                    DateFormat('dd MMM yyyy, hh:mm a').format(transaction.createdAt),
                                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                const GdCoinWidget(size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  '${isEarn ? '+' : '-'}${transaction.coins}',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isEarn ? Colors.green.shade700 : Colors.red.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade500)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const GdCoinWidget(size: 16),
            const SizedBox(width: 6),
            Text(
              value,
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: _darkGreen),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value, CoinProvider provider) {
    final isSelected = provider.selectedFilter == value;
    return ChoiceChip(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : Colors.grey.shade600,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) provider.setFilter(value);
      },
      selectedColor: _primaryGreen,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isSelected ? _primaryGreen : Colors.grey.shade200),
      ),
      elevation: 0,
      pressElevation: 0,
    );
  }
}
