{ ... }:
{
  # This block is necessary to complement the nginx setup nixarr already handles.
  #
  # By default, the nginx setup doesn't reject SSL for unknown domains (unknown in this
  # case being anything that isn't set in the nixarr expose block, for example a DDNS
  # route), which means an insecure version of the exposed endpoints could be accessible.
  services.nginx = {
    virtualHosts."_" = {
      default = true;
      rejectSSL = true; # dont try to use SSL for unknown domains, rejects DDNS endpoint for example
      locations."/" = {
        return = "444"; # "no response" (closes connection)
      };
    };
  };
}
