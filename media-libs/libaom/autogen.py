#!/usr/bin/env python3

import json

async def generate(hub, **pkginfo):
	json_data = await hub.pkgtools.fetch.get_page("https://gitlab.com/api/v4/projects/21349575/repository/tags", is_json=True)
	version = None

	for item in json_data:
		try:
			version = item['name'].strip('v')
			list(map(int, version.split(".")))
			break

		except (IndexError, ValueError, KeyError):
			continue

	if version:
		url = f"https://storage.googleapis.com/aom-releases/libaom-{version}.tar.gz"
		final_name = f"libaom-{version}.tar.gz"
		slot = version.split(".")[0]
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			slot=slot,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url, final_name=final_name)]
		)

		ebuild.push()

# vim: ts=4 sw=4 noet
