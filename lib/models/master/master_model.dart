class MasterRes {
  String? message;
  Data? data;

  MasterRes({message, data});

  MasterRes.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ?  Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataNew =<String, dynamic>{};
    dataNew['message'] = message;
    if (data != null) {
      dataNew['data'] = data!.toJson();
    }
    return dataNew;
  }
}

class Data {
  Currency? currency;
  String? appName;
  bool? showDownloadApp;
  List<PaymentGateways>? paymentGateways;
  bool? multiVendor;
  String? mobile;
  String? email;
  String? address;
  bool? webShowFooter;
  String? webFooterText;
  String? webFooterDescription;
  String? webLogo;
  String? webFooterLogo;
  String? appLogo;
  String? footerQr;
  List<SocialLinks>? socialLinks;
  ThemeColors? themeColors;
  String? pusherAppKey;
  String? pusherAppCluster;
  String? appEnvironment;
  bool? registerOtpVerify;
  String? registerOtpType;
  String? forgotOtpType;
  List<Languages>? languages;
  SocialAuths? socialAuths;
  List<Seasons>? seasons;
  List<Qualities>? qualities;
  List<Sizes>? sizes;

  Data(
      {currency,
      appName,
      showDownloadApp,
      googlePlaystoreLink,
      appStoreLink,
      paymentGateways,
      multiVendor,
      mobile,
      email,
      address,
      webShowFooter,
      webFooterText,
      webFooterDescription,
      webLogo,
      webFooterLogo,
      appLogo,
      footerQr,
      socialLinks,
      themeColors,
      pusherAppKey,
      pusherAppCluster,
      appEnvironment,
      registerOtpVerify,
      registerOtpType,
      forgotOtpType,
      languages,
      socialAuths,
      seasons,
      qualities,
      sizes});

