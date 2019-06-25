defmodule FarmbotOS.Platform.Target.Configurator.VintageNetworkLayer do
  @behaviour FarmbotOS.Configurator.NetworkLayer

  @impl FarmbotOS.Configurator.NetworkLayer
  def list_interfaces() do
    VintageNet.all_interfaces()
    |> Kernel.--(["usb0", "lo"])
    |> Enum.map(fn ifname ->
      {ifname, %{mac_address: "fixme"}}
    end)
  end

  @impl FarmbotOS.Configurator.NetworkLayer
  def scan(ifname) do
    VintageNet.get_by_prefix(["interface", ifname, "wifi", "access_points"])
    |> Enum.at(0)
    |> elem(1)
    |> Enum.map(fn {_bssid, %{bssid: bssid, ssid: ssid, signal_percent: signal, flags: flags}} ->
      %{
        ssid: ssid,
        bssid: bssid,
        level: signal,
        security: flags_to_security(flags)
      }
    end)
  end

  defp flags_to_security([:wpa2_psk_ccmp | _]), do: "WPA-PSK"
  defp flags_to_security([:wpa2_eap_ccmp | _]), do: "WPA-EAP"
  defp flags_to_security([_ | rest]), do: flags_to_security(rest)
  defp flags_to_security([]), do: "NONE"
end
