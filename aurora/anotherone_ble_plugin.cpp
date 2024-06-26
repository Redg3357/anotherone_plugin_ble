#include <anotherone_ble/anotherone_ble_plugin.h>
#include <flutter/method-channel.h>
#include <sys/utsname.h>


namespace Channel {
    constexpr auto Methods = "anotherone_ble_methods";
    constexpr auto Event = "anotherone_ble_event_scanning";
}

//SimpleBluez::Bluez m_bluez;

AnotheroneBlePlugin::AnotheroneBlePlugin()
    : m_sendEvents(false),
    async_thread_active(false),
    async_thread(nullptr),
    is_listening(false)
{
    m_bluez.init();
    m_adapter = m_bluez.get_adapters().at(0);
}

AnotheroneBlePlugin::~AnotheroneBlePlugin()
{
    async_thread->join();
    printf("c++: Thread joined\n");
    async_thread.reset();
    printf("c++: Thread deleted\n");
    async_thread_active = false;
}

void AnotheroneBlePlugin::RegisterWithRegistrar (PluginRegistrar &registrar)
{
    registrar.RegisterMethodChannel(Channel::Methods,
                                    MethodCodecType::Standard,
                                    [this](const MethodCall &call) { this->onMethodCall(call); });

    registrar.RegisterEventChannel(Channel::Event,
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
    const auto &method = call.GetMethod();

    if (method == "getAdapterPowered") {
        onGetAdapterPowered(call);
        return;
    } else if (method == "getAdapterIdentifier"){
        onGetAdapterIdentifier(call);
        return;
    } else if (method == "getAdapterDiscovering"){
        onGetAdapterDiscovering(call);
        return;
    } else if (method == "getPairedList"){
        onGetPairedList(call);
        return;
    //} else if (method == "stopScanning"){
    //    onStopScanning(call);
    //    return;
    } else if (method == "deviceConnect"){
        onDeviceConnect(call);
        return;
    } else if (method == "clearScanned"){
        onClearScanned(call);
        return;
    }

    unimplemented(call);
}


void AnotheroneBlePlugin::async_thread_function() {
    while (async_thread_active) {
        m_bluez.run_async();
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

void AnotheroneBlePlugin::onListen()
{
    printf("c++: trying scanning......\n");
    if (!m_sendEvents) {
        async_thread_active = true;
        async_thread = std::make_unique<std::thread>([this] { this->async_thread_function(); }); // dangling pointer

        //SimpleBluez::Adapter::DiscoveryFilter filter;
        //filter.Transport = SimpleBluez::Adapter::DiscoveryFilter::TransportType::LE;
        //filter.RSSI = -10;
        //m_adapter->discovery_filter(filter);

        m_adapter->discovery_start();

        m_adapter->set_on_device_updated([&](std::shared_ptr<SimpleBluez::Device> device) {
            printf("set_on_device_updated\n");
            std::string deviceAddress = device->address();


            auto it = scannedDevices.find(deviceAddress);
            if (it == scannedDevices.end())
            {
                scannedDevices.insert({deviceAddress,device});
                std::string scannedDevice = deviceAddress + "/" + device->name() + "/" + std::to_string(device->rssi()) + "/" + std::to_string(device->paired()) + "/" + std::to_string(device->connected()) + "/" + device->alias(); //+ "/" + std::to_string(device->battery_percentage()); // + "/" + std::to_string(device->battery_percentage());
                m_sendEvents = true;
                AnotheroneBlePlugin::sendScannedUpdate(scannedDevice);
            }
            });
        is_listening = true;
    }
}

void AnotheroneBlePlugin::onCancel(){

    m_sendEvents = false;
    printf("c++: before discovery_stop();");
    m_adapter->discovery_stop();
    printf("c++: after discovery_stop();");
    millisecond_delay(1000);

    async_thread_active = false;
    if (async_thread && async_thread->joinable()) {
        async_thread->join();
    }
    async_thread.reset();
    is_listening = false;
    scannedDevices.clear();
}

void AnotheroneBlePlugin::onClearScanned(const MethodCall &call){
    scannedDevices.clear();
}

void AnotheroneBlePlugin::onGetAdapterPowered(const MethodCall &call)
{
    bool adapterPowered = m_adapter->powered();
    call.SendSuccessResponse(adapterPowered);
}

void AnotheroneBlePlugin::onGetAdapterDiscovering(const MethodCall &call)
{
    bool adapterDiscovering = m_adapter->discovering();
    call.SendSuccessResponse(adapterDiscovering);
}

void AnotheroneBlePlugin::onGetAdapterIdentifier(const MethodCall &call)
{
    std::string identifierAndAddress = m_adapter->identifier() + "/" + m_adapter->address();
    call.SendSuccessResponse(identifierAndAddress);
}

void AnotheroneBlePlugin::onGetPairedList(const MethodCall &call)
{
    m_paired_vector.clear();
    auto paired_list = m_adapter->device_paired_get();
    for (auto& device : paired_list) {
        m_paired_vector.push_back(device->address() + " - " +  device->name());
    }

    std::string pairedString =  vectorToString(m_paired_vector, '&');
    call.SendSuccessResponse(pairedString);
}

//void AnotheroneBlePlugin::onStopScanning(const MethodCall &call)
//{
//    AnotheroneBlePlugin::onCancel();
//}

void AnotheroneBlePlugin::sendScannedUpdate(std::string scannedDevice){
    if (m_sendEvents)
        EventChannel("anotherone_ble_event_scanning", MethodCodecType::Standard).SendEvent(scannedDevice);
}

void AnotheroneBlePlugin::onDeviceConnect(const MethodCall &call){

    Encodable::String keyMap = "address";
    std::string address = call.GetArgument<Encodable::String>(keyMap);

    auto device = scannedDevices[address];

    if(!device->connected()){
        if (not async_thread_active)
        {
            async_thread_active = true;
            async_thread = std::make_unique<std::thread>([this] { this->async_thread_function(); }); // dangling pointer
        }

        try {
            device->connect();
        } catch (SimpleDBus::Exception::SendFailed& e) {
                millisecond_delay(100);     
        }
      
        if (not is_listening)
        {
            if (async_thread && async_thread->joinable()) {
                async_thread->join();
            }
            async_thread.reset();
            async_thread_active = false;
        }
    }
}

void AnotheroneBlePlugin::unimplemented(const MethodCall &call)
{
    call.SendSuccessResponse(nullptr);
}