  Data.fromJson(Map<String, dynamic> json) {
    currency = json['currency'] != null
        ?  Currency.fromJson(json['currency'])
        : null;
    appName = json['app_name'];
    showDownloadApp = json['show_download_app'];
    if (json['payment_gateways'] != null) {
      paymentGateways = <PaymentGateways>[];
      json['payment_gateways'].forEach((v) {
        paymentGateways!.add( PaymentGateways.fromJson(v));
      });
    }
    multiVendor = json['multi_vendor'];
    mobile = json['mobile'];
    email = json['email'];
    address = json['address'];
    webShowFooter = json['web_show_footer'];
    webFooterText = json['web_footer_text'];
    webFooterDescription = json['web_footer_description'];
    webLogo = json['web_logo'];
    webFooterLogo = json['web_footer_logo'];
    appLogo = json['app_logo'];
    footerQr = json['footer_qr'];
    if (json['social_links'] != null) {
      socialLinks = <SocialLinks>[];
      json['social_links'].forEach((v) {
        socialLinks!.add( SocialLinks.fromJson(v));
      });
    }
    themeColors = json['theme_colors'] != null
        ?  ThemeColors.fromJson(json['theme_colors'])
        : null;
    pusherAppKey = json['pusher_app_key'];
    pusherAppCluster = json['pusher_app_cluster'];
    appEnvironment = json['app_environment'];
    registerOtpVerify = json['register_otp_verify'];
    registerOtpType = json['register_otp_type'];
    forgotOtpType = json['forgot_otp_type'];
    if (json['languages'] != null) {
      languages = <Languages>[];
      json['languages'].forEach((v) {
        languages!.add( Languages.fromJson(v));
      });
    }
    socialAuths = json['social_auths'] != null
        ?  SocialAuths.fromJson(json['social_auths'])
        : null;
    if (json['seasons'] != null) {
      seasons = <Seasons>[];
      json['seasons'].forEach((v) {
        seasons!.add( Seasons.fromJson(v));
      });
    }
    if (json['qualities'] != null) {
      qualities = <Qualities>[];
      json['qualities'].forEach((v) {
        qualities!.add( Qualities.fromJson(v));
      });
    }
    if (json['sizes'] != null) {
      sizes = <Sizes>[];
      json['sizes'].forEach((v) {
        sizes!.add( Sizes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (currency != null) {
      data['currency'] = currency!.toJson();
    }
    data['app_name'] = appName;
    data['show_download_app'] = showDownloadApp;
    if (paymentGateways != null) {
      data['payment_gateways'] =
          paymentGateways!.map((v) => v.toJson()).toList();
    }
    data['multi_vendor'] = multiVendor;
    data['mobile'] = mobile;
    data['email'] = email;
    data['address'] = address;
    data['web_show_footer'] = webShowFooter;
    data['web_footer_text'] = webFooterText;
    data['web_footer_description'] = webFooterDescription;
    data['web_logo'] = webLogo;
    data['web_footer_logo'] = webFooterLogo;
    data['app_logo'] = appLogo;
    data['footer_qr'] = footerQr;
    if (socialLinks != null) {
      data['social_links'] = socialLinks!.map((v) => v.toJson()).toList();
    }
    if (themeColors != null) {
      data['theme_colors'] = themeColors!.toJson();
    }
    data['pusher_app_key'] = pusherAppKey;
    data['pusher_app_cluster'] = pusherAppCluster;
    data['app_environment'] = appEnvironment;
    data['register_otp_verify'] = registerOtpVerify;
    data['register_otp_type'] = registerOtpType;
    data['forgot_otp_type'] = forgotOtpType;
    if (languages != null) {
      data['languages'] = languages!.map((v) => v.toJson()).toList();
    }
    if (socialAuths != null) {
      data['social_auths'] = socialAuths!.toJson();
    }
    if (seasons != null) {
      data['seasons'] = seasons!.map((v) => v.toJson()).toList();
    }
    if (qualities != null) {
      data['qualities'] = qualities!.map((v) => v.toJson()).toList();
    }
    if (sizes != null) {
      data['sizes'] = sizes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Currency {
  String? symbol;
  String? position;

  Currency({symbol, position});

  Currency.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['symbol'] = symbol;
    data['position'] = position;
    return data;
  }
}

class PaymentGateways {
  int? id;
  String? title;
  String? name;
  String? logo;
  bool? isActive;

  PaymentGateways({id, title, name, logo, isActive});

  PaymentGateways.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    name = json['name'];
    logo = json['logo'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['name'] = name;
    data['logo'] = logo;
    data['is_active'] = isActive;
    return data;
  }
}

class SocialLinks {
  int? id;
  String? name;
  String? logo;
  String? link;

  SocialLinks({id, name, logo, link});

  SocialLinks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['logo'] = logo;
    data['link'] = link;
    return data;
  }
}

class ThemeColors {
  String? primary;
  String? primary50;
  String? primary100;
  String? primary200;
  String? primary300;
  String? primary400;
  String? primary500;
  String? primary600;
  String? primary700;
  String? primary800;
  String? primary900;
  String? primary950;

  ThemeColors(
      {primary,
      primary50,
      primary100,
      primary200,
      primary300,
      primary400,
      primary500,
      primary600,
      primary700,
      primary800,
      primary900,
      primary950});

  ThemeColors.fromJson(Map<String, dynamic> json) {
    primary = json['primary'];
    primary50 = json['primary50'];
    primary100 = json['primary100'];
    primary200 = json['primary200'];
    primary300 = json['primary300'];
    primary400 = json['primary400'];
    primary500 = json['primary500'];
    primary600 = json['primary600'];
    primary700 = json['primary700'];
    primary800 = json['primary800'];
    primary900 = json['primary900'];
    primary950 = json['primary950'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['primary'] = primary;
    data['primary50'] = primary50;
    data['primary100'] = primary100;
    data['primary200'] = primary200;
    data['primary300'] = primary300;
    data['primary400'] = primary400;
    data['primary500'] = primary500;
    data['primary600'] = primary600;
    data['primary700'] = primary700;
    data['primary800'] = primary800;
    data['primary900'] = primary900;
    data['primary950'] = primary950;
    return data;
  }
}

class Languages {
  int? id;
  String? title;
  String? name;

  Languages({id, title, name});

  Languages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['name'] = name;
    return data;
  }
}

class SocialAuths {
  Google? google;
  Facebook? facebook;
  Apple? apple;

  SocialAuths({google, facebook, apple});

  SocialAuths.fromJson(Map<String, dynamic> json) {
    google =
        json['google'] != null ?  Google.fromJson(json['google']) : null;
    facebook = json['facebook'] != null
        ?  Facebook.fromJson(json['facebook'])
        : null;
    apple = json['apple'] != null ?  Apple.fromJson(json['apple']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (google != null) {
      data['google'] = google!.toJson();
    }
    if (facebook != null) {
      data['facebook'] = facebook!.toJson();
    }
    if (apple != null) {
      data['apple'] = apple!.toJson();
    }
    return data;
  }
}

class Google {
  String? name;
 
  bool? isActive;
  String? redirectUrl;

  Google({name, clientId, isActive, redirectUrl});

  Google.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isActive = json['is_active'];
    redirectUrl = json['redirect_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['is_active'] = isActive;
    data['redirect_url'] = redirectUrl;
    return data;
  }
}

class Facebook {
  String? name;
  String? clientId;
  bool? isActive;
  String? redirectUrl;

  Facebook({name, clientId, isActive, redirectUrl});

  Facebook.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    clientId = json['client_id'];
    isActive = json['is_active'];
    redirectUrl = json['redirect_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['client_id'] = clientId;
    data['is_active'] = isActive;
    data['redirect_url'] = redirectUrl;
    return data;
  }
}

class Apple {
  String? name;
 
  bool? isActive;


  Apple({name, clientId, isActive, redirectUrl});

  Apple.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isActive = json['is_active'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['is_active'] = isActive;

    return data;
  }
}

class Seasons {
  int? id;
  String? name;
  String? description;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  Seasons(
      {id,
      name,
      description,
      isActive,
      createdAt,
      updatedAt});

  Seasons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Qualities {
  int? id;
  String? name;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  Qualities(
      {id, name, isActive, createdAt, updatedAt});

  Qualities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Sizes {
  int? id;
  String? name;
  int? shopId;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  Sizes(
      {id,
      name,
      nameAr,
      shopId,
      isActive,
      createdAt,
      updatedAt});

  Sizes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shopId = json['shop_id'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['shop_id'] = shopId;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
