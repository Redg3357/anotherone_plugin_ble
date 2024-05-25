#ifndef FLUTTER_PLUGIN_ANOTHERONE_BLE_PLUGIN_H
#define FLUTTER_PLUGIN_ANOTHERONE_BLE_PLUGIN_H

#include <flutter/plugin-interface.h>
#include <anotherone_ble/globals.h>

#include <memory>
#include <functional>
#include <simplebluez/Bluez.h>
#include <simplebluez/Exceptions.h>
#include <vector>
#include <string>
#include <sstream>
#include <atomic>
#include <chrono>
#include <thread>
#include <map>
#include <mutex>

class PLUGIN_EXPORT AnotheroneBlePlugin final : public PluginInterface
{
public:
    AnotheroneBlePlugin();
    void RegisterWithRegistrar(PluginRegistrar &registrar) override;
    void sendScannedUpdate(std::string scannedDevice);

    std::atomic_bool async_thread_active;
    std::atomic_bool is_listening;
    std::unique_ptr<std::thread> async_thread;

    void async_thread_function();
    ~AnotheroneBlePlugin();

private:
    void onMethodCall(const MethodCall &call);
    void onGetAdapterPowered(const MethodCall &call);
    void onGetAdapterDiscovering(const MethodCall& call);
    void onGetAdapterIdentifier(const MethodCall &call);
    void onGetAdaptersList(const MethodCall &call);
    void onGetPairedList(const MethodCall& call);
    void unimplemented(const MethodCall &call);
    //void onStartScanning(const MethodCall &call);
    //void onStopScanning(const MethodCall &call);
    void onDeviceConnect(const MethodCall &call);
    void onClearScanned(const MethodCall &call);


    void onListen();
    void onCancel();

    bool m_sendEvents;

    SimpleBluez::Bluez m_bluez;

    std::map<std::string, std::shared_ptr<SimpleBluez::Device>> scannedDevices;


    std::shared_ptr<SimpleBluez::Adapter> m_adapter;
    std::vector<std::shared_ptr<SimpleBluez::Adapter>> m_adapters;

    std::vector<std::string> m_adapters_vector;
    std::vector<std::string> m_paired_vector;

};

#endif /* FLUTTER_PLUGIN_ANOTHERONE_BLE_PLUGIN_H */
