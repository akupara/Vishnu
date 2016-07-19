//
//  KurmaBluetoothCommon.swift
//  Vishnu
//
//  Created by Daniel Lu on 6/15/16.
//  Copyright © 2016 Daniel Lu. All rights reserved.
//  Present GATT preserved services and characteristices
//  Services: https://developer.bluetooth.org/gatt/services/Pages/ServicesHome.aspx
//  Characteristices: https://developer.bluetooth.org/gatt/characteristics/Pages/CharacteristicsHome.aspx

import Foundation
import CoreBluetooth

public enum KurmaBluetoothGATTServices:String {
    case AlertNotificationService = "0x1811"
    case AutomationIO = "0x1815"
    case BatteryService = "0x180F"
    case BloodPressure = "0x1810"
    case BodyComposition = "0x181B"
    case BondManagement = "0x181E"
    case ContinuousGlucoseMonitoring = "0x181F"
    case CurrentTimeService = "0x1805"
    case CyclingPower = "0x1818"
    case CyclingSpeedandCadence = "0x1816"
    case DeviceInformation = "0x180A"
    case EnvironmentalSensing = "0x181A"
    case GenericAccess = "0x1800"
    case GenericAttribute = "0x1801"
    case Glucose = "0x1808"
    case HealthThermometer = "0x1809"
    case HeartRate = "0x180D"
    case HTTPProxy = "0x1823"
    case HumanInterfaceDevice = "0x1812"
    case ImmediateAlert = "0x1802"
    case IndoorPositioning = "0x1821"
    case InternetProtocolSupport = "0x1820"
    case LinkLoss = "0x1803"
    case LocationandNavigation = "0x1819"
    case NextDSTChangeService = "0x1807"
    case ObjectTransfer = "0x1825"
    case PhoneAlertStatusService = "0x180E"
    case PulseOximeter = "0x1822"
    case ReferenceTimeUpdateService = "0x1806"
    case RunningSpeedandCadence = "0x1814"
    case ScanParameters = "0x1813"
    case TransportDiscovery = "0x1824"
    case TxPower = "0x1804"
    case UserData = "0x181C"
    case WeightScale = "0x181D"
    
    private static let meta:[String: (description:String, specification:String)] = [
        "0x1811":("Alert Notification Service","org.bluetooth.service.alert_notification"),
        "0x1815":("Automation IO","org.bluetooth.service.automation_io"),
        "0x180F":("Battery Service","org.bluetooth.service.battery_service"),
        "0x1810":("Blood Pressure","org.bluetooth.service.blood_pressure"),
        "0x181B":("Body Composition","org.bluetooth.service.body_composition"),
        "0x181E":("Bond Management","org.bluetooth.service.bond_management"),
        "0x181F":("Continuous Glucose Monitoring","org.bluetooth.service.continuous_glucose_monitoring"),
        "0x1805":("Current Time Service","org.bluetooth.service.current_time"),
        "0x1818":("Cycling Power","org.bluetooth.service.cycling_power"),
        "0x1816":("Cycling Speed and Cadence","org.bluetooth.service.cycling_speed_and_cadence"),
        "0x180A":("Device Information","org.bluetooth.service.device_information"),
        "0x181A":("Environmental Sensing","org.bluetooth.service.environmental_sensing"),
        "0x1800":("Generic Access","org.bluetooth.service.generic_access"),
        "0x1801":("Generic Attribute","org.bluetooth.service.generic_attribute"),
        "0x1808":("Glucose","org.bluetooth.service.glucose"),
        "0x1809":("Health Thermometer","org.bluetooth.service.health_thermometer"),
        "0x180D":("Heart Rate","org.bluetooth.service.heart_rate"),
        "0x1823":("HTTP Proxy","org.bluetooth.service.http_proxy"),
        "0x1812":("Human Interface Device","org.bluetooth.service.human_interface_device"),
        "0x1802":("Immediate Alert","org.bluetooth.service.immediate_alert"),
        "0x1821":("Indoor Positioning","org.bluetooth.service.indoor_positioning"),
        "0x1820":("Internet Protocol Support","org.bluetooth.service.internet_protocol_support"),
        "0x1803":("Link Loss","org.bluetooth.service.link_loss"),
        "0x1819":("Location and Navigation","org.bluetooth.service.location_and_navigation"),
        "0x1807":("Next DST Change Service","org.bluetooth.service.next_dst_change"),
        "0x1825":("Object Transfer","org.bluetooth.service.object_transfer"),
        "0x180E":("Phone Alert Status Service","org.bluetooth.service.phone_alert_status"),
        "0x1822":("Pulse Oximeter","org.bluetooth.service.pulse_oximeter"),
        "0x1806":("Reference Time Update Service","org.bluetooth.service.reference_time_update"),
        "0x1814":("Running Speed and Cadence","org.bluetooth.service.running_speed_and_cadence"),
        "0x1813":("Scan Parameters","org.bluetooth.service.scan_parameters"),
        "0x1824":("Transport Discovery","org.bluetooth.service.transport_discovery"),
        "0x1804":("Tx Power","org.bluetooth.service.tx_power"),
        "0x181C":("User Data","org.bluetooth.service.user_data"),
        "0x181D":("Weight Scale","org.bluetooth.service.weight_scale")
    ]
    
