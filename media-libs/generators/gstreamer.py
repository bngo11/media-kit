#!/usr/bin/env python3

import json

async def generate(hub, **pkginfo):
	gitlab_id = pkginfo["gitlab_id"]
	json_data = await hub.pkgtools.fetch.get_page(f"https://gitlab.freedesktop.org/api/v4/projects/{gitlab_id}/repository/tags")
	json_list = json.loads(json_data)
	version = None

	if "version" not in pkginfo:
		for release in json_list:
			try:
				version = release["name"]
				if version.split('.')[0:-1] == pkginfo["base_version"].split('.'):
					break

			except (KeyError, IndexError):
				continue
	else:
		version = pkginfo["version"]

	if version:
		name = pkginfo["name"]
		url = f"https://gstreamer.freedesktop.org/src/{name}/{name}-{version}.tar.xz"
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			template=f"{name}.tmpl",
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url)],
		)

		ebuild.push()


# vim: ts=4 sw=4 noet
