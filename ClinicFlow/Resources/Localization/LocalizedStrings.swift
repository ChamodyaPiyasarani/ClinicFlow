import Foundation

/// Central dictionary for all localized strings across the app.
/// Add new keys here as you build more screens.
struct LocalizedStrings {

    // MARK: - String Tables
    private static let strings: [String: [AppLanguage: String]] = [

        // ── Language Selection Screen ──
        "welcome": [
            .english: "Welcome",
            .sinhala: "ආයුබෝවන්",
            .tamil: "வணக்கம்"
        ],
        "select_language": [
            .english: "Select your preferred language",
            .sinhala: "ඔබේ භාෂාව තෝරන්න",
            .tamil: "உங்கள் மொழியைத் தேர்ந்தெடுக்கவும்"
        ],
        "continue": [
            .english: "Continue",
            .sinhala: "ඉදිරියට",
            .tamil: "தொடரவும்"
        ],

        // ── Common / Navigation ──
        "back": [
            .english: "Back",
            .sinhala: "ආපසු",
            .tamil: "பின்செல்"
        ],
        "next": [
            .english: "Next",
            .sinhala: "ඊළඟ",
            .tamil: "அடுத்து"
        ],
        "cancel": [
            .english: "Cancel",
            .sinhala: "අවලංගු",
            .tamil: "ரத்து"
        ],
        "ok": [
            .english: "OK",
            .sinhala: "හරි",
            .tamil: "சரி"
        ],
        "done": [
            .english: "Done",
            .sinhala: "සම්පූර්ණයි",
            .tamil: "முடிந்தது"
        ],
        "save": [
            .english: "Save",
            .sinhala: "සුරකින්න",
            .tamil: "சேமி"
        ],
        "delete": [
            .english: "Delete",
            .sinhala: "මකන්න",
            .tamil: "நீக்கு"
        ],
        "edit": [
            .english: "Edit",
            .sinhala: "සංස්කරණය",
            .tamil: "திருத்து"
        ],
        "search": [
            .english: "Search",
            .sinhala: "සොයන්න",
            .tamil: "தேடு"
        ],
        "settings": [
            .english: "Settings",
            .sinhala: "සැකසුම්",
            .tamil: "அமைப்புகள்"
        ],
        "profile": [
            .english: "Profile",
            .sinhala: "පැතිකඩ",
            .tamil: "சுயவிவரம்"
        ],
        "home": [
            .english: "Home",
            .sinhala: "මුල් පිටුව",
            .tamil: "முகப்பு"
        ],
        "logout": [
            .english: "Logout",
            .sinhala: "පිටවීම",
            .tamil: "வெளியேறு"
        ],
        "login": [
            .english: "Login",
            .sinhala: "පිවිසීම",
            .tamil: "உள்நுழை"
        ],
        "register": [
            .english: "Register",
            .sinhala: "ලියාපදිංචි වන්න",
            .tamil: "பதிவு"
        ],

        // ── User SignUp Screen ──
        "user_signup": [
            .english: "User SignUp",
            .sinhala: "පරිශීලක ලියාපදිංචිය",
            .tamil: "பயனர் பதிவு"
        ],
        "user_name": [
            .english: "User Name",
            .sinhala: "පරිශීලක නාමය",
            .tamil: "பயனர் பெயர்"
        ],
        "contact_number": [
            .english: "Contact Number",
            .sinhala: "දුරකථන අංකය",
            .tamil: "தொடர்பு எண்"
        ],
        "agree_to": [
            .english: "Agree to ",
            .sinhala: "එකඟ වන්න ",
            .tamil: "ஒப்புக்கொள் "
        ],
        "terms_and_conditions": [
            .english: "terms and conditions",
            .sinhala: "නියම සහ කොන්දේසි",
            .tamil: "விதிமுறைகள் மற்றும் நிபந்தனைகள்"
        ],
        "send_otp": [
            .english: "Send OTP",
            .sinhala: "OTP යවන්න",
            .tamil: "OTP அனுப்பு"
        ],

        // ── Terms & Conditions Screen ──
        "terms_section_1_title": [
            .english: "1. Acceptance of Terms",
            .sinhala: "1. නියම පිළිගැනීම",
            .tamil: "1. விதிமுறைகளை ஏற்றுக்கொள்ளுதல்"
        ],
        "terms_section_1_p1": [
            .english: "By downloading, installing, or using the Clinic Flow application, you agree to be bound by these Terms and Conditions.",
            .sinhala: "Clinic Flow යෙදුම බාගත කිරීම, ස්ථාපනය කිරීම හෝ භාවිතා කිරීම මගින්, ඔබ මෙම නියම සහ කොන්දේසි වලට එකඟ වේ.",
            .tamil: "Clinic Flow பயன்பாட்டைப் பதிவிறக்கம் செய்தல், நிறுவுதல் அல்லது பயன்படுத்துவதன் மூலம், இந்த விதிமுறைகள் மற்றும் நிபந்தனைகளுக்கு நீங்கள் ஒப்புக்கொள்கிறீர்கள்."
        ],
        "terms_section_1_p2": [
            .english: "If you do not agree to these terms, please do not use our application.",
            .sinhala: "ඔබ මෙම නියමවලට එකඟ නොවන්නේ නම්, කරුණාකර අපගේ යෙදුම භාවිතා නොකරන්න.",
            .tamil: "இந்த விதிமுறைகளுக்கு நீங்கள் ஒப்புக்கொள்ளவில்லை என்றால், எங்கள் பயன்பாட்டைப் பயன்படுத்த வேண்டாம்."
        ],
        "terms_section_2_title": [
            .english: "2. Medical Information Disclaimer",
            .sinhala: "2. වෛද්‍ය තොරතුරු වියාචනය",
            .tamil: "2. மருத்துவ தகவல் மறுப்பு"
        ],
        "terms_section_2_p1": [
            .english: "Clinic Flow is designed to assist with clinic navigation and appointment management. It is not intended to provide medical advice, diagnosis, or treatment.",
            .sinhala: "Clinic Flow සායන මාර්ගෝපදේශ සහ හමුවීම් කළමනාකරණයට සහාය වීම සඳහා නිර්මාණය කර ඇත. එය වෛද්‍ය උපදේශ, රෝග විනිශ්චය හෝ ප්‍රතිකාර සැපයීමට අදහස් නොකරයි.",
            .tamil: "Clinic Flow மருத்துவமனை வழிசெலுத்தல் மற்றும் சந்திப்பு மேலாண்மைக்கு உதவ வடிவமைக்கப்பட்டுள்ளது. இது மருத்துவ ஆலோசனை, நோயறிதல் அல்லது சிகிச்சை வழங்குவதற்கு அல்ல."
        ],
        "terms_section_2_p2": [
            .english: "Always consult with qualified healthcare professionals for medical decisions.",
            .sinhala: "වෛද්‍ය තීරණ සඳහා සෑම විටම සුදුසුකම් ලත් සෞඛ්‍ය වෘත්තිකයින්ගෙන් උපදෙස් ලබා ගන්න.",
            .tamil: "மருத்துவ முடிவுகளுக்கு எப்போதும் தகுதிவாய்ந்த சுகாதார நிபுணர்களை அணுகவும்."
        ],
        "terms_section_3_title": [
            .english: "3. Data Privacy & Security",
            .sinhala: "3. දත්ත රහස්‍යතාව සහ ආරක්ෂාව",
            .tamil: "3. தரவு தனியுரிமை & பாதுகாப்பு"
        ],
        "terms_section_3_p1": [
            .english: "We collect and process your personal information in accordance with our Privacy Policy. Your health information is encrypted and stored securely.",
            .sinhala: "අපි ඔබගේ පුද්ගලික තොරතුරු අපගේ රහස්‍යතා ප්‍රතිපත්තියට අනුව එකතු කර සකසන්නෙමු. ඔබගේ සෞඛ්‍ය තොරතුරු සංකේතනය කර ආරක්ෂිතව ගබඩා කර ඇත.",
            .tamil: "எங்கள் தனியுரிமைக் கொள்கையின்படி உங்கள் தனிப்பட்ட தகவல்களை நாங்கள் சேகரித்து செயலாக்குகிறோம். உங்கள் சுகாதாரத் தகவல் குறியாக்கம் செய்யப்பட்டு பாதுகாப்பாக சேமிக்கப்படுகிறது."
        ],
        "terms_section_3_p2": [
            .english: "We do not share your personal health information with third parties without your explicit consent.",
            .sinhala: "ඔබගේ පැහැදිලි එකඟතාවයකින් තොරව ඔබගේ පුද්ගලික සෞඛ්‍ය තොරතුරු තෙවන පාර්ශ්වයන් සමඟ බෙදා නොගනී.",
            .tamil: "உங்கள் வெளிப்படையான சம்மதமின்றி உங்கள் தனிப்பட்ட சுகாதாரத் தகவலை மூன்றாம் தரப்பினருடன் நாங்கள் பகிர்வதில்லை."
        ],
        "terms_section_4_title": [
            .english: "4. User Responsibilities",
            .sinhala: "4. පරිශීලක වගකීම්",
            .tamil: "4. பயனர் பொறுப்புகள்"
        ],
        "terms_section_4_b1": [
            .english: "Provide accurate and up-to-date information",
            .sinhala: "නිවැරදි සහ යාවත්කාලීන තොරතුරු සපයන්න",
            .tamil: "துல்லியமான மற்றும் புதுப்பித்த தகவல்களை வழங்கவும்"
        ],
        "terms_section_4_b2": [
            .english: "Maintain the confidentiality of your account credentials",
            .sinhala: "ඔබගේ ගිණුම් අක්තපත්‍රවල රහස්‍යභාවය පවත්වා ගන්න",
            .tamil: "உங்கள் கணக்கு சான்றுகளின் ரகசியத்தன்மையைப் பராமரிக்கவும்"
        ],
        "terms_section_4_b3": [
            .english: "Use the application only for its intended purpose",
            .sinhala: "යෙදුම එහි අපේක්ෂිත අරමුණ සඳහා පමණක් භාවිතා කරන්න",
            .tamil: "பயன்பாட்டை அதன் நோக்கத்திற்காக மட்டும் பயன்படுத்தவும்"
        ],
        "terms_section_5_title": [
            .english: "5. Appointment Management",
            .sinhala: "5. හමුවීම් කළමනාකරණය",
            .tamil: "5. சந்திப்பு மேலாண்மை"
        ],
        "terms_section_5_p1": [
            .english: "While we strive to provide accurate wait times and appointment information, actual clinic conditions may vary.",
            .sinhala: "නිවැරදි රැඳී සිටීමේ කාලයන් සහ හමුවීම් තොරතුරු සැපයීමට අපි උත්සාහ කළත්, සැබෑ සායන තත්ත්වයන් වෙනස් විය හැකිය.",
            .tamil: "துல்லியமான காத்திருப்பு நேரங்கள் மற்றும் சந்திப்புத் தகவல்களை வழங்க நாங்கள் முயற்சிக்கிறோம் என்றாலும், உண்மையான மருத்துவமனை நிலைமைகள் மாறுபடலாம்."
        ],
        "terms_section_5_p2": [
            .english: "Please arrive at your scheduled appointment time and check with clinic staff for the most current information.",
            .sinhala: "කරුණාකර ඔබගේ නියමිත හමුවීම් වේලාවට පැමිණ වඩාත් යාවත්කාලීන තොරතුරු සඳහා සායන කාර්ය මණ්ඩලය සමඟ පරීක්ෂා කරන්න.",
            .tamil: "உங்கள் திட்டமிடப்பட்ட சந்திப்பு நேரத்தில் வந்து, மிகச் சமீபத்திய தகவலுக்கு மருத்துவமனை ஊழியர்களிடம் சரிபார்க்கவும்."
        ],
        "terms_section_6_title": [
            .english: "6. Updates & Changes",
            .sinhala: "6. යාවත්කාලීන සහ වෙනස්කම්",
            .tamil: "6. புதுப்பிப்புகள் & மாற்றங்கள்"
        ],
        "terms_section_6_p1": [
            .english: "We may update these terms from time to time. You will be notified of any significant changes through the application.",
            .sinhala: "අපි වරින් වර මෙම නියම යාවත්කාලීන කළ හැකිය. යෙදුම හරහා ඕනෑම සැලකිය යුතු වෙනස්කම් ගැන ඔබට දැනුම් දෙනු ලැබේ.",
            .tamil: "இந்த விதிமுறைகளை நாங்கள் அவ்வப்போது புதுப்பிக்கலாம். பயன்பாடு வழியாக ஏதேனும் குறிப்பிடத்தக்க மாற்றங்கள் உங்களுக்கு அறிவிக்கப்படும்."
        ],
        "terms_section_6_p2": [
            .english: "Continued use of the application after changes constitutes acceptance of the updated terms.",
            .sinhala: "වෙනස්කම් වලින් පසු යෙදුම අඛණ්ඩව භාවිතා කිරීම යාවත්කාලීන නියම පිළිගැනීමක් ලෙස සැලකේ.",
            .tamil: "மாற்றங்களுக்குப் பிறகு பயன்பாட்டைத் தொடர்ந்து பயன்படுத்துவது புதுப்பிக்கப்பட்ட விதிமுறைகளை ஏற்றுக்கொள்வதாகும்."
        ],

        // ── OTP Verification Screen ──
        "otp_verification": [
            .english: "OTP Verification",
            .sinhala: "OTP සත්‍යාපනය",
            .tamil: "OTP சரிபார்ப்பு"
        ],
        "otp_subtitle": [
            .english: "Enter the 4-digit code sent to your phone",
            .sinhala: "ඔබගේ දුරකථනයට යැවූ අංක 4න් කේතය ඇතුළු කරන්න",
            .tamil: "உங்கள் தொலைப்பேசிக்கு அனுப்பப்பட்ட 4 இலக்க குறியீட்டை உள்ளிடவும்"
        ],
        "verify_otp": [
            .english: "Verify OTP",
            .sinhala: "OTP සත්‍යාපනය කරන්න",
            .tamil: "OTP சரிபார்க்கவும்"
        ],
        "didnt_receive_code": [
            .english: "Didn't receive the code?",
            .sinhala: "කේතය ලැබුණේ නැද්ද?",
            .tamil: "குறியீடு கிடைக்கவில்லையா?"
        ],
        "resend": [
            .english: "Resend",
            .sinhala: "නැවත යවන්න",
            .tamil: "மீண்டும் அனுப்பு"
        ],

        // ── Home Screen ──
        "current_visit_status": [
            .english: "Current visit status",
            .sinhala: "වත්මන් පැමිණීමේ තත්ත්වය",
            .tamil: "தற்போதைய வருகை நிலை"
        ],
        "your_visit_status": [
            .english: "Your Visit Status",
            .sinhala: "ඔබේ පැමිණීමේ තත්ත්වය",
            .tamil: "உங்கள் வருகை நிலை"
        ],
        "no_active_visit": [
            .english: "No Active Visit",
            .sinhala: "සක්‍රිය පැමිණීමක් නැත",
            .tamil: "செயலில் வருகை இல்லை"
        ],
        "no_active_visit_desc": [
            .english: "You don't have any scheduled appointments today. Start a walk-in visit or book an appointment.",
            .sinhala: "ඔබට අද නියමිත හමුවීම් නොමැත. ඇවිත් යාමේ පැමිණීමක් ආරම්භ කරන්න හෝ හමුවීමක් වෙන් කරන්න.",
            .tamil: "இன்று உங்களுக்கு திட்டமிடப்பட்ட சந்திப்புகள் எதுவும் இல்லை. நேரடி வருகையைத் தொடங்கவும் அல்லது சந்திப்பை முன்பதிவு செய்யவும்."
        ],
        "start_walk_in_visit": [
            .english: "Start Walk In Visit",
            .sinhala: "ඇවිත් යාමේ පැමිණීම ආරම්භ කරන්න",
            .tamil: "நேரடி வருகையைத் தொடங்கு"
        ],
        "or": [
            .english: "OR",
            .sinhala: "හෝ",
            .tamil: "அல்லது"
        ],
        "add_an_appointment": [
            .english: "Add an Appointment",
            .sinhala: "හමුවීමක් එක් කරන්න",
            .tamil: "சந்திப்பைச் சேர்க்கவும்"
        ],
        "clinic_service_list": [
            .english: "Clinic Service List",
            .sinhala: "සායන සේවා ලැයිස්තුව",
            .tamil: "மருத்துவமனை சேவை பட்டியல்"
        ],
        "service_opd": [
            .english: "OPD",
            .sinhala: "OPD",
            .tamil: "OPD"
        ],
        "service_opd_desc": [
            .english: "Outpatient Department",
            .sinhala: "බාහිර රෝගී අංශය",
            .tamil: "வெளிநோயாளர் பிரிவு"
        ],
        "service_lab": [
            .english: "LAB Tests",
            .sinhala: "රසායනාගාර පරීක්ෂණ",
            .tamil: "ஆய்வக பரிசோதனைகள்"
        ],
        "service_lab_desc": [
            .english: "Lab test details",
            .sinhala: "රසායනාගාර පරීක්ෂණ විස්තර",
            .tamil: "ஆய்வக பரிசோதனை விவரங்கள்"
        ],
        "service_pharmacy": [
            .english: "Pharmacy",
            .sinhala: "ඖෂධාගාරය",
            .tamil: "மருந்தகம்"
        ],
        "service_pharmacy_desc": [
            .english: "Upload prescription",
            .sinhala: "බෙහෙත් වට්ටෝරුව උඩුගත කරන්න",
            .tamil: "மருந்து சீட்டை பதிவேற்றவும்"
        ],

        // ── Bottom Navigation Bar ──
        "tab_home": [
            .english: "Home",
            .sinhala: "මුල් පිටුව",
            .tamil: "முகப்பு"
        ],
        "tab_map": [
            .english: "Map",
            .sinhala: "සිතියම",
            .tamil: "வரைபடம்"
        ],
        "tab_appointment": [
            .english: "Appointment",
            .sinhala: "හමුවීම",
            .tamil: "சந்திப்பு"
        ],
        "tab_account": [
            .english: "Account",
            .sinhala: "ගිණුම",
            .tamil: "கணக்கு"
        ],
        
        // ── Location Permission Screen ──
        "activate_your_visit": [
            .english: "Activate Your Visit",
            .sinhala: "ඔබගේ සංචාරය සක්‍රිය කරන්න",
            .tamil: "உங்கள் வருகையை செயல்படுத்தவும்"
        ],
        "location_permission_subtitle": [
            .english: "Enable location to confirm that you\nare at the clinic and activate your session\nsecurely.",
            .sinhala: "ඔබ සායනයේ සිටින බව තහවුරු කිරීමට සහ ඔබගේ සැසිය ආරක්ෂිතව සක්‍රිය කිරීමට ස්ථානය සක්‍රිය කරන්න.",
            .tamil: "நீங்கள் மருத்துவமனையில் இருப்பதை உறுதிப்படுத்தவும், உங்கள் அமர்வை பாதுகாப்பாக செயல்படுத்தவும் இருப்பிடத்தை இயக்கவும்."
        ],
        "secure_session_activation": [
            .english: "Secure Session Activation",
            .sinhala: "ආරක්ෂිත සැසි සක්‍රියකරණය",
            .tamil: "பாதுகாப்பான அமர்வு செயல்படுத்தல்"
        ],
        "verify_presence_subtitle": [
            .english: "Verify your presence before joining the queue",
            .sinhala: "පෝලිමට එක්වීමට පෙර ඔබගේ පැමිණීම සත්‍යාපනය කරන්න",
            .tamil: "வரிசையில் சேர்வதற்கு முன் உங்கள் இருப்பை சரிபார்க்கவும்"
        ],
        "fair_token_allocation": [
            .english: "Fair Token Allocation",
            .sinhala: "සාධාරණ ටෝකන් වෙන් කිරීම",
            .tamil: "நியாயமான டோக்கன் ஒதுக்கீடு"
        ],
        "prevents_duplicate_checkins": [
            .english: "Prevents remote or duplicate check-ins",
            .sinhala: "දුරස්ථ හෝ අනාවර්තන පිවිසුම් වළක්වයි",
            .tamil: "தொலைநிலை அல்லது நகல் செக்-இன்களை தடுக்கிறது"
        ],
        "enable_location_services": [
            .english: "Enable Location Services",
            .sinhala: "ස්ථාන සේවා සක්‍රිය කරන්න",
            .tamil: "இருப்பிட சேவைகளை இயக்கவும்"
        ],
        "skip_for_now": [
            .english: "Skip for Now",
            .sinhala: "දැනට මඟහරින්න",
            .tamil: "இப்போதைக்கு தவிர்க்கவும்"
        ],

        // ── Notification Permission Screen ──
        "stay_updated": [
            .english: "Stay Updated",
            .sinhala: "යාවත්කාලීනව සිටින්න",
            .tamil: "புதுப்பித்த நிலையில் இருங்கள்"
        ],
        "notification_permission_subtitle": [
            .english: "Get real-time notifications about your\nappointments, queue status, and important clinic\nupdates",
            .sinhala: "ඔබගේ හමුවීම්, පෝලිම තත්ත්වය සහ වැදගත් සායන යාවත්කාලීන ගැන තත්‍ය කාලීන දැනුම්දීම් ලබා ගන්න",
            .tamil: "உங்கள் சந்திப்புகள், வரிசை நிலை மற்றும் முக்கியமான மருத்துவமனை புதுப்பிப்புகள் பற்றிய நேரடி அறிவிப்புகளைப் பெறுங்கள்"
        ],
        "appointment_reminders": [
            .english: "Appointment Reminders",
            .sinhala: "හමුවීම් සිහිකැඳවීම්",
            .tamil: "சந்திப்பு நினைவூட்டல்கள்"
        ],
        "never_miss_appointments": [
            .english: "Never miss your scheduled appointments",
            .sinhala: "ඔබගේ සැලසුම් කළ හමුවීම් කිසි විටෙකත් මග නොහරින්න",
            .tamil: "உங்கள் திட்டமிடப்பட்ட சந்திப்புகளை தவறவிடாதீர்கள்"
        ],
        "queue_updates": [
            .english: "Queue Updates",
            .sinhala: "පෝලිම යාවත්කාලීන",
            .tamil: "வரிசை புதுப்பிப்புகள்"
        ],
        "realtime_turn_notification": [
            .english: "Know when it's your turn in real-time",
            .sinhala: "ඔබගේ වාරය කවදාදැයි තත්‍ය කාලීනව දැනගන්න",
            .tamil: "உங்கள் முறை எப்போது என்பதை நேரடியாக அறியவும்"
        ],
        "important_alerts": [
            .english: "Important Alerts",
            .sinhala: "වැදගත් ඇඟවීම්",
            .tamil: "முக்கிய எச்சரிக்கைகள்"
        ],
        "urgent_announcements": [
            .english: "Receive urgent clinic announcements",
            .sinhala: "හදිසි සායන නිවේදන ලබා ගන්න",
            .tamil: "அவசர மருத்துவமனை அறிவிப்புகளைப் பெறவும்"
        ],
        "enable_notification": [
            .english: "Enable Notification",
            .sinhala: "දැනුම්දීම් සක්‍රිය කරන්න",
            .tamil: "அறிவிப்பை இயக்கவும்"
        ],

        // ── Help & Support / FAQ Screen ──
        "faq_title": [
            .english: "Frequently Asked Questions",
            .sinhala: "නිතර අසන ප්‍රශ්න",
            .tamil: "அடிக்கடி கேட்கப்படும் கேள்விகள்"
        ],
        "faq_q1": [
            .english: "How do I check my queue position?",
            .sinhala: "මගේ පෝලිම් ස්ථානය පරීක්ෂා කරන්නේ කෙසේද?",
            .tamil: "எனது வரிசை நிலையை எவ்வாறு சரிபார்ப்பது?"
        ],
        "faq_a1": [
            .english: "You can check your queue position from the Home screen. Your current token number and estimated wait time will be displayed on the visit status card.",
            .sinhala: "ඔබට මුල් පිටුවෙන් ඔබේ පෝලිම් ස්ථානය පරීක්ෂා කළ හැකිය. ඔබේ වත්මන් ටෝකන අංකය සහ ඇස්තමේන්තුගත පොරොත්තු කාලය සංචාර තත්ත්ව කාඩ්පතේ පෙන්වනු ඇත.",
            .tamil: "முகப்புத் திரையிலிருந்து உங்கள் வரிசை நிலையைச் சரிபார்க்கலாம். உங்கள் தற்போதைய டோக்கன் எண் மற்றும் மதிப்பிடப்பட்ட காத்திருப்பு நேரம் வருகை நிலை அட்டையில் காண்பிக்கப்படும்."
        ],
        "faq_q2": [
            .english: "How do I book an appointment?",
            .sinhala: "මම හමුවීමක් වෙන්කරවා ගන්නේ කෙසේද?",
            .tamil: "நான் எவ்வாறு சந்திப்பை முன்பதிவு செய்வது?"
        ],
        "faq_a2": [
            .english: "Tap 'Add an Appointment' on the Home screen or go to the Appointment tab. Select the clinic, choose a date and time, and confirm your booking.",
            .sinhala: "මුල් පිටුවේ 'හමුවීමක් එක් කරන්න' තට්ටු කරන්න හෝ හමුවීම් ටැබ් එකට යන්න. සායනය තෝරන්න, දිනයක් සහ වේලාවක් තෝරන්න, ඔබේ වෙන්කිරීම තහවුරු කරන්න.",
            .tamil: "முகப்புத் திரையில் 'சந்திப்பைச் சேர்க்கவும்' என்பதைத் தட்டவும் அல்லது சந்திப்பு தாவலுக்குச் செல்லவும். மருத்துவமனையைத் தேர்ந்தெடுத்து, தேதி மற்றும் நேரத்தைத் தேர்வுசெய்து, உங்கள் முன்பதிவை உறுதிப்படுத்தவும்."
        ],
        "faq_q3": [
            .english: "How does indoor navigation work?",
            .sinhala: "ගෘහස්ථ නැවිගේෂන් ක්‍රියා කරන්නේ කෙසේද?",
            .tamil: "உள்ளக வழிசெலுத்தல் எவ்வாறு செயல்படுகிறது?"
        ],
        "faq_a3": [
            .english: "Use the Map tab to navigate within the clinic. The app uses Bluetooth beacons and floor maps to guide you to consultation rooms, labs, and the pharmacy.",
            .sinhala: "සායනය තුළ සැරිසැරීමට සිතියම් ටැබ් එක භාවිතා කරන්න. උපදේශන කාමර, රසායනාගාර සහ ඖෂධාගාරයට ඔබව මඟ පෙන්වීමට යෙදුම බ්ලූටූත් බීකන් සහ මහල් සිතියම් භාවිතා කරයි.",
            .tamil: "மருத்துவமனைக்குள் வழிசெலுத்த வரைபடம் தாவலைப் பயன்படுத்தவும். ஆலோசனை அறைகள், ஆய்வகங்கள் மற்றும் மருந்தகத்திற்கு உங்களை வழிநடத்த பயன்பாடு புளூடூத் பீக்கான்கள் மற்றும் தள வரைபடங்களைப் பயன்படுத்துகிறது."
        ],
        "faq_q4": [
            .english: "Can I reschedule my appointment?",
            .sinhala: "මට මගේ හමුවීම නැවත සැලසුම් කළ හැකිද?",
            .tamil: "எனது சந்திப்பை மாற்றியமைக்க முடியுமா?"
        ],
        "faq_a4": [
            .english: "Yes, go to the Appointment tab, select your upcoming appointment, and tap 'Reschedule'. You can pick a new date and time based on available slots.",
            .sinhala: "ඔව්, හමුවීම් ටැබ් එකට ගොස්, ඔබේ ඉදිරි හමුවීම තෝරන්න, 'නැවත සැලසුම් කරන්න' තට්ටු කරන්න. පවතින කාල පරාසයන් මත පදනම්ව නව දිනයක් සහ වේලාවක් තෝරන්න.",
            .tamil: "ஆம், சந்திப்பு தாவலுக்குச் சென்று, உங்கள் வரவிருக்கும் சந்திப்பைத் தேர்ந்தெடுத்து, 'மாற்றியமை' என்பதைத் தட்டவும். கிடைக்கும் நேர இடைவெளிகளின் அடிப்படையில் புதிய தேதி மற்றும் நேரத்தைத் தேர்வுசெய்யலாம்."
        ],
        "contact_support": [
            .english: "Contact Support",
            .sinhala: "සහාය අමතන්න",
            .tamil: "ஆதரவைத் தொடர்புகொள்ளவும்"
        ],
        "phone_support": [
            .english: "Phone Support",
            .sinhala: "දුරකථන සහාය",
            .tamil: "தொலைபேசி ஆதரவு"
        ],
        "phone_support_number": [
            .english: "+1 (555) 123-4567",
            .sinhala: "+1 (555) 123-4567",
            .tamil: "+1 (555) 123-4567"
        ],
        "email_support": [
            .english: "Email Support",
            .sinhala: "ඊමේල් සහාය",
            .tamil: "மின்னஞ்சல் ஆதரவு"
        ],
        "email_support_address": [
            .english: "support@clinicflow.lk",
            .sinhala: "support@clinicflow.lk",
            .tamil: "support@clinicflow.lk"
        ],
        "live_chat": [
            .english: "Live Chat",
            .sinhala: "සජීවී කතාබස",
            .tamil: "நேரடி அரட்டை"
        ],
        "live_chat_subtitle": [
            .english: "Chat with our team",
            .sinhala: "අපගේ කණ්ඩායම සමඟ කතාබස් කරන්න",
            .tamil: "எங்கள் குழுவுடன் அரட்டையடிக்கவும்"
        ],
        "support_hours": [
            .english: "Support available 8:00 AM – 6:00 PM",
            .sinhala: "සහාය පෙ.ව. 8:00 – ප.ව. 6:00 දක්වා ලබා ගත හැකිය",
            .tamil: "ஆதரவு காலை 8:00 – மாலை 6:00 வரை கிடைக்கும்"
        ],

        // ── Account Screen ──
        "patient_profiles": [
            .english: "Patient Profiles",
            .sinhala: "රෝගී පැතිකඩ",
            .tamil: "நோயாளி சுயவிவரங்கள்"
        ],
        "visit_history": [
            .english: "Visit History",
            .sinhala: "පැමිණීම් ඉතිහාසය",
            .tamil: "வருகை வரலாறு"
        ],
        "help_support": [
            .english: "Help & Support",
            .sinhala: "උදව් සහ සහාය",
            .tamil: "உதவி & ஆதரவு"
        ],
        "logout_title": [
            .english: "Logout",
            .sinhala: "පිටවීම",
            .tamil: "வெளியேறு"
        ],
        "logout_confirmation": [
            .english: "Are you sure you want to logout?",
            .sinhala: "ඔබට පිටවීමට අවශ්‍ය බව විශ්වාසද?",
            .tamil: "நீங்கள் வெளியேற விரும்புகிறீர்களா?"
        ],

        // ── Notifications Screen ──
        "clear_all": [
            .english: "Clear All",
            .sinhala: "සියල්ල මකන්න",
            .tamil: "அனைத்தையும் அழி"
        ],
        "notifications": [
            .english: "Notifications",
            .sinhala: "දැනුම්දීම්",
            .tamil: "அறிவிப்புகள்"
        ],
        "no_notifications": [
            .english: "No Notifications",
            .sinhala: "දැනුම්දීම් නැත",
            .tamil: "அறிவிப்புகள் இல்லை"
        ],
        "all_caught_up": [
            .english: "You're all caught up!",
            .sinhala: "ඔබ සියල්ල දැනගෙන ඇත!",
            .tamil: "நீங்கள் அனைத்தையும் படித்துவிட்டீர்கள்!"
        ],

        // ── Pharmacy Screen ──
        "pharmacy_title": [
            .english: "Pharmacy",
            .sinhala: "ඖෂධාගාරය",
            .tamil: "மருந்தகம்"
        ],
        "upload_prescription": [
            .english: "Upload Prescription Image",
            .sinhala: "බෙහෙත් වට්ටෝරුව උඩුගත කරන්න",
            .tamil: "மருந்து சீட்டு படத்தை பதிவேற்றவும்"
        ],
        "jpg_png_supported": [
            .english: "JPG or PNG supported",
            .sinhala: "JPG හෝ PNG සහාය දක්වයි",
            .tamil: "JPG அல்லது PNG ஆதரிக்கப்படுகிறது"
        ],
        "choose_from_gallery": [
            .english: "Choose from Gallery",
            .sinhala: "ගැලරියෙන් තෝරන්න",
            .tamil: "கேலரியிலிருந்து தேர்வுசெய்யவும்"
        ],
        "take_photo": [
            .english: "Take Photo",
            .sinhala: "ඡායාරූපයක් ගන්න",
            .tamil: "புகைப்படம் எடுக்கவும்"
        ],
        "important": [
            .english: "Important",
            .sinhala: "වැදගත්",
            .tamil: "முக்கியமானது"
        ],
        "prescription_info": [
            .english: "Make sure your prescription is clearly visible and all text is readable before uploading.",
            .sinhala: "උඩුගත කිරීමට පෙර ඔබේ බෙහෙත් වට්ටෝරුව පැහැදිලිව පෙනෙන බවත් සියලු අකුරු කියවිය හැකි බවත් සහතික කරන්න.",
            .tamil: "பதிவேற்றும் முன் உங்கள் மருந்து சீட்டு தெளிவாகத் தெரியும் என்பதையும் அனைத்து எழுத்துகளும் படிக்கக்கூடியவை என்பதையும் உறுதிப்படுத்தவும்."
        ],
        "send_to_pharmacy": [
            .english: "Send to Pharmacy",
            .sinhala: "ඖෂධාගාරයට යවන්න",
            .tamil: "மருந்தகத்திற்கு அனுப்பவும்"
        ],

        // ── OPD Departments Screen ──
        "opd_departments": [
            .english: "OPD Departments",
            .sinhala: "බාහිර රෝගී අංශ",
            .tamil: "வெளிநோயாளர் பிரிவுகள்"
        ],
        "search_departments": [
            .english: "Search departments...",
            .sinhala: "අංශ සොයන්න...",
            .tamil: "பிரிவுகளைத் தேடு..."
        ],
        "available_departments": [
            .english: "Available Departments",
            .sinhala: "පවතින අංශ",
            .tamil: "கிடைக்கும் பிரிவுகள்"
        ],
        "department_count_single": [
            .english: "1 department available",
            .sinhala: "අංශ 1ක් පවතී",
            .tamil: "1 பிரிவு கிடைக்கிறது"
        ],
        "sort": [
            .english: "Sort",
            .sinhala: "පෙළගැස්වීම",
            .tamil: "வரிசைப்படுத்து"
        ],

        // ── Lab Tests Screen ──
        "lab_tests": [
            .english: "Lab Tests",
            .sinhala: "රසායනාගාර පරීක්ෂණ",
            .tamil: "ஆய்வக பரிசோதனைகள்"
        ],
        "search_lab_tests": [
            .english: "Search lab tests...",
            .sinhala: "රසායනාගාර පරීක්ෂණ සොයන්න...",
            .tamil: "ஆய்வக பரிசோதனைகளைத் தேடு..."
        ],
        "available_tests": [
            .english: "Available Tests",
            .sinhala: "පවතින පරීක්ෂණ",
            .tamil: "கிடைக்கும் பரிசோதனைகள்"
        ],
        "test_count_single": [
            .english: "1 test available",
            .sinhala: "පරීක්ෂණ 1ක් පවතී",
            .tamil: "1 பரிசோதனை கிடைக்கிறது"
        ],
        "prep_required": [
            .english: "Prep Required",
            .sinhala: "සූදානම අවශ්‍යයි",
            .tamil: "தயாரிப்பு தேவை"
        ],

        // ── Shared Category Names ──
        "cat_all": [
            .english: "All",
            .sinhala: "සියල්ල",
            .tamil: "அனைத்தும்"
        ],
        "cat_general": [
            .english: "General",
            .sinhala: "සාමාන්‍ය",
            .tamil: "பொது"
        ],
        "cat_surgical": [
            .english: "Surgical",
            .sinhala: "ශල්‍ය",
            .tamil: "அறுவை சிகிச்சை"
        ],
        "cat_specialized": [
            .english: "Specialized",
            .sinhala: "විශේෂිත",
            .tamil: "சிறப்பு"
        ],
        "cat_diagnostic": [
            .english: "Diagnostic",
            .sinhala: "රෝග විනිශ්චය",
            .tamil: "நோயறிதல்"
        ],
        "cat_emergency": [
            .english: "Emergency",
            .sinhala: "හදිසි",
            .tamil: "அவசர"
        ],
        "cat_blood": [
            .english: "Blood",
            .sinhala: "රුධිර",
            .tamil: "இரத்தம்"
        ],
        "cat_urine": [
            .english: "Urine",
            .sinhala: "මුත්‍රා",
            .tamil: "சிறுநீர்"
        ],
        "cat_imaging": [
            .english: "Imaging",
            .sinhala: "රූප",
            .tamil: "படப்பிடிப்பு"
        ],
        "cat_cardiac": [
            .english: "Cardiac",
            .sinhala: "හෘද",
            .tamil: "இதய"
        ],
        "cat_metabolic": [
            .english: "Metabolic",
            .sinhala: "පරිවෘත්තීය",
            .tamil: "வளர்சிதை மாற்ற"
        ],
        "cat_infectious": [
            .english: "Infectious",
            .sinhala: "බෝවන",
            .tamil: "தொற்று"
        ],

        // ── Availability Statuses ──
        "status_available": [
            .english: "Available",
            .sinhala: "පවතී",
            .tamil: "கிடைக்கிறது"
        ],
        "status_busy": [
            .english: "Busy",
            .sinhala: "කාර්යබහුලයි",
            .tamil: "பிஸியாக"
        ],
        "status_closed": [
            .english: "Closed",
            .sinhala: "වසා ඇත",
            .tamil: "மூடப்பட்டது"
        ],
        "status_limited": [
            .english: "Limited",
            .sinhala: "සීමිතයි",
            .tamil: "குறைவான"
        ],
        "status_unavailable": [
            .english: "Unavailable",
            .sinhala: "නොපවතී",
            .tamil: "கிடைக்கவில்லை"
        ],
        "waiting": [
            .english: "waiting",
            .sinhala: "බලා සිටිති",
            .tamil: "காத்திருக்கிறது"
        ],

        // ── Map Screen ──
        "floor_prefix": [
            .english: "Floor",
            .sinhala: "මහල",
            .tamil: "தளம்"
        ],
        "main_entrance": [
            .english: "Main Entrance",
            .sinhala: "ප්‍රධාන පිවිසුම",
            .tamil: "முக்கிய நுழைவாயில்"
        ],
        "specialist_wing": [
            .english: "Specialist Wing",
            .sinhala: "විශේෂඥ අංශය",
            .tamil: "நிபுணர் பிரிவு"
        ],
        "map_diagnostics": [
            .english: "Diagnostics",
            .sinhala: "රෝග විනිශ්චය",
            .tamil: "நோயறிதல்"
        ],
        "registration": [
            .english: "Registration",
            .sinhala: "ලියාපදිංචිය",
            .tamil: "பதிவு"
        ],
        "consultation": [
            .english: "Consultation",
            .sinhala: "උපදේශනය",
            .tamil: "ஆலோசனை"
        ],
        "laboratory": [
            .english: "Laboratory",
            .sinhala: "රසායනාගාරය",
            .tamil: "ஆய்வகம்"
        ],
        "pharmacy_area": [
            .english: "Pharmacy",
            .sinhala: "ඖෂධාගාරය",
            .tamil: "மருந்தகம்"
        ],
        "payment": [
            .english: "Payment",
            .sinhala: "ගෙවීම",
            .tamil: "கட்டணம்"
        ],
        "restrooms": [
            .english: "Restrooms",
            .sinhala: "විවේක කාමර",
            .tamil: "கழிவறைகள்"
        ],
        "main_corridor": [
            .english: "Main Corridor",
            .sinhala: "ප්‍රධාන කොරිඩෝව",
            .tamil: "முக்கிய நடைபாதை"
        ],
        "south_wing": [
            .english: "South Wing",
            .sinhala: "දකුණු අංශය",
            .tamil: "தெற்கு பிரிவு"
        ],
        "staircase": [
            .english: "Staircase",
            .sinhala: "පඩිපෙළ",
            .tamil: "படிக்கட்டு"
        ],
        "connects_all_floors": [
            .english: "Connects all floors",
            .sinhala: "සියලුම මහල් සම්බන්ධ කරයි",
            .tamil: "அனைத்து தளங்களையும் இணைக்கிறது"
        ],
        "elevator": [
            .english: "Elevator",
            .sinhala: "සෝපානය",
            .tamil: "மின்தூக்கி"
        ],
        "room_prefix": [
            .english: "Rm",
            .sinhala: "කා",
            .tamil: "அறை"
        ],
        "room_full": [
            .english: "Room",
            .sinhala: "කාමරය",
            .tamil: "அறை"
        ],
        "legend": [
            .english: "Legend",
            .sinhala: "සටහන",
            .tamil: "குறியீடு"
        ],
        "you_are_here": [
            .english: "You are here",
            .sinhala: "ඔබ මෙහි සිටී",
            .tamil: "நீங்கள் இங்கே இருக்கிறீர்கள்"
        ],
        "navigate": [
            .english: "Navigate",
            .sinhala: "යොමු කරන්න",
            .tamil: "வழிசெலுத்து"
        ],
        "start_navigation": [
            .english: "Start Navigation",
            .sinhala: "මාර්ගෝපදේශනය ආරම්භ කරන්න",
            .tamil: "வழிசெலுத்தலைத் தொடங்கு"
        ],
        "stop_navigation": [
            .english: "Stop Navigation",
            .sinhala: "මාර්ගෝපදේශනය නවතන්න",
            .tamil: "வழிசெலுத்தலை நிறுத்து"
        ],
        "walking": [
            .english: "walking",
            .sinhala: "ඇවිදීම",
            .tamil: "நடைபயிற்சி"
        ],
        "min_suffix": [
            .english: "min",
            .sinhala: "මිනි",
            .tamil: "நிமி"
        ],

        // ── Profile Details Screen ──
        "profile_details": [
            .english: "Profile Details",
            .sinhala: "පැතිකඩ විස්තර",
            .tamil: "சுயவிவர விவரங்கள்"
        ],
        "active": [
            .english: "Active",
            .sinhala: "සක්‍රියයි",
            .tamil: "செயலில்"
        ],
        "inactive": [
            .english: "Inactive",
            .sinhala: "අක්‍රියයි",
            .tamil: "செயலற்றது"
        ],
        "personal_information": [
            .english: "Personal Information",
            .sinhala: "පුද්ගලික තොරතුරු",
            .tamil: "தனிப்பட்ட தகவல்கள்"
        ],
        "full_name": [
            .english: "Full Name",
            .sinhala: "සම්පූර්ණ නම",
            .tamil: "முழு பெயர்"
        ],
        "date_of_birth": [
            .english: "Date of Birth",
            .sinhala: "උපන් දිනය",
            .tamil: "பிறந்த தேதி"
        ],
        "gender": [
            .english: "Gender",
            .sinhala: "ස්ත්‍රී පුරුෂ භාවය",
            .tamil: "பாலினம்"
        ],
        "blood_type": [
            .english: "Blood Type",
            .sinhala: "රුධිර වර්ගය",
            .tamil: "இரத்த வகை"
        ],
        "phone": [
            .english: "Phone",
            .sinhala: "දුරකථනය",
            .tamil: "தொலைபேசி"
        ],
        "email": [
            .english: "Email",
            .sinhala: "ඊමේල්",
            .tamil: "மின்னஞ்சல்"
        ],
        "allergies": [
            .english: "Allergies",
            .sinhala: "අසාත්මිකතා",
            .tamil: "ஒவ்வாமைகள்"
        ],
        "add": [
            .english: "Add",
            .sinhala: "එකතු කරන්න",
            .tamil: "சேர்"
        ],
        "no_allergies_recorded": [
            .english: "No allergies recorded",
            .sinhala: "අසාත්මිකතා වාර්තා නැත",
            .tamil: "ஒவ்வாமைகள் பதிவு செய்யப்படவில்லை"
        ],
        "medical_history": [
            .english: "Medical History",
            .sinhala: "වෛද්‍ය ඉතිහාසය",
            .tamil: "மருத்துவ வரலாறு"
        ],
        "view_all": [
            .english: "View All",
            .sinhala: "සියල්ල බලන්න",
            .tamil: "அனைத்தையும் காண்க"
        ],
        "no_medical_history": [
            .english: "No medical history recorded",
            .sinhala: "වෛද්‍ය ඉතිහාසයක් වාර්තා නැත",
            .tamil: "மருத்துவ வரலாறு பதிவு செய்யப்படவில்லை"
        ],
        "delete_profile": [
            .english: "Delete Profile",
            .sinhala: "පැතිකඩ මකන්න",
            .tamil: "சுயவிவரத்தை நீக்கு"
        ],
        "add_allergy": [
            .english: "Add Allergy",
            .sinhala: "අසාත්මිකතාවක් එක් කරන්න",
            .tamil: "ஒவ்வாமையைச் சேர்க்கவும்"
        ],
        "add_allergy_message": [
            .english: "Enter the name of the allergy to add.",
            .sinhala: "එකතු කළ යුතු අසාත්මිකතාවේ නම ඇතුළත් කරන්න.",
            .tamil: "சேர்க்க வேண்டிய ஒவ்வாமையின் பெயரை உள்ளிடவும்."
        ],
        "delete_profile_message": [
            .english: "Are you sure you want to delete this profile? This action cannot be undone.",
            .sinhala: "ඔබට මෙම පැතිකඩ මැකීමට අවශ්‍ය බව විශ්වාසද? මෙම ක්‍රියාව අහෝසි කළ නොහැක.",
            .tamil: "இந்த சுயவிவரத்தை நீக்க விரும்புகிறீர்களா? இந்தச் செயலை மீட்டெடுக்க முடியாது."
        ],

        // ── Patient Profiles Screen ──
        "my_profiles": [
            .english: "My Profiles",
            .sinhala: "මගේ පැතිකඩ",
            .tamil: "எனது சுயவிவரங்கள்"
        ],
        "add_family_member": [
            .english: "Add Family Member",
            .sinhala: "පවුලේ සාමාජිකයෙකු එක් කරන්න",
            .tamil: "குடும்ப உறுப்பினரைச் சேர்க்கவும்"
        ],
        "information": [
            .english: "Information",
            .sinhala: "තොරතුරු",
            .tamil: "தகவல்"
        ],
        "male": [
            .english: "Male",
            .sinhala: "පුරුෂ",
            .tamil: "ஆண்"
        ],
        "female": [
            .english: "Female",
            .sinhala: "ස්ත්‍රී",
            .tamil: "பெண்"
        ],
        "other_gender": [
            .english: "Other",
            .sinhala: "වෙනත්",
            .tamil: "மற்றவை"
        ],
        "no_allergies_added": [
            .english: "No allergies added",
            .sinhala: "අසාත්මිකතා එකතු කර නැත",
            .tamil: "ஒவ்வாமைகள் சேர்க்கப்படவில்லை"
        ],
        "save_profile": [
            .english: "Save Profile",
            .sinhala: "පැතිකඩ සුරකින්න",
            .tamil: "சுயவிவரத்தைச் சேமி"
        ],
        "patient_id_label": [
            .english: "Patient ID",
            .sinhala: "රෝගී හැඳුනුම්පත",
            .tamil: "நோயாளி அடையாளம்"
        ],
        "phone_number": [
            .english: "Phone Number",
            .sinhala: "දුරකථන අංකය",
            .tamil: "தொலைபேசி எண்"
        ],
        "email_address": [
            .english: "Email Address",
            .sinhala: "ඊමේල් ලිපිනය",
            .tamil: "மின்னஞ்சல் முகவரி"
        ],
        "allergy_name_placeholder": [
            .english: "Allergy name",
            .sinhala: "අසාත්මිකතා නම",
            .tamil: "ஒவ்வாமை பெயர்"
        ],
        "relationship_placeholder": [
            .english: "Relationship (e.g. Spouse, Child)",
            .sinhala: "සම්බන්ධතාව (උදා: කලත්‍රයා, දරුවා)",
            .tamil: "உறவு (எ.கா. கணவர்/மனைவி, குழந்தை)"
        ],
        "dob_placeholder": [
            .english: "Date of Birth (e.g. June 22, 1990)",
            .sinhala: "උපන් දිනය (උදා: 1990 ජූනි 22)",
            .tamil: "பிறந்த தேதி (எ.கா. ஜூன் 22, 1990)"
        ],
        "blood_type_placeholder": [
            .english: "Blood Type (e.g. A+, O-)",
            .sinhala: "රුධිර වර්ගය (උදා: A+, O-)",
            .tamil: "இரத்த வகை (எ.கா. A+, O-)"
        ],

        // ── Lab Test Info Modal ──
        "lab_test_title": [
            .english: "LAB Test",
            .sinhala: "රසායනාගාර පරීක්ෂණය",
            .tamil: "ஆய்வக பரிசோதனை"
        ],
        "instructions_title": [
            .english: "Instructions !",
            .sinhala: "උපදෙස් !",
            .tamil: "வழிமுறைகள் !"
        ],
        "instruction_fasting_title": [
            .english: "Fasting may be required",
            .sinhala: "උපවාසය අවශ්‍ය විය හැක",
            .tamil: "உண்ணாவிரதம் தேவைப்படலாம்"
        ],
        "instruction_fasting_desc": [
            .english: "Do not eat or drink (except water) for 8-12 hours if instructed.",
            .sinhala: "උපදෙස් දුන්නේ නම් පැය 8-12 ක් ආහාර හෝ පාන (ජලය හැර) නොගන්න.",
            .tamil: "அறிவுறுத்தினால் 8-12 மணி நேரம் உணவு அல்லது பானம் (தண்ணீர் தவிர) எடுக்காதீர்கள்."
        ],
        "instruction_medicines_title": [
            .english: "Take medicines only if advised",
            .sinhala: "උපදෙස් දුන්නේ නම් පමණක් බෙහෙත් ගන්න",
            .tamil: "அறிவுறுத்தினால் மட்டுமே மருந்துகளை எடுக்கவும்"
        ],
        "instruction_medicines_desc": [
            .english: "Continue or stop medications only as directed by your doctor.",
            .sinhala: "ඔබේ වෛද්‍යවරයාගේ උපදෙස් පරිදි පමණක් ඖෂධ ගැනීම දිගටම කරගෙන යන්න හෝ නවත්වන්න.",
            .tamil: "உங்கள் மருத்துவரின் அறிவுறுத்தலின்படி மட்டுமே மருந்துகளைத் தொடரவும் அல்லது நிறுத்தவும்."
        ],
        "instruction_water_title": [
            .english: "Drink water",
            .sinhala: "ජලය පානය කරන්න",
            .tamil: "தண்ணீர் குடிக்கவும்"
        ],
        "instruction_water_desc": [
            .english: "Stay well hydrated unless told otherwise.",
            .sinhala: "වෙනත් ලෙස උපදෙස් දෙන්නේ නම් හැර හොඳින් ජලය පානය කරන්න.",
            .tamil: "மாறாகக் கூறப்படாவிட்டால் நன்கு நீரேற்றமாக இருங்கள்."
        ],
        "instruction_alcohol_title": [
            .english: "Avoid alcohol and smoking",
            .sinhala: "මත්පැන් සහ දුම්පානය වළක්වන්න",
            .tamil: "மது மற்றும் புகைபிடிப்பதை தவிர்க்கவும்"
        ],
        "instruction_alcohol_desc": [
            .english: "Do not consume alcohol or smoke at least 24 hours before the test.",
            .sinhala: "පරීක්ෂණයට අවම වශයෙන් පැය 24 කට පෙර මත්පැන් හෝ දුම්පානය නොකරන්න.",
            .tamil: "பரிசோதனைக்கு குறைந்தது 24 மணி நேரத்திற்கு முன்பு மது அல்லது புகைபிடிக்காதீர்கள்."
        ],
        "instruction_time_title": [
            .english: "Arrive on time",
            .sinhala: "වේලාවට පැමිණෙන්න",
            .tamil: "நேரத்திற்கு வாருங்கள்"
        ],
        "instruction_time_desc": [
            .english: "Reach the lab 10-15 minutes early.",
            .sinhala: "මිනිත්තු 10-15 කට කලින් රසායනාගාරයට පැමිණෙන්න.",
            .tamil: "ஆய்வகத்திற்கு 10-15 நிமிடங்கள் முன்னதாக வாருங்கள்."
        ],
        "instruction_documents_title": [
            .english: "Carry required documents",
            .sinhala: "අවශ්‍ය ලේඛන රැගෙන එන්න",
            .tamil: "தேவையான ஆவணங்களை எடுத்து வாருங்கள்"
        ],
        "instruction_documents_desc": [
            .english: "Bring your test request form and identification.",
            .sinhala: "ඔබේ පරීක්ෂණ ඉල්ලුම් පත්‍රය සහ හැඳුනුම්පත රැගෙන එන්න.",
            .tamil: "உங்கள் பரிசோதனை கோரிக்கை படிவம் மற்றும் அடையாள அட்டையை கொண்டு வாருங்கள்."
        ],
        "instruction_inform_title": [
            .english: "Inform the lab staff",
            .sinhala: "රසායනාගාර කාර්ය මණ්ඩලයට දැනුම් දෙන්න",
            .tamil: "ஆய்வக ஊழியர்களுக்குத் தெரிவிக்கவும்"
        ],
        "instruction_inform_desc": [
            .english: "Tell staff if you are pregnant, diabetic, or have allergies.",
            .sinhala: "ඔබ ගර්භිණී නම්, දියවැඩියා නම් හෝ අසාත්මිකතා ඇත්නම් කාර්ය මණ්ඩලයට දන්වන්න.",
            .tamil: "நீங்கள் கர்ப்பமாக இருந்தால், நீரிழிவு இருந்தால் அல்லது ஒவ்வாமை இருந்தால் ஊழியர்களிடம் தெரிவிக்கவும்."
        ],
        "instruction_exercise_title": [
            .english: "Avoid heavy exercise",
            .sinhala: "දැඩි ව්‍යායාම වළක්වන්න",
            .tamil: "கடுமையான உடற்பயிற்சியைத் தவிர்க்கவும்"
        ],
        "instruction_exercise_desc": [
            .english: "Do not do strenuous activity before the test.",
            .sinhala: "පරීක්ෂණයට පෙර දැඩි ක්‍රියාකාරකම් නොකරන්න.",
            .tamil: "பரிசோதனைக்கு முன் கடுமையான செயல்பாடுகளைச் செய்யாதீர்கள்."
        ],
        "instructions_footer": [
            .english: "Please follow these instructions for accurate test results.",
            .sinhala: "නිවැරදි පරීක්ෂණ ප්‍රතිඵල සඳහා කරුණාකර මෙම උපදෙස් අනුගමනය කරන්න.",
            .tamil: "துல்லியமான பரிசோதனை முடிவுகளுக்கு இந்த வழிமுறைகளைப் பின்பற்றவும்."
        ],

        // ── Lab Test Confirmation Modal ──
        "current_status": [
            .english: "Current Status",
            .sinhala: "වත්මන් තත්ත්වය",
            .tamil: "தற்போதைய நிலை"
        ],
        "before_you_proceed": [
            .english: "Before You Proceed",
            .sinhala: "ඉදිරියට යාමට පෙර",
            .tamil: "தொடர்வதற்கு முன்"
        ],
        "fasting_required": [
            .english: "Fasting required?",
            .sinhala: "උපවාසය අවශ්‍යද?",
            .tamil: "உண்ணாவிரதம் தேவையா?"
        ],
        "yes": [
            .english: "Yes",
            .sinhala: "ඔව්",
            .tamil: "ஆம்"
        ],
        "no": [
            .english: "No",
            .sinhala: "නැත",
            .tamil: "இல்லை"
        ],
        "estimated_duration": [
            .english: "Estimated test duration :",
            .sinhala: "ඇස්තමේන්තුගත පරීක්ෂණ කාලය :",
            .tamil: "மதிப்பிடப்பட்ட பரிசோதனை காலம் :"
        ],
        "minutes": [
            .english: "minutes",
            .sinhala: "මිනිත්තු",
            .tamil: "நிமிடங்கள்"
        ],
        "estimated_result_time": [
            .english: "Estimated result time :",
            .sinhala: "ඇස්තමේන්තුගත ප්‍රතිඵල කාලය :",
            .tamil: "மதிப்பிடப்பட்ட முடிவு நேரம் :"
        ],
        "lab_test_fee": [
            .english: "Lab test fee :",
            .sinhala: "රසායනාගාර පරීක්ෂණ ගාස්තුව :",
            .tamil: "ஆய்வக பரிசோதனை கட்டணம் :"
        ],
    ]

    // MARK: - Lookup
    static func get(_ key: String, for language: AppLanguage) -> String {
        return strings[key]?[language] ?? strings[key]?[.english] ?? key
    }
}
