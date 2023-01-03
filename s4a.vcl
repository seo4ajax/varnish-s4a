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

# Description:
# Varnish Cache 6+ configuration for serving pre-rendered pages using 
# seo4ajax.com
#
# Installation:
# 1. Install the Varnish Cache module vmod-dynamic from here:
#    https://github.com/nigoroll/libvmod-dynamic#installation
# 2. Copy this file into the configuration directory of Varnish Cache 
#    (e.g. /etc/varnish/)
# 3. Open the s4a.vcl file and replace <site token in SEO4Ajax> with the site 
#    token in SEO4Ajax (e.g. f594d3367b818ecefe28e9caba24fe16)
# 4. Add include "s4a.vcl"; in the configuration file of Varnish Cache 
#    (e.g. /etc/varnish/default.vcl)
# 5. Restart Varnish Cache

vcl 4.1;

import dynamic;

sub vcl_init {
    new api_s4a = dynamic.director(
        port = "80",
        ttl = 2m
    );
}

sub vcl_recv {
    if ((req.http.user-agent ~ "google|bot|lighthouse|spider|pinterest|crawler|archiver|flipboardproxy|mediapartners|facebookexternalhit|insights|quora|whatsapp|slurp") &&
        (req.url !~ ".*(\.[^?]{2,4}$|\.[^?]{2,4}\?.*$)")) {
        set req.backend_hint = api_s4a.backend("api.seo4ajax.com");
        set req.url = "/" + "<site token in SEO4Ajax>" + req.url;
    }
}
