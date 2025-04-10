let
  deploy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDzPrPPEas38nmBflAEHKwJ5COtZwGBOjQ/wAcM4Hit1 syntropy deploy key";
  hosts = "age1zut5h7g0m89wr9cltnrtxcwjhx0w22n0u6sahywefe0t9xfxl5ksl0zymz";
in
{
  "wifi.age".publicKeys = [ deploy hosts ];
  "wg-cypher.age".publicKeys = [ deploy hosts ];
  "wg-captainhook.age".publicKeys = [ deploy hosts ];
}
