#include <anotherone_ble/anotherone_ble_plugin.h>
#include <flutter/method-channel.h>
#include <sys/utsname.h>

#include <memory>
#include <functional>
#include <simplebluez/Bluez.h>
#include <vector>
#include <string>
#include <sstream>
#include <atomic>
#include <chrono>
#include <thread>


SimpleBluez::Bluez bluez;

std::atomic_bool async_thread_active = true;
void async_thread_function() {
    while (async_thread_active) {
        bluez.run_async();
        std::this_thread::sleep_for(std::chrono::microseconds(100));
    }
}

void millisecond_delay(int ms) {
    for (int i = 0; i < ms; i++) {
        std::this_thread::sleep_for(std::chrono::milliseconds(1));
    }
}


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
private:
    SimpleBluez::Bluez m_bluez;
    std::shared_ptr<SimpleBluez::Adapter> m_adapter;
    std::vector<std::shared_ptr<SimpleBluez::Adapter>> m_adapters;
    std::vector<std::string> m_adapters_vector;
    std::vector<std::string> m_paired_vector;

public:
    BluetoothAdapter() {
        bluez.init();
        //getIdentifier
        m_adapter = bluez.get_adapters().at(0);
        std::cout << "Adapter info: " << m_adapter->identifier() << " " << m_adapter->address() << std::endl;
        //getAdapters and Paired List
        auto adaptersList = bluez.get_adapters();
        for (auto& adapter : adaptersList) {
            m_adapters_vector.push_back(adapter->identifier());

            auto paired_list = adapter->device_paired_get();
            for (auto& device : paired_list) {
                m_paired_vector.push_back(device->name()+ '/' + device->address());
            }
        }


    }

    bool checkPoweredStatus() {
        return m_adapter.get() != nullptr && m_adapter->powered();
    }

    std::string getIdentifier() const {
        return m_adapter->identifier();
    }

    std::string getAddress() const {
       
        return m_adapter->address();
    }
 
    std::vector<std::string> getAdapters() const{
        return m_adapters_vector;
    }

    std::vector<std::string> getPaired() const{
        return m_paired_vector;
    }
};



void AnotheroneBlePlugin::RegisterWithRegistrar (PluginRegistrar &registrar)
{
    registrar.RegisterMethodChannel("anotherone_ble_methods",
                                    MethodCodecType::Standard,
                                    [this](const MethodCall &call) { this->onMethodCall(call); });
    
    registrar.RegisterEventChannel("anotherone_ble_event_scanning",
                                    MethodCodecType::Standard,
                                    [this](const Encodable &) {
                                        this->onListen();
                                        return EventResponse();
                                    },
                                    [this](const Encodable &) {
                                        this->onCancel();
                                        return EventResponse();
                                    }
                                    );
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
    } else if (method == "getPairedList"){
        onGetPairedList(call);
        return;
    }  else if (method == "startScanning"){
        onStartScanning(call);
        return;
    }

    unimplemented(call);
}

void AnotheroneBlePlugin::onListen()
{
    std::thread* async_thread = new std::thread(async_thread_function);

    auto adapter = bluez.get_adapters().at(0);

    //SimpleBluez::Adapter::DiscoveryFilter filter;
    //filter.Transport = SimpleBluez::Adapter::DiscoveryFilter::TransportType::LE;
    //adapter->discovery_filter(filter);


    adapter->set_on_device_updated([&](std::shared_ptr<SimpleBluez::Device> device) {
        std::string scannedDevice;
        scannedDevice = device->address() + "/" + device->name() + "/" +  std::to_string(device->rssi()) + "&";
        //std::cout << "Update received for " << device->address() std::endl;
        //std::cout << "\tName " << device->name() << std::endl;
        //std::cout << "\tRSSI " << std::dec << device->rssi() << std::endl;
        AnotheroneBlePlugin::sendScannedUpdate(scannedDevice);
    });
    
    adapter->discovery_start();
    //millisecond_delay(30000);
    //adapter->discovery_stop();
//
    //// Sleep for a bit to allow the adapter to stop discovering.
    //millisecond_delay(1000);
//
    //async_thread_active = false;
    //while (!async_thread->joinable()) {
    //    millisecond_delay(10);
    //}
    //async_thread->join();
    //delete async_thread;

}

void AnotheroneBlePlugin::onCancel(){
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
    std::vector<std::string> m_adapters_vector = adapter.getAdapters();
    std::string adaptersString =  vectorToString(m_adapters_vector, '&');

    call.SendSuccessResponse(adaptersString);
}

void AnotheroneBlePlugin::onGetPairedList(const MethodCall &call)
{
    BluetoothAdapter adapter;
    std::vector<std::string> m_paired_vector = adapter.getPaired();
    std::string pairedString =  vectorToString(m_paired_vector, '&');

    call.SendSuccessResponse(pairedString);
}

void AnotheroneBlePlugin::onStartScanning(const MethodCall &call)
{
    AnotheroneBlePlugin::onListen();
}

void AnotheroneBlePlugin::sendScannedUpdate(std::string scannedDevice){
     EventChannel("anotherone_ble_event_scanning", MethodCodecType::Standard).SendEvent(scannedDevice);
}


void AnotheroneBlePlugin::unimplemented(const MethodCall &call)
{
    call.SendSuccessResponse(nullptr);
}