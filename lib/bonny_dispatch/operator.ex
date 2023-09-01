defmodule BonnyDispatch.Operator do
  @moduledoc """
  Defines the operator.

  The operator resource defines custom resources, watch queries and their
  controllers and serves as the entry point to the watching and handling
  processes.
  """

  use Bonny.Operator, default_watch_namespace: "default"

  step Bonny.Pluggable.Logger, level: :info
  step BonnyDispatch.Pluggable.Dispatch
  step :delegate_to_controller
  step Bonny.Pluggable.ApplyStatus
  step Bonny.Pluggable.ApplyDescendants

  @impl Bonny.Operator
  def controllers(watching_namespace, _opts) do
    [
      %{
        query:
          K8s.Client.watch("test.airnity.net/v1alpha1", "MyResource",
            namespace: watching_namespace
          ),
        controller: BonnyDispatch.Controller.MyResourceController
      },
      %{query: K8s.Client.watch("apps/v1", "Deployment", namespace: watching_namespace)},
      %{query: K8s.Client.watch("v1", "Service", namespace: watching_namespace)}
    ]
  end

  @impl Bonny.Operator
  def crds() do
    [
      %Bonny.API.CRD{
        names: %{
          kind: "MyResource",
          plural: "myresources",
          shortNames: [],
          singular: "myresource"
        },
        group: "test.airnity.net",
        versions: [BonnyDispatch.API.V1Alpha1.MyResource],
        scope: :Namespaced
      }
    ]
  end
end
