defmodule Football.Test.Support.ChangesetHelper do
  alias Ecto.Changeset

  @spec failed_validations(Changeset.t(), Keyword.t()) :: %{optional(atom) => [atom]} | no_return
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
