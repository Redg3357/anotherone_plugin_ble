#ifndef FLUTTER_PLUGIN_ANOTHERONE_BLE_PLUGIN_H
#define FLUTTER_PLUGIN_ANOTHERONE_BLE_PLUGIN_H

#include <flutter/plugin-interface.h>
#include <anotherone_ble/globals.h>

class PLUGIN_EXPORT AnotheroneBlePlugin final : public PluginInterface
{
public:
    void RegisterWithRegistrar(PluginRegistrar &registrar) override;

private:
    void onMethodCall(const MethodCall &call);
    void onGetAdapterPowered(const MethodCall &call);
    void onGetAdapterIdentifier(const MethodCall &call);
    void unimplemented(const MethodCall &call);
};

#endif /* FLUTTER_PLUGIN_ANOTHERONE_BLE_PLUGIN_H */
