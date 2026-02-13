#!/usr/bin/env python3

import json
from bs4 import BeautifulSoup

LIBNICE_GITLAB_ID = 163

async def generate(hub, **pkginfo):
	gitlab_id = pkginfo["gitlab_id"]

	if "pkgname" in pkginfo:
		name = pkginfo["pkgname"]
	else:
		name = pkginfo["name"]

	version = None
	gst_vaapi_version = None

	if name in ['gstreamer-vaapi', 'gst-plugins-meta']:
		html_data = await hub.pkgtools.fetch.get_page(f"https://gstreamer.freedesktop.org/src/gstreamer-vaapi/")
		soup = BeautifulSoup(html_data, "html.parser")
		links = soup.find_all("a")
		links.reverse()

		for link in links:
			href = link.get("href")
			if href and "tar.xz" in href:
				parts = href.rsplit("-", 1)
				gst_vaapi_version = version = parts[-1].rsplit(".", 2)[0]

				try:
					list(map(int, version.split(".")))
					break

				except ValueError:
					continue

	if name not in ['gstreamer-vaapi']:
		json_data = await hub.pkgtools.fetch.get_page(f"https://gitlab.freedesktop.org/api/v4/projects/{gitlab_id}/repository/tags?per_page=100")
		json_list = json.loads(json_data)

		for release in json_list:
			try:
				version = release["name"]
				list(map(int, version.split(".")))
				if gitlab_id == LIBNICE_GITLAB_ID:
					break
				elif int(version.split('.')[1]) % 2 == 0:
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
		if "template" not in pkginfo:
			pkginfo["template"] = "gst-plugins.tmpl"

		if pkginfo["metapkg"]:
			url = "https://gstreamer.freedesktop.org"
		else:
			url = f"https://gstreamer.freedesktop.org/src/{name}/{name}-{version}.tar.xz"

		if name in ['gst-plugins-meta']:
			ebuild = hub.pkgtools.ebuild.BreezyBuild(
				**pkginfo,
				version=version,
				gst_vaapi_version=gst_vaapi_version,
				artifacts=[hub.pkgtools.ebuild.Artifact(url=url)],
			)
		else:
			ebuild = hub.pkgtools.ebuild.BreezyBuild(
				**pkginfo,
				version=version,
				artifacts=[hub.pkgtools.ebuild.Artifact(url=url)],
			)

		ebuild.push()

# vim: ts=4 sw=4 noet
