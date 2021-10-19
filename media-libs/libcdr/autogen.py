#!/usr/bin/env python3

import json

async def generate(hub, **pkginfo):
	json_data = await hub.pkgtools.fetch.get_page("https://api.github.com/repos/freedesktop/libreoffice-libcdr/tags", is_json=True)
	version = None

	for item in json_data:
		try:
			version = item['name'].split('-')[-1]
			list(map(int, version.split(".")))
			break

		except (IndexError, AttributeError, KeyError):
			continue

	if version:
		url = f"https://dev-www.libreoffice.org/src/libcdr/libcdr-{version}.tar.xz"
		final_name = f"libcdr-{version}.tar.xz"
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url, final_name=final_name)]
		)

		ebuild.push()

# vim: ts=4 sw=4 noet
