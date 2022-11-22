#!/usr/bin/env python3

import json
import os

async def generate(hub, **pkginfo):
	json_data = await hub.pkgtools.fetch.get_page(f"https://code.videolan.org/api/v4/projects/380/repository/tags", is_json=True)
	version = None

	for item in json_data:
		try:
			version = item["name"].strip("v")
			list(map(int, version.split(".")))
			break

		except (IndexError, AttributeError, ValueError, KeyError):
			continue

	if version:
		final_name = f"libplacebo-v{version}.tar.gz"
		url = f"https://code.videolan.org/videolan/libplacebo/-/archive/v{version}/{final_name}"
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			python_compat = "python3+",
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url, final_name=final_name)]
		)

		ebuild.push()
# vim: ts=4 sw=4 noet
