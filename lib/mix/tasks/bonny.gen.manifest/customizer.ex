defmodule Mix.Tasks.Bonny.Gen.Manifest.BonnyDispatchCustomizer do
  @moduledoc """
  Implements a callback to override manifests generated by `mix bonny.gen.manifest`
  """

  @doc """
  This function is called for every resource generated by `mix bonny.gen.manifest`.
  Use pattern matching to override specific resources.

  Be careful in your pattern matching. Sometimes the map keys are strings,
  sometimes they are atoms.

  ### Examples

  def override(%{kind: "ServiceAccount"} = resource) do
    put_in(resource, ~w(metadata labels foo)a, "bar")
  end
  """

  @spec override(Bonny.Resource.t()) :: Bonny.Resource.t()

  # fallback
  def override(resource), do: resource
end
