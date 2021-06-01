// Generated by Apple Swift version 5.3.2 (swiftlang-1200.0.45 clang-1200.0.32.28)
#ifndef PURCHASESCORESWIFT_SWIFT_H
#define PURCHASESCORESWIFT_SWIFT_H
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <Foundation/Foundation.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(ns_consumed)
# define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
#else
# define SWIFT_RELEASES_ARGUMENT
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif
#if !defined(SWIFT_RESILIENT_CLASS)
# if __has_attribute(objc_class_stub)
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_class_stub))
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_class_stub)) SWIFT_CLASS_NAMED(SWIFT_NAME)
# else
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME)
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) SWIFT_CLASS_NAMED(SWIFT_NAME)
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility)
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_WEAK_IMPORT)
# define SWIFT_WEAK_IMPORT __attribute__((weak_import))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if !defined(IBSegueAction)
# define IBSegueAction
#endif
#if __has_feature(modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import Foundation;
@import ObjectiveC;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="PurchasesCoreSwift",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif


SWIFT_CLASS_NAMED("AttributionStrings")
@interface RCAttributionStrings : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull appsflyer_id_deprecated;
@property (nonatomic, readonly, copy) NSString * _Nonnull attributes_sync_error;
@property (nonatomic, readonly, copy) NSString * _Nonnull attributes_sync_success;
@property (nonatomic, readonly, copy) NSString * _Nonnull empty_subscriber_attributes;
@property (nonatomic, readonly, copy) NSString * _Nonnull marking_attributes_synced;
@property (nonatomic, readonly, copy) NSString * _Nonnull method_called;
@property (nonatomic, readonly, copy) NSString * _Nonnull networkuserid_required_for_appsflyer;
@property (nonatomic, readonly, copy) NSString * _Nonnull no_instance_configured_caching_attribution;
@property (nonatomic, readonly, copy) NSString * _Nonnull instance_configured_posting_attribution;
@property (nonatomic, readonly, copy) NSString * _Nonnull search_ads_attribution_cancelled_missing_att_framework;
@property (nonatomic, readonly, copy) NSString * _Nonnull att_framework_present_but_couldnt_call_tracking_authorization_status;
@property (nonatomic, readonly, copy) NSString * _Nonnull search_ads_attribution_cancelled_missing_iad_framework;
@property (nonatomic, readonly, copy) NSString * _Nonnull search_ads_attribution_cancelled_not_authorized;
@property (nonatomic, readonly, copy) NSString * _Nonnull skip_same_attributes;
@property (nonatomic, readonly, copy) NSString * _Nonnull subscriber_attributes_error;
@property (nonatomic, readonly, copy) NSString * _Nonnull unsynced_attributes_count;
@property (nonatomic, readonly, copy) NSString * _Nonnull unsynced_attributes;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS_NAMED("ConfigureStrings")
@interface RCConfigureStrings : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull adsupport_not_imported;
@property (nonatomic, readonly, copy) NSString * _Nonnull application_active;
@property (nonatomic, readonly, copy) NSString * _Nonnull configuring_purchases_proxy_url_set;
@property (nonatomic, readonly, copy) NSString * _Nonnull debug_enabled;
@property (nonatomic, readonly, copy) NSString * _Nonnull delegate_set;
@property (nonatomic, readonly, copy) NSString * _Nonnull purchase_instance_already_set;
@property (nonatomic, readonly, copy) NSString * _Nonnull initial_app_user_id;
@property (nonatomic, readonly, copy) NSString * _Nonnull no_singleton_instance;
@property (nonatomic, readonly, copy) NSString * _Nonnull sdk_version;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS_NAMED("IdentityStrings")
@interface RCIdentityStrings : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull changing_app_user_id;
@property (nonatomic, readonly, copy) NSString * _Nonnull creating_alias_failed_null_currentappuserid;
@property (nonatomic, readonly, copy) NSString * _Nonnull creating_alias_success;
@property (nonatomic, readonly, copy) NSString * _Nonnull creating_alias;
@property (nonatomic, readonly, copy) NSString * _Nonnull identifying_anon_id;
@property (nonatomic, readonly, copy) NSString * _Nonnull identifying_app_user_id;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSNumber;

