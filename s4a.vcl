
# Add the support of SEO4Ajax in Varnish
vcl 4.1;

import dynamic;

sub vcl_init {
    new api_s4a = dynamic.director(
        port = "80",
        ttl = 2m
    );
}

sub vcl_recv {
    if ((req.http.user-agent ~ "google|bot|spider|pinterest|crawler|archiver|flipboardproxy|mediapartners|facebookexternalhit|insights|quora|whatsapp|slurp") &&
        (req.url !~ ".*(\.[^?]{2,4}$|\.[^?]{2,4}\?.*$)")) {
        set req.backend_hint = api_s4a.backend("api.seo4ajax.com");
        set req.url = "/" + "<site token in SEO4Ajax>" + req.url;
    }
}
