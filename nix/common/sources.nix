{ system }:
let
  rust = {
    x86_64-linux = {
      triple = "x86_64-unknown-linux-gnu";
      hash = "sha256-qZv+5pIh6f9thjiPaBHuaIzUBeagQAo80XhOjUY+nZk=";
    };
    aarch64-linux = {
      triple = "aarch64-unknown-linux-gnu";
      hash = "sha256-3G76iQaElghJfC/7PWqUZliINaebXoiGwineEzZAlFw=";
    };
  }.${system};

  gcc = {
    x86_64-linux = {
      triple = "x86_64-linux-gnu";
      hash = "sha256-49d60UVEgUUnu+ei0PeexFkqTiM5LFHHOIwOaGtqaXc=";
    };
    aarch64-linux = {
      triple = "aarch64-linux-gnu";
      hash = "sha256-Zq5Wdya516sjSxbf675ae6iJFGO/s+KMxKRcUJybC3s=";
    };
  }.${system};
in {

  espRustVersion = "1.97.0.0";
  espGccVersion = "15.2.0_20250920";
  espRustSrcHash = "sha256-Vo1oi5+PMy7E0EZXVE+tI+mc4R6ebPWDWXnmiijGi3M=";
  inherit rust gcc;

}
