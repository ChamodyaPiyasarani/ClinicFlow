//
//  LocalizedStrings.swift
//  ClinicFlow
//
//  Created by cobsccomp242p-030 on 2026-02-28.
//

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

        // ── Placeholder – add more screen-specific keys below ──
        "hello_world": [
            .english: "Hello, World!",
            .sinhala: "ආයුබෝවන්, ලෝකය!",
            .tamil: "வணக்கம், உலகம்!"
        ],
    ]

    // MARK: - Lookup
    static func get(_ key: String, for language: AppLanguage) -> String {
        return strings[key]?[language] ?? strings[key]?[.english] ?? key
    }
}
