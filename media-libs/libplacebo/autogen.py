#!/usr/bin/env python3

import json
import os
from packaging.version import Version

async def generate(hub, **pkginfo):
	json_data = await hub.pkgtools.fetch.get_page(f"https://code.videolan.org/api/v4/projects/380/repository/tags", is_json=True)
	version = None
	glad_version = None

	for item in json_data:
		try:
			version = item["name"].strip("v")
			list(map(int, version.split(".")))
			break

		except (IndexError, AttributeError, ValueError, KeyError):
			continue

	json_data = await hub.pkgtools.fetch.get_page(f"https://api.github.com/repos/Dav1dde/glad/tags", is_json=True)

	for item in json_data:
		try:
			glad_version = item["name"].strip("v")
			list(map(int, version.split(".")))
			break

		except (IndexError, AttributeError, ValueError, KeyError):
			continue


	if version and glad_version:
		final_name = f"libplacebo-v{version}.tar.gz"
		glad_final_name = f"libplacebo-glad-{glad_version}.tar.gz"
		url = f"https://code.videolan.org/videolan/libplacebo/-/archive/v{version}/{final_name}"
		glad_url = f"https://github.com/Dav1dde/glad/archive/refs/tags/v{glad_version}.tar.gz"
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			python_compat = "python3+",
			version=version,
			glad_version=glad_version,
			artifacts=[
				hub.pkgtools.ebuild.Artifact(url=url, final_name=final_name),
				hub.pkgtools.ebuild.Artifact(url=glad_url, final_name=glad_final_name),
			],
		)

		ebuild.push()
# vim: ts=4 sw=4 noet