SWIFT_CLASS_NAMED("IntroEligibilityCalculator")
@interface RCIntroEligibilityCalculator : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (void)checkTrialOrIntroductoryPriceEligibilityWith:(NSData * _Nonnull)receiptData productIdentifiers:(NSSet<NSString *> * _Nonnull)candidateProductIdentifiers completion:(void (^ _Nonnull)(NSDictionary<NSString *, NSNumber *> * _Nonnull, NSError * _Nullable))completion SWIFT_AVAILABILITY(watchos,introduced=6.2) SWIFT_AVAILABILITY(tvos,introduced=12.0) SWIFT_AVAILABILITY(maccatalyst,introduced=13.0) SWIFT_AVAILABILITY(macos,introduced=10.14) SWIFT_AVAILABILITY(ios,introduced=12.0);
@end


typedef SWIFT_ENUM_NAMED(NSInteger, RCLogIntent, "LogIntent", closed) {
  RCLogIntentAppleError = 0,
  RCLogIntentInfo = 1,
  RCLogIntentPurchase = 2,
  RCLogIntentRcError = 3,
  RCLogIntentRcPurchaseSuccess = 4,
  RCLogIntentRcSuccess = 5,
  RCLogIntentUser = 6,
  RCLogIntentWarning = 7,
};

typedef SWIFT_ENUM_NAMED(NSInteger, RCLogLevel, "LogLevel", closed) {
  RCLogLevelDebug = 0,
  RCLogLevelInfo = 1,
  RCLogLevelWarn = 2,
  RCLogLevelError = 3,
};


SWIFT_CLASS_NAMED("Logger")
@interface RCLogger : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) BOOL shouldShowDebugLogs;)
+ (BOOL)shouldShowDebugLogs SWIFT_WARN_UNUSED_RESULT;
+ (void)setShouldShowDebugLogs:(BOOL)value;
+ (void)logWithLevel:(enum RCLogLevel)level message:(NSString * _Nonnull)message;
+ (void)logWithLevel:(enum RCLogLevel)level intent:(enum RCLogIntent)intent message:(NSString * _Nonnull)message;
+ (void)debug:(NSString * _Nonnull)message;
+ (void)info:(NSString * _Nonnull)message;
+ (void)warn:(NSString * _Nonnull)message;
+ (void)error:(NSString * _Nonnull)message;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface RCLogger (SWIFT_EXTENSION(PurchasesCoreSwift))
+ (void)appleError:(NSString * _Nonnull)message;
+ (void)appleWarning:(NSString * _Nonnull)message;
+ (void)purchase:(NSString * _Nonnull)message;
+ (void)rcPurchaseSuccess:(NSString * _Nonnull)message;
+ (void)rcSuccess:(NSString * _Nonnull)message;
+ (void)user:(NSString * _Nonnull)message;
@end


