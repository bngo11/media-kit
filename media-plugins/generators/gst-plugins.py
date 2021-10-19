#!/usr/bin/env python3

import json

GSTREAMER_GITLAB_ID = 1357
LIBNICE_GITLAB_ID = 163

async def generate(hub, **pkginfo):
	if "gitlab_id" in pkginfo:
		gitlab_id = pkginfo["gitlab_id"]
	else:
		gitlab_id = GSTREAMER_GITLAB_ID

	if "pkgname" in pkginfo:
		name = pkginfo["pkgname"]
	else:
		name = pkginfo["name"]

	json_data = await hub.pkgtools.fetch.get_page(f"https://gitlab.freedesktop.org/api/v4/projects/{gitlab_id}/repository/tags")
	json_list = json.loads(json_data)
	version = None

	if "version" in pkginfo:
		version = pkginfo["version"]
	else:
		for release in json_list:
			try:
				version = release["name"]
				if version.split('.')[0:-1] == pkginfo["base_version"].split('.'):
					break

			except (KeyError, IndexError):
				continue

	if version:
		if "template" not in pkginfo:
			pkginfo["template"] = "gst-plugins.tmpl"

		if gitlab_id in [GSTREAMER_GITLAB_ID, LIBNICE_GITLAB_ID]:
			url = "https://gstreamer.freedesktop.org"
		else:
			url = f"https://gstreamer.freedesktop.org/src/{name}/{name}-{version}.tar.xz"

		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url)],
		)

		ebuild.push()

# vim: ts=4 sw=4 noet
