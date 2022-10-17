#!/usr/bin/env python3

import json

async def generate(hub, **pkginfo):
	json_data = await hub.pkgtools.fetch.get_page("https://api.github.com/repos/espeak-ng/espeak-ng/releases", is_json=True)
	version = None

	for item in json_data:
		try:
			if item["prerelease"] or item["draft"]:
				continue

			version = item["tag_name"]
			list(map(int, version.split(".")))
			break

		except (KeyError, IndexError, ValueError):
			continue
	else:
		version = None

	if version:
		final_name = f"espeak-ng-{version}.tar.gz"
		url = f"https://github.com/espeak-ng/espeak-ng/archive/{version}.tar.gz"
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url, final_name=final_name)]
		)
		ebuild.push()

# vim: ts=4 sw=4 noet
