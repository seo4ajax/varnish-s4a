# 
# MIT License
# 
# Copyright (c) 2020 Capsule Code
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# 
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
