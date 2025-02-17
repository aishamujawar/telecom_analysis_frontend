import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';

class ChurnAnalysisPage extends StatefulWidget {
  @override
  _ChurnAnalysisPageState createState() => _ChurnAnalysisPageState();
}

class _ChurnAnalysisPageState extends State<ChurnAnalysisPage> {
  String churnCountsImageUrl = "http://192.168.1.5:5001/get_churn_counts_image";
  String missingValuesImageUrl = "http://192.168.1.5:5001/get_missing_values_plot";
  List<String> countplotImageUrls = [];
  String monthlyVsTotalChargesImageUrl = "http://192.168.1.5:5001/get_monthly_vs_total_charges";
  String monthlyChargesKdeUrl = "http://192.168.1.5:5001/get_monthly_charges_kde";
  String totalChargesKdeUrl = "http://192.168.1.5:5001/get_total_charges_kde";
  String churnCorrelationBarUrl = "http://192.168.1.5:5001/get_churn_correlation_bar";
  String correlationHeatmapUrl = "http://192.168.1.5:5001/get_correlation_heatmap";
  String genderForChurnedUrl = "http://192.168.1.5:5001/get_distribution_of_gender_for_churned_customers";
  String genderForNonChurnedUrl = "http://192.168.1.5:5001/get_distribution_of_gender_for_non_churned_customers";
  String paymentMethodForChurnedUrl = "http://192.168.1.5:5001/get_distribution_of_paymentmethod_for_churned_customers";
  String contractForChurnedUrl = "http://192.168.1.5:5001/get_distribution_of_contract_for_churned_customers";
  String techSupportForChurnedUrl = "http://192.168.1.5:5001/get_distribution_of_techsupport_for_churned_customers";
  String seniorCitizenForChurnedUrl = "http://192.168.1.5:5001/get_distribution_of_seniorcitizen_for_churned_customers";
  String distributionTenureByChurnUrl = "http://192.168.1.5:5001/get_distribution_tenure_by_churn";
  String distributionMonthlyChargesByChurnUrl = "http://192.168.1.5:5001/get_distribution_monthlycharges_by_churn";
  String distributionTotalChargesByChurnUrl = "http://192.168.1.5:5001/get_distribution_totalcharges_by_churn";
  String customerSegmentationImageUrl = "http://192.168.1.5:5001/get_customer_segmentation_by_contract_tenure";
  String featureImportanceImageUrl = "http://192.168.1.5:5001/get_feature_importance_random_forest";
  String customerClustersImageUrl = "http://192.168.1.5:5001/get_customer_clusters_plot";
  String survivalAnalysisImageUrl = "http://192.168.1.5:5001/get_survival_analysis_plot";

  // Use CarouselSliderController instead of CarouselController
  final CarouselSliderController _countPlotController = CarouselSliderController();
  final CarouselSliderController _churnedNonChurnedController = CarouselSliderController();
  final CarouselSliderController _distributionController = CarouselSliderController();

  // Track current index for each carousel
  int _currentCountPlotIndex = 0;
  int _currentChurnedNonChurnedIndex = 0;
  int _currentDistributionIndex = 0;

