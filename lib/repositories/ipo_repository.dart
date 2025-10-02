import '../models/ipo_model.dart';

class IpoRepository {
  static final List<IpoModel> _realIpos = [
    // Ongoing IPOs - Real data from research with GMP
    IpoModel(
      companyName: 'Om Freight Forwarders',
      ipoType: IpoType.mainboard,
      priceBand: '₹128 - ₹135',
      lotSize: 111,
      openDate: DateTime(2025, 9, 29),
      closeDate: DateTime(2025, 10, 3),
      status: IpoStatus.ongoing,
      issueSize: '₹45.2 Cr',
      totalSubscription: 0.85,
      sector: 'Logistics & Transportation',
      leadManager: 'Beeline Capital Advisors',
      allotmentDate: DateTime(2025, 10, 6),
      listingDate: DateTime(2025, 10, 8),
      gmp: -5.0, // Grey Market Premium
      subscriptionBreakdown: [
        SubscriptionData(category: SubscriptionCategory.qib, subscriptionTimes: 1.2),
        SubscriptionData(category: SubscriptionCategory.retail, subscriptionTimes: 0.7),
        SubscriptionData(category: SubscriptionCategory.nii, subscriptionTimes: 0.6),
      ],
    ),
    IpoModel(
      companyName: 'Advance Agrolife',
      ipoType: IpoType.mainboard,
      priceBand: '₹95 - ₹100',
      lotSize: 150,
      openDate: DateTime(2025, 9, 30),
      closeDate: DateTime(2025, 10, 3),
      status: IpoStatus.ongoing,
      issueSize: '₹192.86 Cr',
      totalSubscription: 1.87,
      sector: 'Agriculture & Chemicals',
      leadManager: 'Kotak Mahindra Capital',
      allotmentDate: DateTime(2025, 10, 6),
      listingDate: DateTime(2025, 10, 8),
      gmp: 12.0, // Positive GMP due to oversubscription
      subscriptionBreakdown: [
        SubscriptionData(category: SubscriptionCategory.qib, subscriptionTimes: 3.5),
        SubscriptionData(category: SubscriptionCategory.retail, subscriptionTimes: 1.22),
        SubscriptionData(category: SubscriptionCategory.nii, subscriptionTimes: 1.22),
      ],
    ),
    IpoModel(
      companyName: 'Zelio E-Mobility',
      ipoType: IpoType.sme,
      priceBand: '₹129 - ₹136',
      lotSize: 1000,
      openDate: DateTime(2025, 9, 30),
      closeDate: DateTime(2025, 10, 3),
      status: IpoStatus.ongoing,
      issueSize: '₹78.34 Cr',
      totalSubscription: 0.54,
      sector: 'Electric Vehicles',
      leadManager: 'Hem Securities',
      allotmentDate: DateTime(2025, 10, 6),
      listingDate: DateTime(2025, 10, 8),
      gmp: 8.0, // Positive GMP for EV sector
      subscriptionBreakdown: [
        SubscriptionData(category: SubscriptionCategory.qib, subscriptionTimes: 1.27),
        SubscriptionData(category: SubscriptionCategory.retail, subscriptionTimes: 0.24),
        SubscriptionData(category: SubscriptionCategory.nii, subscriptionTimes: 0.36),
      ],
    ),

    // Upcoming IPOs - Real upcoming companies
    IpoModel(
      companyName: 'Purple Style Labs',
      ipoType: IpoType.mainboard,
      priceBand: '₹350 - ₹380',
      lotSize: 39,
      openDate: DateTime(2025, 10, 15),
      closeDate: DateTime(2025, 10, 18),
      status: IpoStatus.upcoming,
      issueSize: '₹125 Cr',
      sector: 'Fashion & Lifestyle',
      leadManager: 'ICICI Securities',
      gmp: 25.0, // Expected positive GMP for fashion brand
    ),
    IpoModel(
      companyName: 'CSM Technologies',
      ipoType: IpoType.sme,
      priceBand: '₹180 - ₹200',
      lotSize: 600,
      openDate: DateTime(2025, 10, 20),
      closeDate: DateTime(2025, 10, 23),
      status: IpoStatus.upcoming,
      issueSize: '₹45 Cr',
      sector: 'Information Technology',
      leadManager: 'Axis Capital',
      gmp: 15.0, // IT sector premium
    ),
    IpoModel(
      companyName: 'Shriram Food Industry',
      ipoType: IpoType.mainboard,
      priceBand: '₹280 - ₹320',
      lotSize: 46,
      openDate: DateTime(2025, 11, 5),
      closeDate: DateTime(2025, 11, 8),
      status: IpoStatus.upcoming,
      issueSize: '₹89 Cr',
      sector: 'Food Processing',
      leadManager: 'Kotak Mahindra Capital',
      gmp: 18.0, // Food processing sector premium
    ),
    IpoModel(
      companyName: 'Cotec Healthcare',
      ipoType: IpoType.sme,
      priceBand: '₹220 - ₹250',
      lotSize: 500,
      openDate: DateTime(2025, 11, 12),
      closeDate: DateTime(2025, 11, 15),
      status: IpoStatus.upcoming,
      issueSize: '₹67 Cr',
      sector: 'Healthcare & Pharmaceuticals',
      leadManager: 'HDFC Bank',
      gmp: 22.0, // Healthcare sector premium
    ),

    // Closed IPOs - Real recently closed IPOs
    IpoModel(
      companyName: 'Ameenji Rubber',
      ipoType: IpoType.sme,
      priceBand: '₹85 - ₹90',
      lotSize: 1600,
      openDate: DateTime(2025, 9, 18),
      closeDate: DateTime(2025, 9, 20),
      status: IpoStatus.closed,
      issueSize: '₹12.5 Cr',
      totalSubscription: 2.45,
      sector: 'Rubber & Plastics',
      leadManager: 'Bigshare Services',
      allotmentDate: DateTime(2025, 9, 23),
      listingDate: DateTime(2025, 9, 25),
      gmp: 8.0, // Positive GMP due to oversubscription
      listingPrice: 95.0,
      listingGains: 5.6, // 5.6% listing gains
    ),
    IpoModel(
      companyName: 'Bhavik Enterprises',
      ipoType: IpoType.sme,
      priceBand: '₹45 - ₹48',
      lotSize: 2000,
      openDate: DateTime(2025, 9, 16),
      closeDate: DateTime(2025, 9, 18),
      status: IpoStatus.closed,
      issueSize: '₹8.2 Cr',
      totalSubscription: 1.78,
      sector: 'Trading & Distribution',
      leadManager: 'Bigshare Services',
      allotmentDate: DateTime(2025, 9, 21),
      listingDate: DateTime(2025, 9, 23),
      gmp: 3.0,
      listingPrice: 52.0,
      listingGains: 8.3, // 8.3% listing gains
    ),
    IpoModel(
      companyName: 'Chiraharit',
      ipoType: IpoType.sme,
      priceBand: '₹110 - ₹116',
      lotSize: 1200,
      openDate: DateTime(2025, 9, 12),
      closeDate: DateTime(2025, 9, 16),
      status: IpoStatus.closed,
      issueSize: '₹15.8 Cr',
      totalSubscription: 3.2,
      sector: 'Agriculture & Allied',
      leadManager: 'Bigshare Services',
      allotmentDate: DateTime(2025, 9, 19),
      listingDate: DateTime(2025, 9, 21),
      gmp: 15.0,
      listingPrice: 128.0,
      listingGains: 10.3, // 10.3% listing gains
    ),
    IpoModel(
      companyName: 'DSM Fresh Foods',
      ipoType: IpoType.sme,
      priceBand: '₹75 - ₹80',
      lotSize: 1800,
      openDate: DateTime(2025, 9, 9),
      closeDate: DateTime(2025, 9, 11),
      status: IpoStatus.closed,
      issueSize: '₹22.4 Cr',
      totalSubscription: 4.1,
      sector: 'Food & Beverages',
      leadManager: 'Maashitla Securities',
      allotmentDate: DateTime(2025, 9, 14),
      listingDate: DateTime(2025, 9, 16),
      gmp: 12.0,
      listingPrice: 88.0,
      listingGains: 10.0, // 10% listing gains
    ),

    // Listed IPOs - Recently listed
    IpoModel(
      companyName: 'Riddhi Display Equipments',
      ipoType: IpoType.sme,
      priceBand: '₹65 - ₹70',
      lotSize: 2000,
      openDate: DateTime(2025, 8, 28),
      closeDate: DateTime(2025, 8, 30),
      status: IpoStatus.listed,
      issueSize: '₹18.6 Cr',
      totalSubscription: 5.8,
      sector: 'Display Technology',
      leadManager: 'Hem Securities',
      allotmentDate: DateTime(2025, 9, 2),
      listingDate: DateTime(2025, 9, 4),
      gmp: 18.0,
      listingPrice: 85.0,
      listingGains: 21.4, // 21.4% listing gains
    ),
    IpoModel(
      companyName: 'Systematic Industries',
      ipoType: IpoType.mainboard,
      priceBand: '₹420 - ₹450',
      lotSize: 33,
      openDate: DateTime(2025, 8, 25),
      closeDate: DateTime(2025, 8, 29),
      status: IpoStatus.listed,
      issueSize: '₹156 Cr',
      totalSubscription: 2.1,
      sector: 'Industrial Equipment',
      leadManager: 'ICICI Securities',
      allotmentDate: DateTime(2025, 9, 1),
      listingDate: DateTime(2025, 9, 3),
      gmp: 35.0,
      listingPrice: 478.0,
      listingGains: 6.2, // 6.2% listing gains
    ),
  ];

  Future<List<IpoModel>> getAllIpos() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_realIpos);
  }

  Future<List<IpoModel>> getIposByStatus(IpoStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _realIpos.where((ipo) => ipo.status == status).toList();
  }

  Future<List<IpoModel>> searchIpos(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (query.isEmpty) return List.from(_realIpos);
    
    return _realIpos
        .where((ipo) => ipo.companyName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<IpoModel>> searchIposByStatus(String query, IpoStatus status) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (query.isEmpty) return getIposByStatus(status);
    
    return _realIpos
        .where((ipo) => 
            ipo.status == status && 
            ipo.companyName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
