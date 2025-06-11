import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hobby_reads_flutter/providers/trade_providers.dart';
import 'package:hobby_reads_flutter/screens/shared/app_scaffold.dart';
import 'package:hobby_reads_flutter/data/model/trade_request_model.dart';

class TradeRequestsScreen extends ConsumerStatefulWidget {
  const TradeRequestsScreen({super.key});

  @override
  ConsumerState<TradeRequestsScreen> createState() => _TradeRequestsScreenState();
}

class _TradeRequestsScreenState extends ConsumerState<TradeRequestsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for success/error messages
    ref.listen<TradeRequestsState>(pendingTradeRequestsProvider, (previous, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.successMessage!), backgroundColor: Colors.green),
        );
        ref.read(pendingTradeRequestsProvider.notifier).clearMessages();
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
        ref.read(pendingTradeRequestsProvider.notifier).clearMessages();
      }
    });

    ref.listen<TradeRequestsState>(acceptedTradeRequestsProvider, (previous, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.successMessage!), backgroundColor: Colors.green),
        );
        ref.read(acceptedTradeRequestsProvider.notifier).clearMessages();
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
        ref.read(acceptedTradeRequestsProvider.notifier).clearMessages();
      }
    });

    return AppScaffold(
      title: 'Trade Requests',
      currentRoute: '/trades',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Manage your incoming and outgoing trade requests',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: Theme.of(context).primaryColor,
            isScrollable: true,
            tabs: const [
              Tab(
                child: Text(
                  'Incoming\nRequests',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Tab(
                child: Text(
                  'Outgoing\nRequests',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Tab(
                child: Text(
                  'Accepted\nTrades',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _IncomingRequestsTab(),
                _OutgoingRequestsTab(),
                _AcceptedTradesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshAllTabs() async {
    await Future.wait([
      ref.read(pendingTradeRequestsProvider.notifier).loadPendingRequests(),
      ref.read(acceptedTradeRequestsProvider.notifier).loadAcceptedRequests(),
    ]);
  }
}

class _IncomingRequestsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomingRequests = ref.watch(incomingTradeRequestsProvider);
    final isLoading = ref.watch(pendingTradeRequestsProvider).isLoading;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (incomingRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No incoming requests yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'When someone requests to trade with your books, they\'ll appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(pendingTradeRequestsProvider.notifier).loadPendingRequests(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: incomingRequests.length,
        itemBuilder: (context, index) {
          final request = incomingRequests[index];
          return _TradeRequestCard(request: request, isIncoming: true);
        },
      ),
    );
  }
}

class _OutgoingRequestsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outgoingRequests = ref.watch(outgoingTradeRequestsProvider);
    final isLoading = ref.watch(pendingTradeRequestsProvider).isLoading;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (outgoingRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.outbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No outgoing requests',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You haven\'t sent any trade requests yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(pendingTradeRequestsProvider.notifier).loadPendingRequests(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: outgoingRequests.length,
        itemBuilder: (context, index) {
          final request = outgoingRequests[index];
          return _TradeRequestCard(request: request, isIncoming: false);
        },
      ),
    );
  }
}

class _AcceptedTradesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final acceptedState = ref.watch(acceptedTradeRequestsProvider);

    if (acceptedState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (acceptedState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Error loading accepted trades', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
            const SizedBox(height: 8),
            Text(acceptedState.error!, style: TextStyle(fontSize: 14, color: Colors.grey[500]), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(acceptedTradeRequestsProvider.notifier).loadAcceptedRequests(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (acceptedState.requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.handshake_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No accepted trades yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Accepted trade requests will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(acceptedTradeRequestsProvider.notifier).loadAcceptedRequests(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: acceptedState.requests.length,
        itemBuilder: (context, index) {
          final request = acceptedState.requests[index];
          return _AcceptedTradeCard(request: request);
        },
      ),
    );
  }
}

class _TradeRequestCard extends ConsumerWidget {
  final TradeRequestModel request;
  final bool isIncoming;

  const _TradeRequestCard({required this.request, required this.isIncoming});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProcessing = ref.watch(pendingTradeRequestsProvider).isLoading;
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: isIncoming ? Theme.of(context).primaryColor : Colors.grey[300],
                  child: Text(
                    _getUserInitial(),
                    style: TextStyle(
                      color: isIncoming ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isIncoming ? _getUserName() : 'Request to ${_getUserName()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${isIncoming ? "Requested" : "Sent"} on ${_formatDate(request.createdAt)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isIncoming)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Pending',
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: request.senderBook?.coverImage != null
                      ? Image.network(
                          request.senderBook!.coverImage!,
                          width: 100,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 100,
                            height: 150,
                            color: Colors.grey[300],
                            child: Icon(Icons.book, color: Colors.grey[600]),
                          ),
                        )
                      : Container(
                          width: 100,
                          height: 150,
                          color: Colors.grey[300],
                          child: Icon(Icons.book, color: Colors.grey[600]),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.senderBook?.title ?? 'Unknown Book',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'by ${request.senderBook?.author ?? 'Unknown Author'}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      if (request.message != null && request.message!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          '${isIncoming ? "Message" : "Your message"}: "${request.message}"',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      _buildActionButtons(context, ref, isProcessing),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, bool isProcessing) {
    if (isIncoming) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: isProcessing ? null : () {
                ref.read(pendingTradeRequestsProvider.notifier)
                    .acceptTradeRequest(request.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isProcessing
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Accept',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: isProcessing ? null : () {
                ref.read(pendingTradeRequestsProvider.notifier)
                    .rejectTradeRequest(request.id);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                side: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Reject',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: isProcessing ? null : () {
            _showCancelConfirmation(context, ref);
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Cancel Request',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
  }

  void _showCancelConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Trade Request'),
        content: const Text('Are you sure you want to cancel this trade request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Keep Request'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(pendingTradeRequestsProvider.notifier).cancelTradeRequest(request.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Cancel Request'),
          ),
        ],
      ),
    );
  }

  String _getUserInitial() {
    if (isIncoming) {
      return request.senderProfile?.name.isNotEmpty == true 
          ? request.senderProfile!.name[0].toUpperCase()
          : 'U';
    } else {
      return request.receiverProfile?.name.isNotEmpty == true 
          ? request.receiverProfile!.name[0].toUpperCase()
          : 'U';
    }
  }

  String _getUserName() {
    if (isIncoming) {
      return request.senderProfile?.name ?? 'Unknown User';
    } else {
      return request.receiverProfile?.name ?? 'Unknown User';
    }
  }
}

class _AcceptedTradeCard extends StatelessWidget {
  final TradeRequestModel request;

  const _AcceptedTradeCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.check, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trade with ${_getOtherUserName()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Accepted on ${_formatDate(request.updatedAt)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Accepted',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: request.senderBook?.coverImage != null
                      ? Image.network(
                          request.senderBook!.coverImage!,
                          width: 100,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 100,
                            height: 150,
                            color: Colors.grey[300],
                            child: Icon(Icons.book, color: Colors.grey[600]),
                          ),
                        )
                      : Container(
                          width: 100,
                          height: 150,
                          color: Colors.grey[300],
                          child: Icon(Icons.book, color: Colors.grey[600]),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.senderBook?.title ?? 'Unknown Book',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'by ${request.senderBook?.author ?? 'Unknown Author'}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Trade Completed!',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'You can now coordinate the book exchange with ${_getOtherUserName()}.',
                              style: TextStyle(
                                color: Colors.green.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getOtherUserName() {
    if (request.senderProfile?.name != null) {
      return request.senderProfile!.name;
    } else if (request.receiverProfile?.name != null) {
      return request.receiverProfile!.name;
    }
    return 'Unknown User';
  }
}

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
} 