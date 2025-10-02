import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum IpoStatus { ongoing, upcoming, closed, listed }

enum IpoType { mainboard, sme }

enum SubscriptionCategory { qib, retail, nii, others }

class SubscriptionData {
  final SubscriptionCategory category;
  final double subscriptionTimes;

  const SubscriptionData({
    required this.category,
    required this.subscriptionTimes,
  });
}

class IpoModel extends Equatable {
  final String companyName;
  final IpoType ipoType;
  final String priceBand;
  final int lotSize;
  final DateTime openDate;
  final DateTime closeDate;
  final IpoStatus status;
  final String issueSize;
  final double? totalSubscription;
  final List<SubscriptionData> subscriptionBreakdown;
  final DateTime? listingDate;
  final DateTime? allotmentDate;
  final String? sector;
  final String? leadManager;
  final String? registrar;
  final double? gmp; // Grey Market Premium
  final double? listingPrice;
  final double? listingGains;
  final String? companyLogo;
  final bool isInWatchlist;
  final bool hasApplied;

  const IpoModel({
    required this.companyName,
    required this.ipoType,
    required this.priceBand,
    required this.lotSize,
    required this.openDate,
    required this.closeDate,
    required this.status,
    required this.issueSize,
    this.totalSubscription,
    this.subscriptionBreakdown = const [],
    this.listingDate,
    this.allotmentDate,
    this.sector,
    this.leadManager,
    this.registrar,
    this.gmp,
    this.listingPrice,
    this.listingGains,
    this.companyLogo,
    this.isInWatchlist = false,
    this.hasApplied = false,
  });

  String get ipoTypeString {
    switch (ipoType) {
      case IpoType.mainboard:
        return 'Mainboard';
      case IpoType.sme:
        return 'SME';
    }
  }

  String get statusString {
    switch (status) {
      case IpoStatus.ongoing:
        return 'Ongoing';
      case IpoStatus.upcoming:
        return 'Upcoming';
      case IpoStatus.closed:
        return 'Closed';
      case IpoStatus.listed:
        return 'Listed';
    }
  }

  String get subscriptionStatusText {
    if (totalSubscription == null) return 'Not Available';
    if (totalSubscription! >= 1.0) {
      return '${totalSubscription!.toStringAsFixed(2)}x Subscribed';
    } else {
      return '${(totalSubscription! * 100).toStringAsFixed(0)}% Subscribed';
    }
  }

  bool get isOversubscribed => totalSubscription != null && totalSubscription! > 1.0;

  String get gmpText {
    if (gmp == null) return 'No GMP';
    if (gmp! > 0) {
      return '+₹${gmp!.toStringAsFixed(0)}';
    } else if (gmp! < 0) {
      return '-₹${gmp!.abs().toStringAsFixed(0)}';
    } else {
      return '₹0';
    }
  }

  String get gmpPercentage {
    if (gmp == null) return '0%';
    final priceBandParts = priceBand.split('-');
    if (priceBandParts.length != 2) return '0%';
    final upperPrice = double.tryParse(priceBandParts[1].replaceAll('₹', '').trim());
    if (upperPrice == null || upperPrice == 0) return '0%';
    final percentage = (gmp! / upperPrice) * 100;
    return '${percentage > 0 ? '+' : ''}${percentage.toStringAsFixed(1)}%';
  }

  Color get gmpColor {
    if (gmp == null || gmp == 0) return const Color(0xFF757575);
    return gmp! > 0 ? const Color(0xFF00C853) : const Color(0xFFD32F2F);
  }

  String get listingGainsText {
    if (listingGains == null) return 'Not Listed';
    if (listingGains! > 0) {
      return '+${listingGains!.toStringAsFixed(1)}%';
    } else if (listingGains! < 0) {
      return '${listingGains!.toStringAsFixed(1)}%';
    } else {
      return '0.0%';
    }
  }

  @override
  List<Object?> get props => [
        companyName,
        ipoType,
        priceBand,
        lotSize,
        openDate,
        closeDate,
        status,
        issueSize,
        totalSubscription,
        subscriptionBreakdown,
        listingDate,
        allotmentDate,
        sector,
        leadManager,
        registrar,
        gmp,
        listingPrice,
        listingGains,
        companyLogo,
        isInWatchlist,
        hasApplied,
      ];

  IpoModel copyWith({
    String? companyName,
    IpoType? ipoType,
    String? priceBand,
    int? lotSize,
    DateTime? openDate,
    DateTime? closeDate,
    IpoStatus? status,
    String? issueSize,
    double? totalSubscription,
    List<SubscriptionData>? subscriptionBreakdown,
    DateTime? listingDate,
    DateTime? allotmentDate,
    String? sector,
    String? leadManager,
    String? registrar,
    double? gmp,
    double? listingPrice,
    double? listingGains,
    String? companyLogo,
    bool? isInWatchlist,
    bool? hasApplied,
  }) {
    return IpoModel(
      companyName: companyName ?? this.companyName,
      ipoType: ipoType ?? this.ipoType,
      priceBand: priceBand ?? this.priceBand,
      lotSize: lotSize ?? this.lotSize,
      openDate: openDate ?? this.openDate,
      closeDate: closeDate ?? this.closeDate,
      status: status ?? this.status,
      issueSize: issueSize ?? this.issueSize,
      totalSubscription: totalSubscription ?? this.totalSubscription,
      subscriptionBreakdown: subscriptionBreakdown ?? this.subscriptionBreakdown,
      listingDate: listingDate ?? this.listingDate,
      allotmentDate: allotmentDate ?? this.allotmentDate,
      sector: sector ?? this.sector,
      leadManager: leadManager ?? this.leadManager,
      registrar: registrar ?? this.registrar,
      gmp: gmp ?? this.gmp,
      listingPrice: listingPrice ?? this.listingPrice,
      listingGains: listingGains ?? this.listingGains,
      companyLogo: companyLogo ?? this.companyLogo,
      isInWatchlist: isInWatchlist ?? this.isInWatchlist,
      hasApplied: hasApplied ?? this.hasApplied,
    );
  }
}
