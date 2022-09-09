#!/usr/bin/env python3

import json

async def generate(hub, **pkginfo):
	json_data = await hub.pkgtools.fetch.get_page("https://gitlab.freedesktop.org/api/v4/projects/1357/repository/tags?per_page=100", is_json=True)
	version = None

	if "version" not in pkginfo:
		for release in json_data:
			try:
				version = release["name"]
				if int(version.split('.')[1]) % 2 == 0:
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
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url)],
		)

		ebuild.push()


# vim: ts=4 sw=4 noet
