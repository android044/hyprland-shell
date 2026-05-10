qml_module(hyprlandsh-internal
    URI Hyprlandsh.Internal
    SOURCES
        arcgauge.cpp
        circularbuffer.cpp
        circularindicatormanager.cpp
        hyprdevices.cpp
        hyprextras.cpp
        logindmanager.cpp
        sparklineitem.cpp
        visualiserbars.cpp
    LIBRARIES
        Qt::Gui
        Qt::Quick
        Qt::Network
        Qt::DBus
)