  // Fetch methods (unchanged from your original code)
  Future<void> fetchCountplotImages() async {
    final predictors = ['gender', 'SeniorCitizen', 'Partner', 'Dependents', 'PhoneService', 'MultipleLines', 'InternetService', 'OnlineSecurity', 'OnlineBackup', 'DeviceProtection', 'TechSupport', 'StreamingTV', 'StreamingMovies', 'Contract', 'PaperlessBilling', 'PaymentMethod', 'tenure_group'];

    for (var predictor in predictors) {
      final response = await http.get(Uri.parse("http://192.168.1.5:5001/get_countplot/$predictor"));
      if (!mounted) return;
      if (response.statusCode == 200) {
        setState(() {
          countplotImageUrls.add("http://192.168.1.5:5001/get_countplot/$predictor");
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCountplotImages();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Group images for carousels
    List<String> churnedNonChurnedUrls = [
      genderForChurnedUrl,
      genderForNonChurnedUrl,
      paymentMethodForChurnedUrl,
      contractForChurnedUrl,
      techSupportForChurnedUrl,
      seniorCitizenForChurnedUrl,
    ];

    List<String> distributionUrls = [
      distributionTenureByChurnUrl,
      distributionMonthlyChargesByChurnUrl,
      distributionTotalChargesByChurnUrl,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Churn Analysis Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Carousel 1: Count Plots
            _buildCarousel("Count Plots", countplotImageUrls, _countPlotController, _currentCountPlotIndex, (index) {
              setState(() {
                _currentCountPlotIndex = index;
              });
            }),
            SizedBox(height: 24.0),

            // Carousel 2: For Churned/Non-Churned
            _buildCarousel("For Churned/Non-Churned", churnedNonChurnedUrls, _churnedNonChurnedController, _currentChurnedNonChurnedIndex, (index) {
              setState(() {
                _currentChurnedNonChurnedIndex = index;
              });
            }),
            SizedBox(height: 24.0),

            // Carousel 3: Distribution Charts
            _buildCarousel("Distribution Charts", distributionUrls, _distributionController, _currentDistributionIndex, (index) {
              setState(() {
                _currentDistributionIndex = index;
              });
            }),
            SizedBox(height: 24.0),

            // Masonry Layout for Other Images
            MasonryGridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3, // 3 images per row
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              itemCount: 11, // Number of standalone images
              itemBuilder: (context, index) {
                if (index == 0) return _buildImageWithLabel("Churn Counts", churnCountsImageUrl, screenWidth * 0.4);
                if (index == 1) return _buildImageWithLabel("Missing Values Plot", missingValuesImageUrl, screenWidth * 0.4);
                if (index == 2) return _buildImageWithLabel("Monthly vs Total Charges", monthlyVsTotalChargesImageUrl, screenWidth * 0.4);
                if (index == 3) return _buildImageWithLabel("Monthly Charges KDE", monthlyChargesKdeUrl, screenWidth * 0.4);
                if (index == 4) return _buildImageWithLabel("Total Charges KDE", totalChargesKdeUrl, screenWidth * 0.4);
                if (index == 5) return _buildImageWithLabel("Correlation Heatmap", correlationHeatmapUrl, screenWidth * 0.4);
                if (index == 6) return _buildImageWithLabel("Customer Clusters", customerClustersImageUrl, screenWidth * 0.4);
                if (index == 7) return _buildImageWithLabel("Churn Correlation Bar", churnCorrelationBarUrl, screenWidth * 0.4);
                if (index == 8) return _buildImageWithLabel("Customer Segmentation", customerSegmentationImageUrl, screenWidth * 0.4);
                if (index == 9) return _buildImageWithLabel("Feature Importance", featureImportanceImageUrl, screenWidth * 0.4);
                if (index == 10) return _buildImageWithLabel("Survival Analysis", survivalAnalysisImageUrl, screenWidth * 0.4);
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWithLabel(String label, String imageUrl, double width) {
    return GestureDetector(
      onTap: () {
        // Open full-screen dialog
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(10),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: InteractiveViewer(
                        panEnabled: true,
                        boundaryMargin: EdgeInsets.all(20),
                        minScale: 0.5,
                        maxScale: 4,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white, size: 32),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 18, // Larger title
                fontWeight: FontWeight.bold, // Bolder title
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.0),
            Image.network(
              imageUrl,
              width: width,
              fit: BoxFit.contain, // Resize without cropping
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(String title, List<String> imageUrls, CarouselSliderController controller, int currentIndex, Function(int) onPageChanged) {
    return Container(
      color: Colors.grey[900], // Background for carousels
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24, // Larger title
              fontWeight: FontWeight.bold, // Bolder title
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.0),
          Stack(
            alignment: Alignment.center,
            children: [
              CarouselSlider(
                carouselController: controller,
                options: CarouselOptions(
                  height: 400, // Increased carousel height
                  enlargeCenterPage: true,
                  viewportFraction: 0.8, // Make images slightly smaller than the carousel width
                  enableInfiniteScroll: true,
                  autoPlay: false, // Disable auto-play
                  scrollDirection: Axis.horizontal,
                  pageSnapping: true,
                  onPageChanged: (index, reason) {
                    onPageChanged(index);
                  },
                ),
                items: imageUrls.map((url) {
                  return GestureDetector(
                    onTap: () {
                      // Open full-screen dialog
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding: EdgeInsets.all(10),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Expanded(
                                    child: InteractiveViewer(
                                      panEnabled: true,
                                      boundaryMargin: EdgeInsets.all(20),
                                      minScale: 0.5,
                                      maxScale: 4,
                                      child: Image.network(
                                        url,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  IconButton(
                                    icon: Icon(Icons.close, color: Colors.white, size: 32),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Image.network(
                        url,
                        fit: BoxFit.contain, // Resize without cropping
                      ),
                    ),
                  );
                }).toList(),
              ),
              Positioned(
                left: 8.0,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 32.0),
                  onPressed: () {
                    controller.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ); // Move to the previous image
                  },
                ),
              ),
              Positioned(
                right: 8.0,
                child: IconButton(
                  icon: Icon(Icons.arrow_forward, color: Colors.white, size: 32.0),
                  onPressed: () {
                    controller.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ); // Move to the next image
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imageUrls.map((url) {
              int index = imageUrls.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == index ? Colors.white : Colors.grey,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}