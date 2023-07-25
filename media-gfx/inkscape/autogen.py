#!/usr/bin/env python3

import json

async def generate(hub, **pkginfo):
	json_data = await hub.pkgtools.fetch.get_page("https://gitlab.com/api/v4/projects/3472737/releases", is_json=True)
	version = None
	commit = None
	date = None

	for item in json_data:
		try:
			commit = item["commit"]["id"][:10]
			date = item["commit"]["created_at"].split("T")[0]
			version = item["tag_name"].split("_")[1:]
			list(map(int, version))
			if int(version[1]) % 2:
				continue
			version = ".".join(version)
			break

		except (KeyError, IndexError, ValueError):
			continue
	else:
		version = None

	if version:
		final_name = f"inkscape-{version}.tar.xz"
		url = f"https://media.inkscape.org/dl/resources/file/{final_name}"
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			srcdir=f"inkscape-{version}_{date}_{commit}",
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url, final_name=final_name)]
		)
		ebuild.push()

# vim: ts=4 sw=4 noet
