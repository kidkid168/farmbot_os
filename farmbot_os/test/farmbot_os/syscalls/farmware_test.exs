defmodule FarmbotOS.SysCalls.FarmwareTest do
  use ExUnit.Case, async: true
  use Mimic

  setup :verify_on_exit!

  test "farmware_timeout" do
    fake_pid = :FAKE_PID

    expect(FarmbotCore.LogExecutor, :execute, fn log ->
      expected =
        "Farmware did not exit after 60.0 seconds. Terminating :FAKE_PID"

      assert log.message == expected
      :ok
    end)

    expect(FarmbotCore.FarmwareRuntime, :stop, fn pid ->
      assert pid == fake_pid
    end)

    assert :ok == FarmbotOS.SysCalls.Farmware.farmware_timeout(fake_pid)
  end
end
