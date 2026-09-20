import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/hotel_model.dart';
import '../../data/models/room_model.dart';
import '../../core/services/image_service/image_service.dart';
import '../../core/services/payment_service.dart';
import '../../core/services/auth_service.dart';
import '../../core/config/dependency_injection.dart';
import '../../core/config/app_router.dart';
import '../../domain/repositories/booking/booking_repository.dart';
import '../../data/models/booking_model.dart';
import '../../core/services/notification_service.dart';
import '../widgets/calendar_widget.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingScreen extends StatefulWidget {
  final HotelModel hotel;
  final RoomModel room;
  const BookingScreen({super.key, required this.hotel, required this.room});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _couponController = TextEditingController();
  final _specialRequestsController = TextEditingController();

  double _discountAmount = 0.0;
  String? _appliedCoupon;
  String? _couponError;
  bool _isSubmitting = false;

  DateTime checkIn = DateTime.now().add(const Duration(days: 1));
  DateTime checkOut = DateTime.now().add(const Duration(days: 3));
  int guests = 2;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _couponController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nights = checkOut.difference(checkIn).inDays;
    final subtotal = widget.room.pricePerNight * nights;
    final taxes = subtotal * 0.12;
    final serviceFee = 500.0;
    final totalBeforeDiscount = subtotal + taxes + serviceFee;
    final total = totalBeforeDiscount - _discountAmount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Review Booking', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHotelSummary(),
              const SizedBox(height: 32),
              _buildSectionTitle('Stay Details'),
              const SizedBox(height: 16),
              _buildStayDetails(),
              const SizedBox(height: 32),
              _buildSectionTitle('Guest Details'),
              const SizedBox(height: 16),
              _buildGuestForm(),
              const SizedBox(height: 32),
              _buildCouponSection(subtotal),
              const SizedBox(height: 32),
              _buildSectionTitle('Price Summary'),
              const SizedBox(height: 16),
              _buildPriceSummary(subtotal, taxes, serviceFee, total),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _processBooking(total),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Confirm & Pay ₹${total.toInt()}', style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'By proceeding, you agree to our Terms and Conditions',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }

  Widget _buildHotelSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          ImageService.room(
            imageUrl: widget.room.images.first,
            width: 90,
            height: 90,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.hotel.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                Text(widget.room.name, style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.secondary, size: 14),
                    const SizedBox(width: 4),
                    Text('${widget.hotel.starRating} Star Hotel', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStayDetails() {
    final df = DateFormat('EEE, MMM dd');
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => CalendarWidget.show(
                  context,
                  initialStartDate: checkIn,
                  initialEndDate: checkOut,
                  onDatesSelected: (start, end) {
                    if (start != null && end != null) {
                      setState(() {
                        checkIn = start;
                        checkOut = end;
                        _discountAmount = 0.0;
                        _appliedCoupon = null;
                        _couponController.clear();
                      });
                    }
                  },
                ),
                child: _buildDateItem('CHECK-IN', df.format(checkIn)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                child: Text('${checkOut.difference(checkIn).inDays} Nights', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              InkWell(
                onTap: () => CalendarWidget.show(
                  context,
                  initialStartDate: checkIn,
                  initialEndDate: checkOut,
                  onDatesSelected: (start, end) {
                    if (start != null && end != null) {
                      setState(() {
                        checkIn = start;
                        checkOut = end;
                        _discountAmount = 0.0;
                        _appliedCoupon = null;
                        _couponController.clear();
                      });
                    }
                  },
                ),
                child: _buildDateItem('CHECK-OUT', df.format(checkOut)),
              ),
            ],
          ),
          const Divider(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Number of Guests', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  _buildCountButton(Icons.remove, () => setState(() => guests > 1 ? guests-- : null)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('$guests', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  _buildCountButton(Icons.add, () => setState(() => guests++)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCountButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(border: Border.all(color: AppColors.primary), borderRadius: BorderRadius.circular(4)),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }

  Widget _buildDateItem(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1.2)),
        const SizedBox(height: 4),
        Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildGuestForm() {
    return Column(
      children: [
        _buildTextField(_nameController, 'Primary Guest Full Name', Icons.person_outline),
        const SizedBox(height: 16),
        _buildTextField(_emailController, 'Email Address', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
        const SizedBox(height: 16),
        _buildTextField(_phoneController, 'Phone Number', Icons.phone_android_outlined, keyboardType: TextInputType.phone),
        const SizedBox(height: 16),
        _buildTextField(_specialRequestsController, 'Special Requests (Optional)', Icons.notes_outlined, maxLines: 3),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboardType, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: maxLines > 1 ? 40 : 0),
          child: Icon(icon, color: AppColors.primary),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) {
        if (maxLines == 1 && v!.trim().isEmpty) return 'This field is required';
        return null;
      },
    );
  }

  Widget _buildCouponSection(double subtotal) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Have a Coupon?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _couponController,
                  decoration: InputDecoration(
                    hintText: 'Enter coupon code (WELCOME20, WEEKEND15)',
                    errorText: _couponError,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  final code = _couponController.text.trim().toUpperCase();
                  setState(() {
                    if (code == 'WELCOME20') {
                      _discountAmount = subtotal * 0.20;
                      _appliedCoupon = code;
                      _couponError = null;
                    } else if (code == 'WEEKEND15') {
                      _discountAmount = subtotal * 0.15;
                      _appliedCoupon = code;
                      _couponError = null;
                    } else if (code.isEmpty) {
                      _discountAmount = 0.0;
                      _appliedCoupon = null;
                      _couponError = 'Please enter a coupon code';
                    } else {
                      _discountAmount = 0.0;
                      _appliedCoupon = null;
                      _couponError = 'Invalid coupon code';
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Apply'),
              ),
            ],
          ),
          if (_appliedCoupon != null) ...[
            const SizedBox(height: 8),
            Text(
              'Coupon "$_appliedCoupon" applied successfully!',
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceSummary(double subtotal, double taxes, double serviceFee, double total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildPriceRow('Room Charge', subtotal),
          const SizedBox(height: 12),
          _buildPriceRow('Taxes (12%)', taxes),
          const SizedBox(height: 12),
          _buildPriceRow('Service Fee', serviceFee),
          if (_discountAmount > 0) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Discount', style: TextStyle(color: Colors.green, fontSize: 14)),
                Text('-₹${_discountAmount.toInt()}', style: const TextStyle(color: Colors.green, fontSize: 14)),
              ],
            ),
          ],
          const Divider(height: 32),
          _buildPriceRow('Total Amount', total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 18 : 14)),
        Text('₹${amount.toInt()}', style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 18 : 14, color: isTotal ? AppColors.primary : null)),
      ],
    );
  }

  void _processBooking(double amount) async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    final authService = sl<AuthService>();
    if (authService.currentUser == null) {
      Navigator.pushNamed(context, AppRouter.login);
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppColors.primary),
                const SizedBox(height: 24),
                Text('Processing Payment...', style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Please do not close the app', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );

    final paymentService = sl<PaymentService>();
    final result = await paymentService.processPayment(
      amount: amount,
      currency: 'INR',
      orderId: 'ORD_${DateTime.now().millisecondsSinceEpoch}',
    );

    if (!mounted) return;

    if (result.success) {
      try {
        final bookingRepo = sl<BookingRepository>();
        final booking = BookingModel(
          id: '',
          hotelId: widget.hotel.id,
          roomId: widget.room.id,
          userId: authService.currentUser!.uid,
          checkIn: checkIn,
          checkOut: checkOut,
          guests: guests,
          totalAmount: amount,
          status: 'CONFIRMED',
          transactionId: result.transactionId ?? 'LUX123456',
          createdAt: DateTime.now(),
        );
        final bookingId = await bookingRepo.createBooking(booking);

        // Add notification
        sl<NotificationService>().addNotification(
          'Booking Confirmed!',
          'Your stay at ${widget.hotel.name} has been confirmed. Enjoy your trip!',
        );

        if (!mounted) return;
        Navigator.pop(context); // Close loading
        _showSuccessScreen(result.transactionId ?? bookingId, amount);
      } catch (e) {
        if (!mounted) return;
        Navigator.pop(context); // Close loading
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking failed to save: $e')));
      }
    } else {
      Navigator.pop(context); // Close loading
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.errorMessage ?? 'Payment failed')));
    }
  }

  void _showSuccessScreen(String transactionId, double finalAmount) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 100, color: AppColors.success),
            const SizedBox(height: 24),
            Text('Booking Confirmed!', style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Your stay at ${widget.hotel.name} is all set.', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  _buildSuccessRow('Booking ID', transactionId),
                  const Divider(),
                  _buildSuccessRow('Hotel', widget.hotel.name),
                  _buildSuccessRow('Room', widget.room.name),
                  _buildSuccessRow('Guests', '$guests'),
                  _buildSuccessRow('Check-in', DateFormat('dd MMM yyyy').format(checkIn)),
                  _buildSuccessRow('Check-out', DateFormat('dd MMM yyyy').format(checkOut)),
                  _buildSuccessRow('Total Amount', '₹${finalAmount.toInt()}'),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRouter.mainTabs, (route) => false),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