SWIFT_CLASS_NAMED("NetworkStrings")
@interface RCNetworkStrings : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull api_request_completed;
@property (nonatomic, readonly, copy) NSString * _Nonnull api_request_started;
@property (nonatomic, readonly, copy) NSString * _Nonnull creating_json_error;
@property (nonatomic, readonly, copy) NSString * _Nonnull json_data_received;
@property (nonatomic, readonly, copy) NSString * _Nonnull parsing_json_error;
@property (nonatomic, readonly, copy) NSString * _Nonnull serial_request_done;
@property (nonatomic, readonly, copy) NSString * _Nonnull serial_request_queued;
@property (nonatomic, readonly, copy) NSString * _Nonnull skproductsrequest_failed;
@property (nonatomic, readonly, copy) NSString * _Nonnull skproductsrequest_finished;
@property (nonatomic, readonly, copy) NSString * _Nonnull skproductsrequest_received_response;
@property (nonatomic, readonly, copy) NSString * _Nonnull starting_next_request;
@property (nonatomic, readonly, copy) NSString * _Nonnull starting_request;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS_NAMED("OfferingStrings")
@interface RCOfferingStrings : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull cannot_find_product_configuration_error;
@property (nonatomic, readonly, copy) NSString * _Nonnull completion_handlers_waiting_on_products;
@property (nonatomic, readonly, copy) NSString * _Nonnull fetching_offerings_error;
@property (nonatomic, readonly, copy) NSString * _Nonnull fetching_products_failed;
@property (nonatomic, readonly, copy) NSString * _Nonnull fetching_products_finished;
@property (nonatomic, readonly, copy) NSString * _Nonnull fetching_products;
@property (nonatomic, readonly, copy) NSString * _Nonnull found_existing_product_request;
@property (nonatomic, readonly, copy) NSString * _Nonnull invalid_product_identifiers;
@property (nonatomic, readonly, copy) NSString * _Nonnull list_products;
@property (nonatomic, readonly, copy) NSString * _Nonnull no_cached_offerings_fetching_from_network;
@property (nonatomic, readonly, copy) NSString * _Nonnull no_cached_requests_and_products_starting_skproduct_request;
@property (nonatomic, readonly, copy) NSString * _Nonnull offerings_stale_updated_from_network;
@property (nonatomic, readonly, copy) NSString * _Nonnull offerings_stale_updating_in_background;
@property (nonatomic, readonly, copy) NSString * _Nonnull offerings_stale_updating_in_foreground;
@property (nonatomic, readonly, copy) NSString * _Nonnull products_already_cached;
@property (nonatomic, readonly, copy) NSString * _Nonnull retrieved_products;
@property (nonatomic, readonly, copy) NSString * _Nonnull skproductsrequest_did_finish;
@property (nonatomic, readonly, copy) NSString * _Nonnull skproductsrequest_received_response;
@property (nonatomic, readonly, copy) NSString * _Nonnull vending_offerings_cache;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS_NAMED("OperationDispatcher")
@interface RCOperationDispatcher : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (void)dispatchOnMainThread:(void (^ _Nonnull)(void))block;
- (void)dispatchOnWorkerThreadWithRandomDelay:(BOOL)withRandomDelay block:(void (^ _Nonnull)(void))block;
@end


SWIFT_CLASS_NAMED("PurchaseStrings")
@interface RCPurchaseStrings : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull cannot_purchase_product_appstore_configuration_error;
@property (nonatomic, readonly, copy) NSString * _Nonnull entitlements_revoked_syncing_purchases;
@property (nonatomic, readonly, copy) NSString * _Nonnull finishing_transaction;
@property (nonatomic, readonly, copy) NSString * _Nonnull purchasing_with_observer_mode_and_finish_transactions_false_warning;
@property (nonatomic, readonly, copy) NSString * _Nonnull paymentqueue_removedtransaction;
@property (nonatomic, readonly, copy) NSString * _Nonnull paymentqueue_revoked_entitlements_for_product_identifiers;
@property (nonatomic, readonly, copy) NSString * _Nonnull paymentqueue_updatedtransaction;
@property (nonatomic, readonly, copy) NSString * _Nonnull presenting_code_redemption_sheet_unavailable;
@property (nonatomic, readonly, copy) NSString * _Nonnull presenting_code_redemption_sheet;
@property (nonatomic, readonly, copy) NSString * _Nonnull purchases_synced;
@property (nonatomic, readonly, copy) NSString * _Nonnull purchasing_product_from_package;
@property (nonatomic, readonly, copy) NSString * _Nonnull purchasing_product;
@property (nonatomic, readonly, copy) NSString * _Nonnull skpayment_missing_from_skpaymenttransaction;
@property (nonatomic, readonly, copy) NSString * _Nonnull skpayment_missing_product_identifier;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS_NAMED("PurchaserInfoStrings")
@interface RCPurchaserInfoStrings : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull checking_intro_eligibility_locally_error;
@property (nonatomic, readonly, copy) NSString * _Nonnull checking_intro_eligibility_locally_result;
@property (nonatomic, readonly, copy) NSString * _Nonnull checking_intro_eligibility_locally;
@property (nonatomic, readonly, copy) NSString * _Nonnull invalidating_purchaserinfo_cache;
@property (nonatomic, readonly, copy) NSString * _Nonnull no_cached_purchaserinfo;
@property (nonatomic, readonly, copy) NSString * _Nonnull purchaserinfo_stale_updating_in_background;
@property (nonatomic, readonly, copy) NSString * _Nonnull purchaserinfo_stale_updating_in_foreground;
@property (nonatomic, readonly, copy) NSString * _Nonnull purchaserinfo_updated_from_network;
@property (nonatomic, readonly, copy) NSString * _Nonnull sending_latest_purchaserinfo_to_delegate;
@property (nonatomic, readonly, copy) NSString * _Nonnull sending_updated_purchaserinfo_to_delegate;
@property (nonatomic, readonly, copy) NSString * _Nonnull vending_cache;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS_NAMED("ReceiptParser")
@interface RCReceiptParser : NSObject
- (nonnull instancetype)init;
- (BOOL)receiptHasTransactionsWithReceiptData:(NSData * _Nonnull)receiptData SWIFT_WARN_UNUSED_RESULT;
@end



