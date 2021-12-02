#!/usr/bin/env python3

import json

GSTREAMER_GITLAB_ID = 1357

async def generate(hub, **pkginfo):
	json_data = await hub.pkgtools.fetch.get_page(f"https://gitlab.freedesktop.org/api/v4/projects/{GSTREAMER_GITLAB_ID}/repository/tags?per_page=100")
	json_list = json.loads(json_data)
	gst_base_version = "1.18" # lastest stable
	gst_version = None

	for release in json_list:
		try:
			gst_version = release["name"]
			if gst_version.split('.')[0:-1] == gst_base_version.split('.'):
				break

		except (KeyError, IndexError):
			continue
	else:
		gst_version = None

	if gst_version:
		pkginfo["gst_ver"] = gst_version
		json_data = await hub.pkgtools.fetch.get_page(f"https://gitlab.gnome.org/api/v4/projects/817/repository/tags")
		json_list = json.loads(json_data)
		version = None

		if "version" not in pkginfo:
			for release in json_list:
				try:
					version = release["name"]
					verifyVer = release["message"].split()[1]

					if version != verifyVer:
						version = verifyVer

					break

				except KeyError:
					continue
		else:
			version = pkginfo["version"]

		if version:
			name = pkginfo["name"]
			url = f"https://download.gnome.org/sources/pitivi/{version.split('.')[0]}/{name}-{version}.tar.xz"
			ebuild = hub.pkgtools.ebuild.BreezyBuild(
				**pkginfo,
				version=version,
				artifacts=[hub.pkgtools.ebuild.Artifact(url=url)],
			)

			ebuild.push()


# vim: ts=4 sw=4 noet