    public var description:String {
        get {
            guard let value = KurmaBluetoothGATTServices.meta[self.rawValue] else {
                return ""
            }
            return value.description
        }
    }
    
    public var specification:String {
        get {
            guard let value = KurmaBluetoothGATTServices.meta[self.rawValue] else {
                return ""
            }
            return value.specification
        }
    }
    
    public var UUID:CBUUID {
        get {
            return CBUUID(string: self.rawValue)
        }
    }
}

public enum KurmaBluetoothGATTCharacteristices:String {
    case AerobicHeartRateLowerLimit = "0x2A7E"
    case AerobicHeartRateUpperLimit = "0x2A84"
    case AerobicThreshold = "0x2A7F"
    case Age = "0x2A80"
    case Aggregate = "0x2A5A"
    case AlertCategoryID = "0x2A43"
    case AlertCategoryIDBitMask = "0x2A42"
    case AlertLevel = "0x2A06"
    case AlertNotificationControlPoint = "0x2A44"
    case AlertStatus = "0x2A3F"
    case Altitude = "0x2AB3"
    case AnaerobicHeartRateLowerLimit = "0x2A81"
    case AnaerobicHeartRateUpperLimit = "0x2A82"
    case AnaerobicThreshold = "0x2A83"
    case Analog = "0x2A58"
    case ApparentWindDirection = "0x2A73"
    case ApparentWindSpeed = "0x2A72"
    case Appearance = "0x2A01"
    case BarometricPressureTrend = "0x2AA3"
    case BatteryLevel = "0x2A19"
    case BloodPressureFeature = "0x2A49"
    case BloodPressureMeasurement = "0x2A35"
    case BodyCompositionFeature = "0x2A9B"
    case BodyCompositionMeasurement = "0x2A9C"
    case BodySensorLocation = "0x2A38"
    case BondManagementControlPoint = "0x2AA4"
    case BondManagementFeature = "0x2AA5"
    case BootKeyboardInputReport = "0x2A22"
    case BootKeyboardOutputReport = "0x2A32"
    case BootMouseInputReport = "0x2A33"
    case CentralAddressResolution = "0x2AA6"
    case CGMFeature = "0x2AA8"
    case CGMMeasurement = "0x2AA7"
    case CGMSessionRunTime = "0x2AAB"
    case CGMSessionStartTime = "0x2AAA"
    case CGMSpecificOpsControlPoint = "0x2AAC"
    case CGMStatus = "0x2AA9"
    case CSCFeature = "0x2A5C"
    case CSCMeasurement = "0x2A5B"
    case CurrentTime = "0x2A2B"
    case CyclingPowerControlPoint = "0x2A66"
    case CyclingPowerFeature = "0x2A65"
    case CyclingPowerMeasurement = "0x2A63"
    case CyclingPowerVector = "0x2A64"
    case DatabaseChangeIncrement = "0x2A99"
    case DateofBirth = "0x2A85"
    case DateofThresholdAssessment = "0x2A86"
    case DateTime = "0x2A08"
    case DayDateTime = "0x2A0A"
    case DayofWeek = "0x2A09"
    case DescriptorValueChanged = "0x2A7D"
    case DeviceName = "0x2A00"
    case DewPoint = "0x2A7B"
    case Digital = "0x2A56"
    case DSTOffset = "0x2A0D"
    case Elevation = "0x2A6C"
    case EmailAddress = "0x2A87"
    case ExactTime256 = "0x2A0C"
    case FatBurnHeartRateLowerLimit = "0x2A88"
    case FatBurnHeartRateUpperLimit = "0x2A89"
    case FirmwareRevisionString = "0x2A26"
    case FirstName = "0x2A8A"
    case FiveZoneHeartRateLimits = "0x2A8B"
    case FloorNumber = "0x2AB2"
    case Gender = "0x2A8C"
    case GlucoseFeature = "0x2A51"
    case GlucoseMeasurement = "0x2A18"
    case GlucoseMeasurementContext = "0x2A34"
    case GustFactor = "0x2A74"
    case HardwareRevisionString = "0x2A27"
    case HeartRateControlPoint = "0x2A39"
    case HeartRateMax = "0x2A8D"
    case HeartRateMeasurement = "0x2A37"
    case HeatIndex = "0x2A7A"
    case Height = "0x2A8E"
    case HIDControlPoint = "0x2A4C"
    case HIDInformation = "0x2A4A"
    case HipCircumference = "0x2A8F"
    case HTTPControlPoint = "0x2ABA"
    case HTTPEntityBody = "0x2AB9"
    case HTTPHeaders = "0x2AB7"
    case HTTPStatusCode = "0x2AB8"
    case HTTPSSecurity = "0x2ABB"
    case Humidity = "0x2A6F"
    case IEEE1107320601RegulatoryCertificationDataList = "0x2A2A"
    case IndoorPositioningConfiguration = "0x2AAD"
    case IntermediateCuffPressure = "0x2A36"
    case IntermediateTemperature = "0x2A1E"
    case Irradiance = "0x2A77"
    case Language = "0x2AA2"
    case LastName = "0x2A90"
    case Latitude = "0x2AAE"
    case LNControlPoint = "0x2A6B"
    case LNFeature = "0x2A6A"
    case LocalEastCoordinate = "0x2AB1"
    case LocalNorthCoordinate = "0x2AB0"
    case LocalTimeInformation = "0x2A0F"
    case LocationandSpeed = "0x2A67"
    case LocationName = "0x2AB5"
    case Longitude = "0x2AAF"
    case MagneticDeclination = "0x2A2C"
    case MagneticFluxDensity2D = "0x2AA0"
    case MagneticFluxDensity3D = "0x2AA1"
    case ManufacturerNameString = "0x2A29"
    case MaximumRecommendedHeartRate = "0x2A91"
    case MeasurementInterval = "0x2A21"
    case ModelNumberString = "0x2A24"
    case Navigation = "0x2A68"
    case NewAlert = "0x2A46"
    case ObjectActionControlPoint = "0x2AC5"
    case ObjectChanged = "0x2AC8"
    case ObjectFirstCreated = "0x2AC1"
    case ObjectID = "0x2AC3"
    case ObjectLastModified = "0x2AC2"
    case ObjectListControlPoint = "0x2AC6"
    case ObjectListFilter = "0x2AC7"
    case ObjectName = "0x2ABE"
    case ObjectProperties = "0x2AC4"
    case ObjectSize = "0x2AC0"
    case ObjectType = "0x2ABF"
    case OTSFeature = "0x2ABD"
    case PeripheralPreferredConnectionParameters = "0x2A04"
    case PeripheralPrivacyFlag = "0x2A02"
    case PLXContinuousMeasurement = "0x2A5F"
    case PLXFeatures = "0x2A60"
    case PLXSpotCheckMeasurement = "0x2A5E"
    case PnPID = "0x2A50"
    case PollenConcentration = "0x2A75"
    case PositionQuality = "0x2A69"
    case Pressure = "0x2A6D"
    case ProtocolMode = "0x2A4E"
    case Rainfall = "0x2A78"
    case ReconnectionAddress = "0x2A03"
    case RecordAccessControlPoint = "0x2A52"
    case ReferenceTimeInformation = "0x2A14"
    case Report = "0x2A4D"
    case ReportMap = "0x2A4B"
    case RestingHeartRate = "0x2A92"
    case RingerControlPoint = "0x2A40"
    case RingerSetting = "0x2A41"
    case RSCFeature = "0x2A54"
    case RSCMeasurement = "0x2A53"
    case SCControlPoint = "0x2A55"
    case ScanIntervalWindow = "0x2A4F"
    case ScanRefresh = "0x2A31"
    case SensorLocation = "0x2A5D"
    case SerialNumberString = "0x2A25"
    case ServiceChanged = "0x2A05"
    case SoftwareRevisionString = "0x2A28"
    case SportTypeforAerobicandAnaerobicThresholds = "0x2A93"
    case SupportedNewAlertCategory = "0x2A47"
    case SupportedUnreadAlertCategory = "0x2A48"
    case SystemID = "0x2A23"
    case TDSControlPoint = "0x2ABC"
    case Temperature = "0x2A6E"
    case TemperatureMeasurement = "0x2A1C"
    case TemperatureType = "0x2A1D"
    case ThreeZoneHeartRateLimits = "0x2A94"
    case TimeAccuracy = "0x2A12"
    case TimeSource = "0x2A13"
    case TimeUpdateControlPoint = "0x2A16"
    case TimeUpdateState = "0x2A17"
    case TimewithDST = "0x2A11"
    case TimeZone = "0x2A0E"
    case TrueWindDirection = "0x2A71"
    case TrueWindSpeed = "0x2A70"
    case TwoZoneHeartRateLimit = "0x2A95"
    case TxPowerLevel = "0x2A07"
    case Uncertainty = "0x2AB4"
    case UnreadAlertStatus = "0x2A45"
    case URI = "0x2AB6"
    case UserControlPoint = "0x2A9F"
    case UserIndex = "0x2A9A"
    case UVIndex = "0x2A76"
    case VO2Max = "0x2A96"
    case WaistCircumference = "0x2A97"
    case Weight = "0x2A98"
    case WeightMeasurement = "0x2A9D"
    case WeightScaleFeature = "0x2A9E"
    case WindChill = "0x2A79"
    
