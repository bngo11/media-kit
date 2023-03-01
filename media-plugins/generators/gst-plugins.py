#!/usr/bin/env python3

import json

LIBNICE_GITLAB_ID = 163

async def generate(hub, **pkginfo):
	gitlab_id = pkginfo["gitlab_id"]

	if "pkgname" in pkginfo:
		name = pkginfo["pkgname"]
	else:
		name = pkginfo["name"]

	json_data = await hub.pkgtools.fetch.get_page(f"https://gitlab.freedesktop.org/api/v4/projects/{gitlab_id}/repository/tags?per_page=100")
	json_list = json.loads(json_data)
	version = None

	for release in json_list:
		try:
			version = release["name"]
			list(map(int, version.split(".")))
			if gitlab_id == LIBNICE_GITLAB_ID:
				break
			elif int(version.split('.')[1]) % 2 == 0:
				if "latest_ver" not in pkginfo:
					break
				else:
					if float(".".join(version.split(".")[:2])) >= float(pkginfo["latest_ver"]):
						break

		except (KeyError, IndexError, ValueError):
			continue
	else:
		version = None

	if version:
		if "template" not in pkginfo:
			pkginfo["template"] = "gst-plugins.tmpl"

		if pkginfo["metapkg"]:
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
