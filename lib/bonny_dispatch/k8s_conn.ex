defmodule BonnyDispatch.K8sConn do
  @moduledoc """
  Initializes the %K8s.Conn{} struct depending on the mix environment.
  To be used in config.exs (bonny.exs):

  ```
  get_conn: {BonnyDispatch.K8sConn, :get!, [config_env()]},
  ```
  """

  @spec get!(atom()) :: K8s.Conn.t()
  def get!(:dev) do
    {:ok, conn} =
      K8s.Conn.from_file("~/.kube/config",
        context: "k3d-k3s-default",
        insecure_skip_tls_verify: true
      )

    conn
  end

  def get!(:test) do
    %K8s.Conn{
      discovery_driver: K8s.Discovery.Driver.File,
      discovery_opts: [config: "test/support/discovery.json"],
      http_provider: K8s.Client.DynamicHTTPProvider
    }
  end

  def get!(_) do
    {:ok, conn} = K8s.Conn.from_service_account()
    conn
  end
end
