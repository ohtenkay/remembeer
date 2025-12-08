import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/model/leaderboard.dart';
import 'package:remembeer/leaderboard/model/leaderboard_entry.dart';
import 'package:remembeer/leaderboard/model/leaderboard_type.dart';
import 'package:remembeer/leaderboard/service/leaderboard_service.dart';
import 'package:remembeer/leaderboard/service/month_service.dart';
import 'package:remembeer/leaderboard/widget/month_selector.dart';
import 'package:remembeer/leaderboard/widget/standing_card.dart';

class LeaderboardDetailPage extends StatefulWidget {
  final Leaderboard leaderboard;

  const LeaderboardDetailPage({super.key, required this.leaderboard});

  @override
  State<LeaderboardDetailPage> createState() => _LeaderboardDetailPageState();
}

class _LeaderboardDetailPageState extends State<LeaderboardDetailPage> {
  final _leaderboardService = get<LeaderboardService>();
  final _monthService = get<MonthService>();

  var _sortType = LeaderboardType.beers;

  @override
  void initState() {
    super.initState();
    _monthService.resetToCurrentMonth();
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = _leaderboardService.isOwner(widget.leaderboard);

    return PageTemplate(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events, size: 24),
          const SizedBox(width: 8),
          Text(widget.leaderboard.name),
        ],
      ),
      child: Column(
        children: [
          if (isOwner) _buildConfigButton(context),
          MonthSelector(),
          const SizedBox(height: 8),
          _buildSortToggle(),
          const SizedBox(height: 16),
          Expanded(child: _buildStandingsList()),
        ],
      ),
    );
  }

  Widget _buildConfigButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
    );
  }

  Widget _buildSortToggle() {
    return SegmentedButton<LeaderboardType>(
      segments: const [
        ButtonSegment(
          value: LeaderboardType.beers,
          label: Text('Beers'),
          icon: Icon(Icons.sports_bar),
        ),
        ButtonSegment(
          value: LeaderboardType.alcohol,
          label: Text('Alcohol'),
          icon: Icon(Icons.local_bar),
        ),
      ],
      selected: {_sortType},
      onSelectionChanged: (selection) {
        setState(() => _sortType = selection.first);
      },
    );
  }

  Widget _buildStandingsList() {
    return AsyncBuilder<List<LeaderboardEntry>>(
      stream: _leaderboardService.standingsStreamFor(widget.leaderboard),
      builder: (context, standings) {
        final sortedStandings = List<LeaderboardEntry>.from(standings);
        if (_sortType == LeaderboardType.beers) {
          sortedStandings.sort(
            (a, b) => a.rankByBeers.compareTo(b.rankByBeers),
          );
        } else {
          sortedStandings.sort(
            (a, b) => a.rankByAlcohol.compareTo(b.rankByAlcohol),
          );
        }

        return ListView.builder(
          itemCount: sortedStandings.length,
          itemBuilder: (context, index) {
            final entry = sortedStandings[index];
            return StandingCard(entry: entry, sortType: _sortType);
          },
        );
      },
    );
  }
}
