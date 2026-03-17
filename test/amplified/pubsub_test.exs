# Tests have been split into individual files under test/amplified/pubsub/:
#
#   config_test.exs      — endpoint/0, pubsub_server/0
#   channel_test.exs     — channel/2 for all types
#   broadcast_test.exs   — broadcast/2,3 for all types
#   subscribe_test.exs   — subscribe/1, unsubscribe/1, unsupported operations
#   handle_info_test.exs — Tuple dispatcher
#   impl_for_test.exs    — impl_for/1, impl_for!/1
#   pipeline_test.exs    — end-to-end CRUD pipeline
