# Defer Register — QR Code Generator App

| ID | Item | Why Deferred | Trigger to Revisit |
|----|------|-------------|-------------------|
| DEFER-01 | Widget support (WidgetKit) | Brief: "optional, lower priority" | Kirt explicitly requests it post-initial build |
| DEFER-02 | History search/filter | Only 10 entries, FIFO; not needed for MVP | If history use grows beyond 10 entries |
| DEFER-03 | Custom QR colors/logos | Brief: simple QR generator; no customization requested | Kirt requests customization in future |
| DEFER-04 | SwiftData migration for history | UserDefaults sufficient for 10 entries | If history grows or performance degrades |
