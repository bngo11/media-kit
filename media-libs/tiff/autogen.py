#!/usr/bin/env python3

import json

async def generate(hub, **pkginfo):
	json_data = await hub.pkgtools.fetch.get_page("https://gitlab.com/api/v4/projects/4720790/repository/tags", is_json=True)
	version = None

	for item in json_data:
		try:
			version = item["name"].strip('v')
			list(map(int, version.split(".")))
			break

		except (KeyError, IndexError, ValueError):
			continue

	if version:
		url = f'https://download.osgeo.org/libtiff/tiff-{version}.tar.xz'
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url, final_name=url.rsplit('/', 1)[-1])]
		)
		ebuild.push()

# vim: ts=4 sw=4 noet