    private static let meta:[String: (description:String, specification:String)] = [
        "0x2A7E":("Aerobic Heart Rate Lower Limit","org.bluetooth.characteristic.aerobic_heart_rate_lower_limit"),
        "0x2A84":("Aerobic Heart Rate Upper Limit","org.bluetooth.characteristic.aerobic_heart_rate_upper_limit"),
        "0x2A7F":("Aerobic Threshold","org.bluetooth.characteristic.aerobic_threshold"),
        "0x2A80":("Age","org.bluetooth.characteristic.age"),
        "0x2A5A":("Aggregate","org.bluetooth.characteristic.aggregate"),
        "0x2A43":("Alert Category ID","org.bluetooth.characteristic.alert_category_id"),
        "0x2A42":("Alert Category ID Bit Mask","org.bluetooth.characteristic.alert_category_id_bit_mask"),
        "0x2A06":("Alert Level","org.bluetooth.characteristic.alert_level"),
        "0x2A44":("Alert Notification Control Point","org.bluetooth.characteristic.alert_notification_control_point"),
        "0x2A3F":("Alert Status","org.bluetooth.characteristic.alert_status"),
        "0x2AB3":("Altitude","org.bluetooth.characteristic.altitude"),
        "0x2A81":("Anaerobic Heart Rate Lower Limit","org.bluetooth.characteristic.anaerobic_heart_rate_lower_limit"),
        "0x2A82":("Anaerobic Heart Rate Upper Limit","org.bluetooth.characteristic.anaerobic_heart_rate_upper_limit"),
        "0x2A83":("Anaerobic Threshold","org.bluetooth.characteristic.anaerobic_threshold"),
        "0x2A58":("Analog","org.bluetooth.characteristic.analog"),
        "0x2A73":("Apparent Wind Direction","org.bluetooth.characteristic.apparent_wind_direction"),
        "0x2A72":("Apparent Wind Speed","org.bluetooth.characteristic.apparent_wind_speed"),
        "0x2A01":("Appearance","org.bluetooth.characteristic.gap.appearance"),
        "0x2AA3":("Barometric Pressure Trend","org.bluetooth.characteristic.barometric_pressure_trend"),
        "0x2A19":("Battery Level","org.bluetooth.characteristic.battery_level"),
        "0x2A49":("Blood Pressure Feature","org.bluetooth.characteristic.blood_pressure_feature"),
        "0x2A35":("Blood Pressure Measurement","org.bluetooth.characteristic.blood_pressure_measurement"),
        "0x2A9B":("Body Composition Feature","org.bluetooth.characteristic.body_composition_feature"),
        "0x2A9C":("Body Composition Measurement","org.bluetooth.characteristic.body_composition_measurement"),
        "0x2A38":("Body Sensor Location","org.bluetooth.characteristic.body_sensor_location"),
        "0x2AA4":("Bond Management Control Point","org.bluetooth.characteristic.bond_management_control_point"),
        "0x2AA5":("Bond Management Feature","org.bluetooth.characteristic.bond_management_feature"),
        "0x2A22":("Boot Keyboard Input Report","org.bluetooth.characteristic.boot_keyboard_input_report"),
        "0x2A32":("Boot Keyboard Output Report","org.bluetooth.characteristic.boot_keyboard_output_report"),
        "0x2A33":("Boot Mouse Input Report","org.bluetooth.characteristic.boot_mouse_input_report"),
        "0x2AA6":("Central Address Resolution","org.bluetooth.characteristic.gap.central_address_resolution_support"),
        "0x2AA8":("CGM Feature","org.bluetooth.characteristic.cgm_feature"),
        "0x2AA7":("CGM Measurement","org.bluetooth.characteristic.cgm_measurement"),
        "0x2AAB":("CGM Session Run Time","org.bluetooth.characteristic.cgm_session_run_time"),
        "0x2AAA":("CGM Session Start Time","org.bluetooth.characteristic.cgm_session_start_time"),
        "0x2AAC":("CGM Specific Ops Control Point","org.bluetooth.characteristic.cgm_specific_ops_control_point"),
        "0x2AA9":("CGM Status","org.bluetooth.characteristic.cgm_status"),
        "0x2A5C":("CSC Feature","org.bluetooth.characteristic.csc_feature"),
        "0x2A5B":("CSC Measurement","org.bluetooth.characteristic.csc_measurement"),
        "0x2A2B":("Current Time","org.bluetooth.characteristic.current_time"),
        "0x2A66":("Cycling Power Control Point","org.bluetooth.characteristic.cycling_power_control_point"),
        "0x2A65":("Cycling Power Feature","org.bluetooth.characteristic.cycling_power_feature"),
        "0x2A63":("Cycling Power Measurement","org.bluetooth.characteristic.cycling_power_measurement"),
        "0x2A64":("Cycling Power Vector","org.bluetooth.characteristic.cycling_power_vector"),
        "0x2A99":("Database Change Increment","org.bluetooth.characteristic.database_change_increment"),
        "0x2A85":("Date of Birth","org.bluetooth.characteristic.date_of_birth"),
        "0x2A86":("Date of Threshold Assessment","org.bluetooth.characteristic.date_of_threshold_assessment"),
        "0x2A08":("Date Time","org.bluetooth.characteristic.date_time"),
        "0x2A0A":("Day Date Time","org.bluetooth.characteristic.day_date_time"),
        "0x2A09":("Day of Week","org.bluetooth.characteristic.day_of_week"),
        "0x2A7D":("Descriptor Value Changed","org.bluetooth.characteristic.descriptor_value_changed"),
        "0x2A00":("Device Name","org.bluetooth.characteristic.gap.device_name"),
        "0x2A7B":("Dew Point","org.bluetooth.characteristic.dew_point"),
        "0x2A56":("Digital","org.bluetooth.characteristic.digital"),
        "0x2A0D":("DST Offset","org.bluetooth.characteristic.dst_offset"),
        "0x2A6C":("Elevation","org.bluetooth.characteristic.elevation"),
        "0x2A87":("Email Address","org.bluetooth.characteristic.email_address"),
        "0x2A0C":("Exact Time 256","org.bluetooth.characteristic.exact_time_256"),
        "0x2A88":("Fat Burn Heart Rate Lower Limit","org.bluetooth.characteristic.fat_burn_heart_rate_lower_limit"),
        "0x2A89":("Fat Burn Heart Rate Upper Limit","org.bluetooth.characteristic.fat_burn_heart_rate_upper_limit"),
        "0x2A26":("Firmware Revision String","org.bluetooth.characteristic.firmware_revision_string"),
        "0x2A8A":("First Name","org.bluetooth.characteristic.first_name"),
        "0x2A8B":("Five Zone Heart Rate Limits","org.bluetooth.characteristic.five_zone_heart_rate_limits"),
        "0x2AB2":("Floor Number","org.bluetooth.characteristic.floor_number"),
        "0x2A8C":("Gender","org.bluetooth.characteristic.gender"),
        "0x2A51":("Glucose Feature","org.bluetooth.characteristic.glucose_feature"),
        "0x2A18":("Glucose Measurement","org.bluetooth.characteristic.glucose_measurement"),
        "0x2A34":("Glucose Measurement Context","org.bluetooth.characteristic.glucose_measurement_context"),
        "0x2A74":("Gust Factor","org.bluetooth.characteristic.gust_factor"),
        "0x2A27":("Hardware Revision String","org.bluetooth.characteristic.hardware_revision_string"),
        "0x2A39":("Heart Rate Control Point","org.bluetooth.characteristic.heart_rate_control_point"),
        "0x2A8D":("Heart Rate Max","org.bluetooth.characteristic.heart_rate_max"),
        "0x2A37":("Heart Rate Measurement","org.bluetooth.characteristic.heart_rate_measurement"),
        "0x2A7A":("Heat Index","org.bluetooth.characteristic.heat_index"),
        "0x2A8E":("Height","org.bluetooth.characteristic.height"),
        "0x2A4C":("HID Control Point","org.bluetooth.characteristic.hid_control_point"),
        "0x2A4A":("HID Information","org.bluetooth.characteristic.hid_information"),
        "0x2A8F":("Hip Circumference","org.bluetooth.characteristic.hip_circumference"),
        "0x2ABA":("HTTP Control Point","org.bluetooth.characteristic.http_control_point"),
        "0x2AB9":("HTTP Entity Body","org.bluetooth.characteristic.http_entity_body"),
        "0x2AB7":("HTTP Headers","org.bluetooth.characteristic.http_headers"),
        "0x2AB8":("HTTP Status Code","org.bluetooth.characteristic.http_status_code"),
        "0x2ABB":("HTTPS Security","org.bluetooth.characteristic.https_security"),
        "0x2A6F":("Humidity","org.bluetooth.characteristic.humidity"),
        "0x2A2A":("IEEE 11073-20601 Regulatory Certification Data List","org.bluetooth.characteristic.ieee_11073-20601_regulatory_certification_data_list"),
        "0x2AAD":("Indoor Positioning Configuration","org.bluetooth.characteristic.indoor_positioning_configuration"),
        "0x2A36":("Intermediate Cuff Pressure","org.bluetooth.characteristic.intermediate_cuff_pressure"),
        "0x2A1E":("Intermediate Temperature","org.bluetooth.characteristic.intermediate_temperature"),
        "0x2A77":("Irradiance","org.bluetooth.characteristic.irradiance"),
        "0x2AA2":("Language","org.bluetooth.characteristic.language"),
        "0x2A90":("Last Name","org.bluetooth.characteristic.last_name"),
        "0x2AAE":("Latitude","org.bluetooth.characteristic.latitude"),
        "0x2A6B":("LN Control Point","org.bluetooth.characteristic.ln_control_point"),
        "0x2A6A":("LN Feature","org.bluetooth.characteristic.ln_feature"),
        "0x2AB1":("Local East Coordinate","org.bluetooth.characteristic.local_east_coordinate"),
        "0x2AB0":("Local North Coordinate","org.bluetooth.characteristic.local_north_coordinate"),
        "0x2A0F":("Local Time Information","org.bluetooth.characteristic.local_time_information"),
        "0x2A67":("Location and Speed","org.bluetooth.characteristic.location_and_speed"),
        "0x2AB5":("Location Name","org.bluetooth.characteristic.location_name"),
        "0x2AAF":("Longitude","org.bluetooth.characteristic.longitude"),
        "0x2A2C":("Magnetic Declination","org.bluetooth.characteristic.magnetic_declination"),
        "0x2AA0":("Magnetic Flux Density - 2D","org.bluetooth.characteristic.magnetic_flux_density_2D"),
        "0x2AA1":("Magnetic Flux Density - 3D","org.bluetooth.characteristic.magnetic_flux_density_3D"),
        "0x2A29":("Manufacturer Name String","org.bluetooth.characteristic.manufacturer_name_string"),
        "0x2A91":("Maximum Recommended Heart Rate","org.bluetooth.characteristic.maximum_recommended_heart_rate"),
        "0x2A21":("Measurement Interval","org.bluetooth.characteristic.measurement_interval"),
        "0x2A24":("Model Number String","org.bluetooth.characteristic.model_number_string"),
        "0x2A68":("Navigation","org.bluetooth.characteristic.navigation"),
        "0x2A46":("New Alert","org.bluetooth.characteristic.new_alert"),
        "0x2AC5":("Object Action Control Point","org.bluetooth.characteristic.object_action_control_point"),
        "0x2AC8":("Object Changed","org.bluetooth.characteristic.object_changed"),
        "0x2AC1":("Object First-Created","org.bluetooth.characteristic.object_first_created"),
        "0x2AC3":("Object ID","org.bluetooth.characteristic.object_id"),
        "0x2AC2":("Object Last-Modified","org.bluetooth.characteristic.object_last_modified"),
        "0x2AC6":("Object List Control Point","org.bluetooth.characteristic.object_list_control_point"),
        "0x2AC7":("Object List Filter","org.bluetooth.characteristic.object_list_filter"),
        "0x2ABE":("Object Name","org.bluetooth.characteristic.object_name"),
        "0x2AC4":("Object Properties","org.bluetooth.characteristic.object_properties"),
        "0x2AC0":("Object Size","org.bluetooth.characteristic.object_size"),
        "0x2ABF":("Object Type","org.bluetooth.characteristic.object_type"),
        "0x2ABD":("OTS Feature","org.bluetooth.characteristic.ots_feature"),
        "0x2A04":("Peripheral Preferred Connection Parameters","org.bluetooth.characteristic.gap.peripheral_preferred_connection_parameters"),
        "0x2A02":("Peripheral Privacy Flag","org.bluetooth.characteristic.gap.peripheral_privacy_flag"),
        "0x2A5F":("PLX Continuous Measurement","org.bluetooth.characteristic.plx_continuous_measurement"),
        "0x2A60":("PLX Features","org.bluetooth.characteristic.plx_features"),
        "0x2A5E":("PLX Spot-Check Measurement","org.bluetooth.characteristic.plx_spot_check_measurement"),
        "0x2A50":("PnP ID","org.bluetooth.characteristic.pnp_id"),
        "0x2A75":("Pollen Concentration","org.bluetooth.characteristic.pollen_concentration"),
        "0x2A69":("Position Quality","org.bluetooth.characteristic.position_quality"),
        "0x2A6D":("Pressure","org.bluetooth.characteristic.pressure"),
        "0x2A4E":("Protocol Mode","org.bluetooth.characteristic.protocol_mode"),
        "0x2A78":("Rainfall","org.bluetooth.characteristic.rainfall"),
        "0x2A03":("Reconnection Address","org.bluetooth.characteristic.gap.reconnection_address"),
        "0x2A52":("Record Access Control Point","org.bluetooth.characteristic.record_access_control_point"),
        "0x2A14":("Reference Time Information","org.bluetooth.characteristic.reference_time_information"),
        "0x2A4D":("Report","org.bluetooth.characteristic.report"),
        "0x2A4B":("Report Map","org.bluetooth.characteristic.report_map"),
        "0x2A92":("Resting Heart Rate","org.bluetooth.characteristic.resting_heart_rate"),
        "0x2A40":("Ringer Control Point","org.bluetooth.characteristic.ringer_control_point"),
        "0x2A41":("Ringer Setting","org.bluetooth.characteristic.ringer_setting"),
        "0x2A54":("RSC Feature","org.bluetooth.characteristic.rsc_feature"),
        "0x2A53":("RSC Measurement","org.bluetooth.characteristic.rsc_measurement"),
        "0x2A55":("SC Control Point","org.bluetooth.characteristic.sc_control_point"),
        "0x2A4F":("Scan Interval Window","org.bluetooth.characteristic.scan_interval_window"),
        "0x2A31":("Scan Refresh","org.bluetooth.characteristic.scan_refresh"),
        "0x2A5D":("Sensor Location","org.blueooth.characteristic.sensor_location"),
        "0x2A25":("Serial Number String","org.bluetooth.characteristic.serial_number_string"),
        "0x2A05":("Service Changed","org.bluetooth.characteristic.gatt.service_changed"),
        "0x2A28":("Software Revision String","org.bluetooth.characteristic.software_revision_string"),
        "0x2A93":("Sport Type for Aerobic and Anaerobic Thresholds","org.bluetooth.characteristic.sport_type_for_aerobic_and_anaerobic_thresholds"),
        "0x2A47":("Supported New Alert Category","org.bluetooth.characteristic.supported_new_alert_category"),
        "0x2A48":("Supported Unread Alert Category","org.bluetooth.characteristic.supported_unread_alert_category"),
        "0x2A23":("System ID","org.bluetooth.characteristic.system_id"),
        "0x2ABC":("TDS Control Point","org.bluetooth.characteristic.tds_control_point"),
        "0x2A6E":("Temperature","org.bluetooth.characteristic.temperature"),
        "0x2A1C":("Temperature Measurement","org.bluetooth.characteristic.temperature_measurement"),
        "0x2A1D":("Temperature Type","org.bluetooth.characteristic.temperature_type"),
        "0x2A94":("Three Zone Heart Rate Limits","org.bluetooth.characteristic.three_zone_heart_rate_limits"),
        "0x2A12":("Time Accuracy","org.bluetooth.characteristic.time_accuracy"),
        "0x2A13":("Time Source","org.bluetooth.characteristic.time_source"),
        "0x2A16":("Time Update Control Point","org.bluetooth.characteristic.time_update_control_point"),
        "0x2A17":("Time Update State","org.bluetooth.characteristic.time_update_state"),
        "0x2A11":("Time with DST","org.bluetooth.characteristic.time_with_dst"),
        "0x2A0E":("Time Zone","org.bluetooth.characteristic.time_zone"),
        "0x2A71":("True Wind Direction","org.bluetooth.characteristic.true_wind_direction"),
        "0x2A70":("True Wind Speed","org.bluetooth.characteristic.true_wind_speed"),
        "0x2A95":("Two Zone Heart Rate Limit","org.bluetooth.characteristic.two_zone_heart_rate_limit"),
        "0x2A07":("Tx Power Level","org.bluetooth.characteristic.tx_power_level"),
        "0x2AB4":("Uncertainty","org.bluetooth.characteristic.uncertainty"),
        "0x2A45":("Unread Alert Status","org.bluetooth.characteristic.unread_alert_status"),
        "0x2AB6":("URI","org.bluetooth.characteristic.uri"),
        "0x2A9F":("User Control Point","org.bluetooth.characteristic.user_control_point"),
        "0x2A9A":("User Index","org.bluetooth.characteristic.user_index"),
        "0x2A76":("UV Index","org.bluetooth.characteristic.uv_index"),
        "0x2A96":("VO2 Max","org.bluetooth.characteristic.vo2_max"),
        "0x2A97":("Waist Circumference","org.bluetooth.characteristic.waist_circumference"),
        "0x2A98":("Weight","org.bluetooth.characteristic.weight"),
        "0x2A9D":("Weight Measurement","org.bluetooth.characteristic.weight_measurement"),
        "0x2A9E":("Weight Scale Feature","org.bluetooth.characteristic.weight_scale_feature"),
        "0x2A79":("Wind Chill","org.bluetooth.characteristic.wind_chill")
    ]
    
    public var description:String {
        get {
            guard let value = KurmaBluetoothGATTCharacteristices.meta[self.rawValue] else {
                return ""
            }
            return value.description
        }
    }
    
    public var specification:String {
        get {
            guard let value = KurmaBluetoothGATTCharacteristices.meta[self.rawValue] else {
                return ""
            }
            return value.specification
        }
    }
    
    public var UUID:CBUUID {
        get {
            return CBUUID(string: self.rawValue)
        }
    }
}