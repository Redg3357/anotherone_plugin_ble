#include <anotherone_ble/anotherone_ble_plugin.h>
#include <flutter/method-channel.h>
#include <sys/utsname.h>

#include <iostream>
#include <memory>
#include <functional>
#include <simplebluez/Bluez.h>
#include <vector>
#include <string>
#include <sstream>


std::string vectorToString(const std::vector<std::string>& vec, const char delimiter) {
    std::ostringstream oss;
    for (size_t i = 0; i < vec.size(); ++i) {
        oss << vec[i];
        // Если элемент не последний, добавляем разделитель
        if (i < vec.size() - 1) {
            oss << delimiter;
        }
    }
    return oss.str();
}

class BluetoothAdapter {
public:
    BluetoothAdapter() {
        m_bluez.init();
        if (!m_bluez.get_adapters().empty()) {
            m_adapter = m_bluez.get_adapters().at(0);
            std::cout << "Adapter info: " << m_adapter->identifier() << " " << m_adapter->address() << std::endl;

            auto adaptersList = m_bluez.get_adapters();
            for (auto& adapter : adaptersList) {
                adaptersVector.push_back(adapter->identifier());
            }
        }
    }

    //bool powered() const {
    //    return m_adapter.get() != nullptr && m_adapter->powered();
    //}

    bool checkPoweredStatus() {
        return m_adapter.get() != nullptr && m_adapter->powered();
    }

     std::string getIdentifier() const {
        if (m_adapter) {
            return m_adapter->identifier();
        } else {
            return "not found"; 
        }
    }

         std::string getAddress() const {
        if (m_adapter) {
            return m_adapter->address();
        } else {
            return "not found"; 
        }
    }
 
    std::vector<std::string> getAdapters() const{
        return adaptersVector;
    }

private:
    SimpleBluez::Bluez m_bluez;
    std::shared_ptr<SimpleBluez::Adapter> m_adapter;
    std::vector<std::shared_ptr<SimpleBluez::Adapter>> m_adapters;
    std::vector<std::string> adaptersVector;
};




void AnotheroneBlePlugin::RegisterWithRegistrar(PluginRegistrar &registrar)
{
    registrar.RegisterMethodChannel("anotherone_ble",
                                    MethodCodecType::Standard,
                                    [this](const MethodCall &call) { this->onMethodCall(call); });
}

void AnotheroneBlePlugin::onMethodCall(const MethodCall &call)
{
    //SimpleBluez::Bluez bluez;
    //bluez.init();

    const auto &method = call.GetMethod();

    if (method == "getAdapterPowered") {
        onGetAdapterPowered(call);
        return;
    } else if (method == "getAdapterIdentifier"){
        onGetAdapterIdentifier(call);
        return;
    } else if (method == "getAdaptersList"){
        onGetAdaptersList(call);
        return;
    }

    unimplemented(call);
}

void AnotheroneBlePlugin::onGetAdapterPowered(const MethodCall &call)
{
    BluetoothAdapter adapter;
    bool adapterPowered = adapter.checkPoweredStatus();

    call.SendSuccessResponse(adapterPowered);
}


void AnotheroneBlePlugin::onGetAdapterIdentifier(const MethodCall &call)
{
    BluetoothAdapter adapter;
    std::string identifier = adapter.getIdentifier();
    std::string address = adapter.getAddress();
    std::string identifierAndAddress = identifier + "/" + address;
    
    call.SendSuccessResponse(identifierAndAddress);
}

void AnotheroneBlePlugin::onGetAdaptersList(const MethodCall &call)
{
    BluetoothAdapter adapter;
    std::vector<std::string> adaptersVector = adapter.getAdapters();
    std::string adaptersString =  vectorToString(adaptersVector, '&');

    call.SendSuccessResponse(adaptersString);
}

void AnotheroneBlePlugin::unimplemented(const MethodCall &call)
{
    call.SendSuccessResponse(nullptr);
}