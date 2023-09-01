defmodule BonnyDispatch.Controller.MyResourceControllerTest do
  @moduledoc false
  use ExUnit.Case, async: false
  use Bonny.Axn.Test

  alias BonnyDispatch.Controller.MyResourceController

  test "add is handled and returns axn" do
    axn = axn(:add)
    result = MyResourceController.call(axn, [])
    assert is_struct(result, Bonny.Axn)
  end

  test "modify is handled and returns axn" do
    axn = axn(:modify)
    result = MyResourceController.call(axn, [])
    assert is_struct(result, Bonny.Axn)
  end

  test "reconcile is handled and returns axn" do
    axn = axn(:reconcile)
    result = MyResourceController.call(axn, [])
    assert is_struct(result, Bonny.Axn)
  end

  test "delete is handled and returns axn" do
    axn = axn(:delete)
    result = MyResourceController.call(axn, [])
    assert is_struct(result, Bonny.Axn)
  end
end
