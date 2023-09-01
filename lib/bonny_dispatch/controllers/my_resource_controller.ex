defmodule BonnyDispatch.Controller.MyResourceController do
  @moduledoc """
  BonnyDispatch: MyResourceController controller.

  """
  use Bonny.ControllerV2

  step Bonny.Pluggable.SkipObservedGenerations
  step :handle_event

  # apply the resource
  def handle_event(%Bonny.Axn{action: action} = axn, _opts)
      when action in [:add, :modify, :reconcile] do
    metadata = %{"namespace" => "default", "name" => axn.resource["metadata"]["name"]}

    depl = %{
      "apiVersion" => "apps/v1",
      "kind" => "Deployment",
      "metadata" => metadata,
      "spec" => %{
        "replicas" => 1,
        "selector" => %{
          "matchLabels" => %{
            "app" => "nginx"
          }
        },
        "template" => %{
          "metadata" => %{"labels" => %{"app" => "nginx"}},
          "spec" => %{
            "containers" => [
              %{
                "name" => "nginx",
                "image" => "nginx:1.14.2",
                "ports" => [%{"containerPort" => 80}]
              }
            ]
          }
        }
      }
    }

    svc = %{
      "apiVersion" => "v1",
      "kind" => "Service",
      "metadata" => metadata,
      "spec" => %{
        "selector" => %{"app" => "nginx"},
        "ports" => [%{"protocol" => "TCP", "port" => 80, "targetPort" => 80}]
      }
    }

    axn
    |> Bonny.Axn.register_descendant(depl)
    |> Bonny.Axn.register_descendant(svc)
    |> success_event()
  end

  # delete the resource
  def handle_event(%Bonny.Axn{action: :delete} = axn, _opts) do
    axn
  end
end
