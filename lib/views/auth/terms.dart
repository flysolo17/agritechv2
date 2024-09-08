import 'package:agritechv2/styles/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final termsList = Terms.init();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Terms and Conditions",
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        ),
        backgroundColor: ColorStyle.brandRed,
      ),
      body: ListView.builder(
        itemCount: termsList.length,
        itemBuilder: (context, index) {
          final term = termsList[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  term.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  term.desc,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Terms {
  String title;
  String desc;

  Terms({required this.title, required this.desc});

  static List<Terms> init() {
    return [
      Terms(
        title: "Last Updated: January 2024",
        desc:
            "Welcome to AgriTech, a mobile commerce app dedicated to connecting farmers, suppliers, and consumers. By downloading, installing, or using the AgriTech app (\"App\"), you agree to comply with and be bound by the following terms and conditions (\"Terms\"). Please read these Terms carefully before using the App. If you do not agree with these Terms, please do not use the App.",
      ),
      Terms(
        title: "1. Acceptance of Terms",
        desc:
            "By using the AgriTech App, you agree to be legally bound by these Terms and any other policies, rules, or guidelines that may be applicable to specific sections or features of the App. These Terms constitute a legally binding agreement between you (\"User,\" \"you,\" or \"your\") and AgriTech (\"we,\" \"us,\" or \"our\").",
      ),
      Terms(
        title: "2. Eligibility",
        desc:
            "You must be at least 18 years old or have parental consent to use this App. By using the App, you represent and warrant that you meet all the eligibility requirements outlined in these Terms.",
      ),
      Terms(
        title: "3. User Account",
        desc:
            "To access certain features of the App, you may be required to create an account. You agree to provide accurate, current, and complete information during the registration process and to update such information to keep it accurate, current, and complete. You are responsible for maintaining the confidentiality of your account login details and for all activities that occur under your account.",
      ),
      Terms(
        title: "4. Use of the App",
        desc:
            "You agree to use the App solely for lawful purposes and in accordance with these Terms. You will not:\n• Use the App in any way that violates applicable local, national, or international law or regulation.\n• Engage in any conduct that restricts or inhibits anyone’s use or enjoyment of the App.\n• Reproduce, duplicate, copy, sell, resell, or exploit any portion of the App without express written permission from us.",
      ),
      Terms(
        title: "5. Payment and Transactions",
        desc:
            "All transactions conducted through the App are subject to our payment terms. We use third-party payment processors to handle financial transactions. You acknowledge that AgriTech is not responsible for any errors or issues related to payments made through the App.",
      ),
      Terms(
        title: "6. Intellectual Property Rights",
        desc:
            "All content and materials available on the App, including but not limited to text, graphics, logos, and software, are the property of AgriTech or its licensors and are protected by copyright, trademark, and other intellectual property rights. You agree not to modify, reproduce, distribute, or create derivative works based on the App’s content without our prior written permission.",
      ),
      Terms(
        title: "7. Privacy Policy",
        desc:
            "Your use of the App is also governed by our Privacy Policy, which outlines how we collect, use, and protect your personal information. By using the App, you consent to the collection and use of your data in accordance with our Privacy Policy.",
      ),
      Terms(
        title: "8. Disclaimer of Warranties",
        desc:
            "The App is provided on an \"as is\" and \"as available\" basis. We do not warrant that the App will be uninterrupted, secure, or error-free. We disclaim all warranties, whether express or implied, including but not limited to the implied warranties of merchantability, fitness for a particular purpose, and noninfringement.",
      ),
      Terms(
        title: "9. Limitation of Liability",
        desc:
            "To the maximum extent permitted by law, AgriTech shall not be liable for any direct, indirect, incidental, special, consequential, or punitive damages arising from or related to your use of the App.",
      ),
      Terms(
        title: "10. Changes to the Terms",
        desc:
            "We reserve the right to update or modify these Terms at any time. Your continued use of the App after any changes indicates your acceptance of the new Terms. Please review these Terms periodically for updates.",
      ),
      Terms(
        title: "11. Governing Law",
        desc:
            "These Terms shall be governed by and construed in accordance with the laws of [Your Country/State]. Any disputes arising under or in connection with these Terms shall be subject to the exclusive jurisdiction of the courts located in [Your Country/State].",
      ),
      Terms(
        title: "12. Contact Us",
        desc:
            "If you have any questions or concerns about these Terms, please contact us:\nS&P Enterprises Incorporated\nEmail: sales@agritech.com.ph\nTel #: 075 500 5005\nAddress: Belmonte Street, Brgy. Poblacion, Urdaneta, 2428 Pangasinan",
      ),
      Terms(
        title: "S&P Enterprises Incorporated",
        desc:
            "Email: sales@agritech.com.ph\nTel #: 075 500 5005\nAddress: Belmonte Street, Brgy. Poblacion, Urdaneta, 2428 Pangasinan",
      ),
    ];
  }
}
