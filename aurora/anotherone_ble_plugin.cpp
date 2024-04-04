#include <anotherone_ble/anotherone_ble_plugin.h>
#include <flutter/method-channel.h>
#include <sys/utsname.h>

#include <iostream>
#include <memory>
#include <functional>
#include <simplebluez/Bluez.h>
// //////////////////////////////////////
// class BluetoothAdapter {
// public:
//     BluetoothAdapter() {
//         m_bluez.init();
//         if (!m_bluez.get_adapters().empty()) {
//             m_adapter = m_bluez.get_adapters().at(0);
//             std::cout << "Adapter info: " << m_adapter->identifier() << " " << m_adapter->address() << std::endl;
//         }
//     }

//     bool powered() const {
//         return m_adapter.get() != nullptr && m_adapter->powered();
//     }


//     std::string checkPoweredStatus() {
//         if (powered()) {
//             return "Bluetooth adapter is powered on.";
//         } else {
//             return "Bluetooth adapter is powered off.";
//         }
//     }

// private:
//     SimpleBluez::Bluez m_bluez;
//     std::shared_ptr<SimpleBluez::Adapter> m_adapter;
// };

// ///////////////////////////////////////

void BlePluginPcPlugin::RegisterWithRegistrar(PluginRegistrar &registrar)
{
    registrar.RegisterMethodChannel("anotherone_ble",
                                    MethodCodecType::Standard,
                                    [this](const MethodCall &call) { this->onMethodCall(call); });
}
 
void BlePluginPcPlugin::onMethodCall(const MethodCall &call)
{
    SimpleBluez::Bluez bluez;
    bluez.init();

    const auto &method = call.GetMethod();

    if (method == "getPlatformVersion") {
        onGetPlatformVersion(call);
        return;
    }

    unimplemented(call);
}

void BlePluginPcPlugin::onGetPlatformVersion(const MethodCall &call)
{
    ////////////////Bluez///////////////
    // BluetoothAdapter adapter;
    // std::string version = adapter.checkPoweredStatus();
    ///////////////////////////////
    // utsname uname_data{};
    // uname(&uname_data);

    // std::string preamble = "Aurora (Linux): ";
    // std::string version = preamble + uname_data.version;

    // call.SendSuccessResponse(version);
}

void BlePluginPcPlugin::unimplemented(const MethodCall &call)
{
    call.SendSuccessResponse(nullptr);
}
