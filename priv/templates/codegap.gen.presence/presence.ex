defmodule <%= module %> do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`MixCodegenGap.Presence`](http://hexdocs.pm/mix_codegen_gap/MixCodegenGap.Presence.html)
  docs for more details.
  """
  use MixCodegenGap.Presence, otp_app: <%= inspect otp_app %>,
                        pubsub_server: <%= inspect pubsub_server %>
end
