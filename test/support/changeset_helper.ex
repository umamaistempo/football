defmodule Football.Test.Support.ChangesetHelper do
  @moduledoc """
  Helpers to test changesets.
  """

  alias Ecto.Changeset

  @spec failed_validations(Changeset.t(), Keyword.t()) :: %{optional(atom) => [atom]} | no_return
  @doc """
  Returns a map with each failed validation name as a value.

  Note that it includes all the data fields even if when their validation didn't
  fail to help writing code.

  ## Example
      iex> changeset = %Ecto.Changeset{
      ...>   data: %{foo: :bar, baz: :bla},
      ...>   errors: [foo: {"bla", validation: :required}],
      ...>   types: []
      ...> }
      ...> Football.Test.Support.ChangesetHelper.failed_validations(changeset)
      %{baz: [], foo: [:required]}

      iex> changeset = %Ecto.Changeset{
      ...>   data: %{foo: :bar, baz: :bla},
      ...>   errors: [
      ...>     foo: {"bla", validation: :required},
      ...>     foo: {"bla", validation: :length}
      ...>   ],
      ...>   types: []
      ...> }
      ...> Football.Test.Support.ChangesetHelper.failed_validations(changeset)
      %{baz: [], foo: [:required, :length]}

      iex> changeset = %Ecto.Changeset{
      ...>   data: %{foo: :bar, baz: :bla},
      ...>   errors: [foo: {"bla", validation: :required}],
      ...>   types: []
      ...> }
      ...> Football.Test.Support.ChangesetHelper.failed_validations(changeset, all_fields?: false)
      %{foo: [:required]}
  """
  def failed_validations(changeset, opts \\ []) do
    errors =
      Changeset.traverse_errors(changeset, fn {_, opts} ->
        Keyword.fetch!(opts, :validation)
      end)

    if Keyword.get(opts, :all_fields?, true) do
      changeset.data
      |> Map.keys()
      |> Map.new(&{&1, []})
      |> Map.merge(errors)
    else
      errors
    end
  end
end
