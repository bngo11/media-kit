#!/usr/bin/env python3

import json

async def generate(hub, **pkginfo):
	gitlab_id = pkginfo["gitlab_id"]
	json_data = await hub.pkgtools.fetch.get_page(f"https://gitlab.freedesktop.org/api/v4/projects/{gitlab_id}/repository/tags?per_page=100")
	json_list = json.loads(json_data)
	version = None

	for release in json_list:
		try:
			version = release["name"]
			list(map(int, version.split(".")))
			if int(version.split(".")[1]) % 2 == 0:
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
