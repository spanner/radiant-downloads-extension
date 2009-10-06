# Downloads

This is a simple and fairly thin extension that makes it easy to protect file downloads using nginx's internal redirects. It works something like this:

* You upload a file using the admin interface and grant access to a couple of reader groups. The file is stored outside the /public folder and can't be reached with a web browser
* A thin public-facing controller takes download requests and checks them against group membership
* If you're not allowed, it redirects you to reader login or just tells you off
* If you are allowed, it returns an attachment-download response pointing to a fictional address in /secure_download but with the `X-Accel-Redirect` header set to the real address of your file
* Your nginx configuration intercepts the `X-Accel-Redirect` header, ignores the request address and returns the file
* Your web browser reads the request address and gets the right file name
* Your nginx configuration also makes sure that typing in the /secure_download address doesn't give file access

In other words, there is no way to get at the uploaded file without going through the authenticating controller. The original inspiration is [in Alexei Kovyrin's blog](http://blog.kovyrin.net/2006/11/01/nginx-x-accel-redirect-php-rails/).

It ought to be an easy matter to make this work with Apache and sendfile, but I haven't needed to.

As with other group-access-control, a download with no groups attached is considered available, but here we are more restrictive and only make it available to logged in readers. If you want to publish a document for the public, you'd be better advised to upload it as a paperclipped asset.

## Status

Should be reliable. It's quite well-established code. The original version used file_column so I've spent some time bringing it across to paperclip and writing proper tests.

## Requirements

This uses spanner's [reader](https://github.com/spanner/radiant-reader-extension) and [reader_group](https://github.com/spanner/radiant-reader_group-extension) extensions for access control. If you would like to change the basis for allowing downloads, the easiest thing is probably to override or chain `Download#available_to?`. But do tell us what you're trying to do. We like to be useful.

Also requires [paperclip](http://www.thoughtbot.com/projects/paperclip) gem, or the paperclipped extension (which currently vendors paperclip).

(We thought about just applying access control to paperclipped assets but the machinery there is too specialised for images: most of what goes in here will be pdfs and office documents. The separate store is tricky too.)

This should be straightforwardly `multi_site` compatible. If you use our [fork of multi_site](https://github.com/spanner/radiant-multi-site-extension/) then downloads (and readers and groups) will be site-scoped.

## Configuration

### In nginx

This is what I use:

	location /secure_download/ {
		internal;
		root /your/site/directory/current/secure_downloads;	
		default_type  application/pdf;
		expires 1h;
		add_header  Cache-Control  private;
		break;
	}

but I'm no nginx rypy. Suggestions would be very welcome. 

(And naturally a security-minded person would only put this in the SSL-enabled version of the site, with the appropriate measures to direct people there).

### In capistrano

Ideally we will be storing downloads in the shared directory rather than in /current, so that they persist through deployments. I can't see a good way to get at that directory without making unhelpful assumptions in the model, so instead I will assume that if you use capistrano, you're doing the right thing with symlinks on deployment:

	after "deploy:setup" do
		sudo "mkdir -p #{shared_path}/secure_downloads"
		sudo "chown -R #{user}:#{group} #{shared_path}/secure_downloads"
	end
	
	after "deploy:update" do
		run "ln -s #{shared_path}/secure_downloads #{current_release}/secure_downloads" 
	end
	
Note that secure_downloads is not inside the public site.

## Usage

You'll see a 'downloads' tab in admin. Add files to the list there and you can link to them like this:



## Bugs and comments

In [lighthouse](http://spanner.lighthouseapp.com/projects/26912-radiant-extensions), please, or for little things an email or github message is fine.

## Author and copyright

* Copyright spanner ltd 2007-9.
* Released under the same terms as Rails and/or Radiant.
* Contact will at spanner.org
