#!/usr/bin/env python3

import json

async def generate(hub, **pkginfo):
	json_data = await hub.pkgtools.fetch.get_page("https://api.github.com/repos/libjpeg-turbo/libjpeg-turbo/releases", is_json=True)
	version = None

	for item in json_data:
		try:
			if not item["prerelease"]:
				version = item["tag_name"]
				list(map(int, version.split(".")))
				break

		except (IndexError, ValueError, KeyError):
			continue

	if version:
		url = f"https://sourceforge.net/projects/libjpeg-turbo/files/{version}/libjpeg-turbo-{version}.tar.gz"
		url2 = f"https://gentoo.osuosl.org/distfiles/libjpeg8_8d-2.debian.tar.gz"
		final_name = f"libjpeg-turbo-{version}.tar.gz"
		ebuild = hub.pkgtools.ebuild.BreezyBuild(
			**pkginfo,
			version=version,
			artifacts=[hub.pkgtools.ebuild.Artifact(url=url, final_name=final_name),
						hub.pkgtools.ebuild.Artifact(url=url2)]
		)

		ebuild.push()

# vim: ts=4 sw=4 noet