SWIFT_CLASS_NAMED("ReceiptStrings")
@interface RCReceiptStrings : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull data_object_identifer_not_found_receipt;
@property (nonatomic, readonly, copy) NSString * _Nonnull force_refreshing_receipt;
@property (nonatomic, readonly, copy) NSString * _Nonnull loaded_receipt;
@property (nonatomic, readonly, copy) NSString * _Nonnull no_sandbox_receipt_intro_eligibility;
@property (nonatomic, readonly, copy) NSString * _Nonnull no_sandbox_receipt_restore;
@property (nonatomic, readonly, copy) NSString * _Nonnull parse_receipt_locally_error;
@property (nonatomic, readonly, copy) NSString * _Nonnull parsing_receipt_failed;
@property (nonatomic, readonly, copy) NSString * _Nonnull parsing_receipt_success;
@property (nonatomic, readonly, copy) NSString * _Nonnull parsing_receipt;
@property (nonatomic, readonly, copy) NSString * _Nonnull refreshing_empty_receipt;
@property (nonatomic, readonly, copy) NSString * _Nonnull unable_to_load_receipt;
@property (nonatomic, readonly, copy) NSString * _Nonnull unknown_backend_error;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS_NAMED("RestoreStrings")
@interface RCRestoreStrings : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull restoretransactions_called_with_allow_sharing_appstore_account_false_warning;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS_NAMED("Strings")
@interface RCStrings : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) RCAttributionStrings * _Nonnull attribution;)
+ (RCAttributionStrings * _Nonnull)attribution SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) RCConfigureStrings * _Nonnull configure;)
+ (RCConfigureStrings * _Nonnull)configure SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) RCIdentityStrings * _Nonnull identity;)
+ (RCIdentityStrings * _Nonnull)identity SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) RCNetworkStrings * _Nonnull network;)
+ (RCNetworkStrings * _Nonnull)network SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) RCOfferingStrings * _Nonnull offering;)
+ (RCOfferingStrings * _Nonnull)offering SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) RCPurchaseStrings * _Nonnull purchase;)
+ (RCPurchaseStrings * _Nonnull)purchase SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) RCPurchaserInfoStrings * _Nonnull purchaserInfo;)
+ (RCPurchaserInfoStrings * _Nonnull)purchaserInfo SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) RCReceiptStrings * _Nonnull receipt;)
+ (RCReceiptStrings * _Nonnull)receipt SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) RCRestoreStrings * _Nonnull restore;)
+ (RCRestoreStrings * _Nonnull)restore SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS_NAMED("Transaction")
@interface RCTransaction : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull revenueCatId;
@property (nonatomic, readonly, copy) NSString * _Nonnull productId;
@property (nonatomic, readonly, copy) NSDate * _Nonnull purchaseDate;
- (nonnull instancetype)initWithTransactionId:(NSString * _Nonnull)transactionId productId:(NSString * _Nonnull)productId purchaseDate:(NSDate * _Nonnull)purchaseDate OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end

@class NSDateFormatter;

SWIFT_CLASS_NAMED("TransactionsFactory")
@interface RCTransactionsFactory : NSObject
- (NSArray<RCTransaction *> * _Nonnull)nonSubscriptionTransactionsWithSubscriptionsData:(NSDictionary<NSString *, NSArray<NSDictionary<NSString *, id> *> *> * _Nonnull)subscriptionsData dateFormatter:(NSDateFormatter * _Nonnull)dateFormatter SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
#endif