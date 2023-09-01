defmodule BonnyDispatch.Pluggable.Dispatch do
  @moduledoc false

  require Logger

  def init(opts) do
    opts
  end

  def call(%{action: action} = token, _opts) when action in [:modify, :delete] do
    %{resource: %{"metadata" => %{"namespace" => namespace, "ownerReferences" => owner_refs}}} =
      token

    %{"kind" => kind, "apiVersion" => api_version, "name" => name, "uid" => uid} =
      List.first(owner_refs)

    module = Module.safe_concat(["BonnyDispatch.Controller", "#{kind}Controller"])

    new_resource = %{
      "apiVersion" => api_version,
      "kind" => kind,
      "metadata" => %{"name" => name, "namespace" => namespace, "uid" => uid}
    }

    token
    |> Map.put(:action, :reconcile)
    |> Map.put(:resource, new_resource)
    |> Map.put(:controller, {module, []})
  end

  def call(token, _opts), do: token
end
