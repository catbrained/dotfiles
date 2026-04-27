{ ... }:
{
  config = {
    security.acme = {
      acceptTerms = true;
      defaults = {
        # email = "staging.letsencrypt@catbrained.dev";
        # server = "https://acme-staging-v02.api.letsencrypt.org/directory";
        email = "letsencrypt@catbrained.dev";
        profile = "shortlived";
      };
    };
  };
}
