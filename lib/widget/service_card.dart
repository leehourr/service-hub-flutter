import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:service_hub/screen/auth/login_screen.dart';
import 'package:service_hub/widget/home.dart';
import 'package:service_hub/widget/service_details.dart';

class ServiceCard extends StatelessWidget {
  final bool isLogin;
  final String imageUrl;
  final String serviceName;
  final String serviceProviderName;
  final String description;
  final int providerId;
  final VoidCallback navigateToAccount;

  const ServiceCard({
    super.key,
    required this.isLogin,
    required this.imageUrl,
    required this.serviceName,
    required this.serviceProviderName,
    required this.description,
    required this.providerId,
    required this.navigateToAccount,
  });

  @override
  Widget build(BuildContext context) {
    void navgiateToServiceDetail() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServiceDetailWidget(
            key: key,
            imageUrl: imageUrl,
            serviceName: serviceName,
            senderId: providerId,
            serviceProviderName: serviceProviderName,
            description: description,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (!isLogin) {
          navigateToAccount();
          return;
        }
        navgiateToServiceDetail();
      },
      child: Container(
        width: 200,
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: .5),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image(
              //   height: 100,
              //   image: NetworkImage(imageUrl),
              //   fit: BoxFit.cover,
              // ),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(serviceProviderName),
                      // Row(
                      //   children: List.generate(
                      //     5,
                      //     (index) => const Icon(
                      //       Icons.star,
                      //       color: Colors.yellow,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
